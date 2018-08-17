#!/usr/bin/env python3

import json
import sys
from subprocess import check_output
from os.path import expanduser

with open(sys.argv[1]) as f:
	settings = json.load(f)

read_cache = {}
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
	if value == 'true':
		return True
	elif value == 'false':
		return False
	elif value.startswith("["):
		return [read_value(v) for v in value[1:-1].split(', ')]
	elif value.startswith("'"):
		return value[1:-1].replace("\\'", "'")
	return value

def format_value(value):
	if isinstance(value, str):
		return "'" + value.replace("'", "\\'") + "'"
	if isinstance(value, bool):
		return 'true' if value else 'false'
	if isinstance(value, list):
		print(value)
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

def write_setting(schema, key, schemadir):
	cache_key = schema + '.' + key
	if not cache_key in read_cache:
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

for schema in settings:
	schemadir = settings[schema].pop('.schemadir', None)
	for key in settings[schema]:
		actions = settings[schema][key]
		if not isinstance(actions, list):
			actions = [actions]
		for action in actions:
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
