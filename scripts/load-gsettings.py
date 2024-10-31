#!/usr/bin/env python3

import json
import sys
import distro
import socket
from subprocess import check_output, call
from os.path import devnull, expanduser
from pathlib import Path

distro_info = distro.info()
distro_info['name'] = distro.name()

hostname = socket.gethostname()

FNULL = open(devnull, 'w')
read_cache = {}

def is_float(s):
	try:
		float(s)
		return True
	except ValueError:
		return False

def is_int(s):
	try:
		int(s)
		return True
	except ValueError:
		return False

def read_setting(schema, key, schemadir):
	cache_key = schema + '.' + key
	if not cache_key in read_cache:
		command = ['gsettings']
		if schemadir:
			command.extend(['--schemadir', expanduser(schemadir)])
		command.extend(['get', schema, key])
		read_cache[cache_key] = read_value(check_output(command).strip().decode('utf8'))
	return read_cache[cache_key]

def read_value(value):
	# empty string arrays start with @as, so remove it
	if value.startswith("@as "):
		value = value[4:]

	if value == 'true':
		return True
	elif value == 'false':
		return False
	elif value.startswith("["):
		return [read_value(v) for v in value[1:-1].split(', ')]
	elif value.startswith("'"):
		return value[1:-1].replace("\\'", "'")
	elif is_float(value):
		return float(value)
	elif is_int(value):
		return int(value)
	return value

def format_value(value):
	if isinstance(value, str):
		return "'" + value.replace("'", "\\'") + "'"
	if isinstance(value, bool):
		return 'true' if value else 'false'
	if isinstance(value, (int, float)):
		return str(value)
	if isinstance(value, list):
		return '[' + ', '.join([str(format_value(v)) for v in value]) + ']'
	return value

def set_value(schema, key, action):
	read_cache[schema + '.' + key] = action['value']

def clear_value(schema, key, action):
	value = read_setting(schema, key, action['schemadir'])
	if isinstance(value, bool):
		print('Invalid clear operation on boolean:', key)
	elif isinstance(value, str):
		read_cache[schema + '.' + key] = ""
	elif isinstance(value, list):
		read_cache[schema + '.' + key] = []
	else:
		print('Invalid clear operation on unknown type:', key)

def verify_writable(schema, key, schemadir):
	command = ['gsettings']
	if schemadir:
		command.extend(['--schemadir', expanduser(schemadir)])
	command.extend(['writable', schema, key])
	return call(command, stdout=FNULL) == 0


def write_setting(schema, key, schemadir):
	cache_key = schema + '.' + key
	if not cache_key in read_cache:
		return
	if not verify_writable(schema, key, schemadir):
		print('Skipping: %s %s is not writable' % (schema, key))
		return

	value = format_value(read_cache[cache_key])
	command = ['gsettings']
	if schemadir:
		command.extend(['--schemadir', expanduser(schemadir)])
	command.extend(['set', schema, key, value])
	check_output(command)

def add_value(schema, key, action):
	values = read_setting(schema, key, action['schemadir'])
	if action['value'] in values:
		values.remove(action['value'])
	if 'before' in action:
		i = values.index(action['before'])
		values.insert(i, action['value'])
	elif 'after' in action:
		i = values.index(action['after'])
		values.insert(i + 1, action['value'])
	elif 'first' in action and action['first']:
		values.insert(0, action['value'])
	else:
		values.append(action['value'])
	read_cache[schema + '.' + key] = values

def remove_value(schema, key, action):
	values = read_setting(schema, key, action['schemadir'])
	if action['value'] in values:
		values.remove(action['value'])
	read_cache[schema + '.' + key] = values

def check_condition(condition):
	if 'distro' in condition:
		if 'version' in condition['distro']:
			if condition['distro']['version'] != distro_info['version']:
				return False
		if 'name' in condition['distro']:
			if condition['distro']['name'] != distro_info['name']:
				return False
	return True

def process_file(setting_path):
	with open(setting_path) as f:
		settings = json.load(f)

	if 'target' in settings:
		target = settings['target']
		if 'hostname' in target and target['hostname'] != hostname:
			print("Hostname does not match, skipping")
			return

	schemas = settings['schemas']
	for schema in schemas:
		schemadir = schemas[schema].pop('.schemadir', None)
		for key in schemas[schema]:
			actions = schemas[schema][key]
			if not isinstance(actions, list):
				actions = [actions]
			for action in actions:
				if 'condition' in action:
					condition = action['condition']
					if check_condition(action['condition']):
						action = action['action']
					else:
						continue
				action['schemadir'] = schemadir
				if action['operation'] == 'set':
					set_value(schema, key, action)
				elif action['operation'] == 'add':
					add_value(schema, key, action)
				elif action['operation'] == 'remove':
					remove_value(schema, key, action)
				elif action['operation'] == 'clear':
					clear_value(schema, key, action)
				else:
					print('Invalid operation:', action['operation'])
					continue
			write_setting(schema, key, schemadir)

if __name__ == '__main__':
	pathlist = Path(sys.argv[1]).glob('**/*.json')
	for path in pathlist:
		print('Processing ' + str(path))
		process_file(path)
