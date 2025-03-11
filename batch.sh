#!/bin/bash

doit() {
	cp "from/$1.oramap" "$1.oramap"
#	NAME="work"
  	NAME=$1
  	# ID=$1
  	# echo ID=$ID
  	# wget http://resource.openra.net/map/id/$ID -O "$ID.dat"
  	# #cat "$ID.dat" | grep "\"title\""
  	# NAME=$(cat "$ID.dat" | grep "\"title\"")
  	# NAME=$(echo ${NAME} | cut -d ' ' -f 2 | cut -d '"' -f 2)
  	# echo NAME=$NAME
  	# wget "https://resource.openra.net/maps/$1/oramap" -O "$NAME.oramap"
  	unzip "$NAME.oramap" -d "$NAME" map.*
	while IFS= read -r line
	do
	  	FIRST=$(echo ${line} | cut -d ' ' -f 1)
	  	if 	[[ "$FIRST" == "Title:" ]] ; then
#	  		#echo $line
			line=$(echo "$line" | sed "s/Title: /Title: NV-/gI")
#			line=$(echo $line | sed "s/ww3/ww3.1/gI")
#	  		line="Title: WW3 v3.0.7 $NAME"
	  	fi
	
	  	if 	[[ "$FIRST" == "Author:" ]] ; then
	  		#echo $line
#	  		line="Author: NATO"
	  		line="$line / NATO"
	  	fi
	
	  	if 	[[ "$FIRST" == "Rules:" ]] || \
	  			[[ "$FIRST" == "Sequences:" ]] || \
	  			[[ "$FIRST" == "Weapons:" ]] || \
	  			[[ "$FIRST" == "Voices:" ]] ||
	  			[[ "$FIRST" == "Notifications:" ]] ; then
			  #echo "BREAK"
			  break
	  	fi
	  	if 	[[ "$FIRST" == "Categories:" ]] ; then
			  line="Categories: [BI-4.8]"
	  	fi

	  	echo "$line" >> "$NAME/map.yaml.new"
	done < "$NAME/map.yaml"

#	echo "Rules: WW3_Defaults.yaml, WW3_Aircraft.yaml, WW3_Buildings.yaml, WW3_Infantry.yaml, WW3_Misc.yaml, WW3_Ships.yaml, WW3_Vehicles.yaml, WW3_Briefing.yaml, plains.yaml, ai.yaml" >> "$NAME/map.yaml.new"
	echo "Rules: bi-lobby-rules.yaml, bi-briefing-rules.yaml, bi-balance-rules.yaml, ERCC21andBCC11-rules.yaml, ore.yaml" >> "$NAME/map.yaml.new"
	
	echo "" >> "$NAME/map.yaml.new"
	
#	echo "Sequences: sequences.yaml, unitsequences.yaml" >> "$NAME/map.yaml.new"
	echo "Sequences: bi-sequences.yaml, ERCC2-sequences.yaml" >> "$NAME/map.yaml.new"
	
	echo "" >> "$NAME/map.yaml.new"
	
#	echo "Weapons: WW3_Weapons.yaml" >> "$NAME/map.yaml.new"
	echo "Weapons: bi-weapons.yaml" >> "$NAME/map.yaml.new"
	
	echo "" >> "$NAME/map.yaml.new"
	
#	echo "Voices: WW3_Voices.yaml" >> "$NAME/map.yaml.new"
	echo "Voices: bi-voices.yaml" >> "$NAME/map.yaml.new"
	
	echo "" >> "$NAME/map.yaml.new"
	
#	echo "Notifications: notifications.yaml" >> "$NAME/map.yaml.new"
	echo "Notifications: bi-notifications.yaml" >> "$NAME/map.yaml.new"
	
	rm "$NAME/map.yaml"
	mv "$NAME/map.yaml.new" "$NAME/map.yaml"
	cp BASE_NV/* "$NAME" -R

	cd "$NAME"
#	NAME2=$(echo "NV-$NAME" | sed "s/ww3/ww3.1/gI")
	NAME2=$(echo "NV-$NAME")
	
	zip "../new/$NAME2.oramap" * -r -u
	cd ..
	rm -rf "$NAME"
	rm "$1.oramap"
}

doit "up-v2.0"
