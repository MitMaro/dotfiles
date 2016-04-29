function ___check_jobs() {
	local job_count=$(jobs -p | wc -l)
	if [[ $job_count > 0 ]]; then
		echo -e "$COLOR_GREEN(${COLOR_DARK_GREEN}${job_count}$COLOR_GREEN) $COLOR_NORMAL"
	fi
}
