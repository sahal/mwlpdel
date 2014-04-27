#!/bin/bash
# use: ./lonelypages.sh
# desc: get a list of Orphaned Pages from a MediaWiki install
#	for each list item ask user if he/she wants to delete it
# 	if yes add the article to a delete list
# by: Sahal Ansari (github@sahal.info)


# if ./lonelypages doesn't exist get a list of 900 orphaned pages from a MediaWiki install
if [ ! -e lonelypages ]; then
	wget --quiet -O - "http://wiki.example.com/w/index.php?title=Special:LonelyPages&limit=900&offset=0" | \
	grep ^\<li\> | sed -e s/.*title\=\"// -e s/\".*// > lonelypages
# this line works too, but it's a PITA to convert urlencoded urls back to UTF-8/16
#	grep \/wiki\/ | sed -e s/.*href\=\"// -e s/\".*// -e s@/wiki/@@ > lonelypages
fi

echo "I will now ask you if you want to delete a list of articles in './lonelypages'"
echo "You can select Yes or No (1 or 2.)"
echo "Stop at any time with ^C. Don't worry, your work will be saved in './lonelypages_delete'."
echo

# if lonelypages_delete exists -- we shouldn't start from the begining
# this doens't work that well due to caching? -- needs to be fixed
if [ -e lonelypages_delete ]; then
	cat lonelypages lonelypages_delete | sort | uniq -u > lonelypage2
	mv lonelypage2 lonelypages
fi

function ask_delete {
	echo "Delete: ""$1"
	select yn in "Yes" "No"; do
	case $yn in
		Yes ) echo "$1" >> lonelypages_delete; break;;
		No ) break;;
	esac
	done
}

# read ./lonelypages into array lonelypages
# print each lonelypages ask user if he/she wants to delete
# if Yes/1 mark for deletion (put it in ./lonelypages_delete
while IFS=$'\n' read -r line_data; do
	lonelypages[i]="${line_data}"
	((++i))
done < lonelypages

for (( c=0; c<="${#lonelypages[@]}"; c++ ))
do
	/bin/echo -ne "[""$c"/"${#lonelypages[@]}""] " && ask_delete "${lonelypages["$c"]}"
done
