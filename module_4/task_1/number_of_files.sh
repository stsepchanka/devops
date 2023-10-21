if [[ $# -eq 0 ]]; then
	echo 'No directories provided'
	exit
fi

echo -e "Directory\t\t\tFile(s)"

for i in "$@"
do
	echo -e "$i\t\t\t$(find $i  -type f  | wc -l)"
done
