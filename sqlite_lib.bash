function sqlite_query() {
	if [ ! -n "$1" ];then
		return 1
	fi
	DB=$1
	QUERY=$2
	sqlite3 "$DB" "$QUERY" -line
}

sqlite_read_line () {
    local IFS=" \= "
    read COL DATA
    local ret=$?
    COL_NAME=${COL// /}
    return $ret
}

function sqlite_create_fetch_array() {
	result=$(sqlite_query "$1" "$2")
	if [[ $? -eq 1 ]]; then
		return 1
	fi
	num_rows=0
	unset rows
	declare -Ag rows
	if [[ $result ]]; then
		while sqlite_read_line; do
			if [[ ! $COL_NAME ]];then
				((num_rows=num_rows+1))
			fi
	       	rows[$num_rows,"$COL_NAME"]="$DATA"
		done <<< "$result"
		((num_rows=num_rows+1))
	fi
}
