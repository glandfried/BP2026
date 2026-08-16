cat $1 | while read line
do
    if [ ! -f "download/$line" ]
    then
	sed -n "/$line/,/^}/p" biblio.bib | grep url | grep -o '{.*}' | sed  's/{/"/g' | sed 's/}/"/g' | xargs wget -U --adjust-extension -O download/$line
    fi
done
