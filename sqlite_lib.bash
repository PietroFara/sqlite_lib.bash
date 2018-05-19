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
			elif [[ ! $DATA ]];then #if we cannot find DATA, we can assume that the previous column value has a newline character
				rows[$num_rows,"$PREV_COL_NAME"]=${rows[$num_rows,"$PREV_COL_NAME"]}$'\n'$COL_NAME #COL_NAME contains DATA in this case
			else
	       		rows[$num_rows,"$COL_NAME"]="$DATA"
	       		PREV_COL_NAME=$COL_NAME #saving the previous column name in case we have a multiple line column
	       	fi
		done <<< "$result"
		((num_rows=num_rows+1))
	fi
}
