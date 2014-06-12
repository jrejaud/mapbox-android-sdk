#!/usr/bin/env bash

VERSION=$1

if [ -z $VERSION ]; then
  echo "Specify a version ie. 0.2.3"
  exit
fi

#mkdir $VERSION
#curl "http://search.maven.org/remotecontent?filepath=com/mapbox/mapboxsdk/mapbox-android-sdk/$VERSION/mapbox-android-sdk-$VERSION-javadoc.jar" > $VERSION/mapbox-android-sdk-$VERSION.jar

cd $VERSION
#cd $VERSION && unzip mapbox-android-sdk-$VERSION.jar

#rm mapbox-android-sdk-$VERSION.jar

HTMLTOP='<div class="contentContainer">'
HTMLEND='<div class="bottomNav">'

scrape() {
  FR=`grep -n "$HTMLTOP" $1 | grep -o [0-9]*`
  TO=`grep -n "$HTMLEND" $1 | grep -o [0-9]*`
  LINES=`echo "$TO - $FR" | bc`
  echo "$(tail -n +$FR $1 | head -n $LINES)"
}

for file in `find com/mapbox/mapboxsdk/*/*.html | grep -v package-`; do

CONTENT="\
---
layout: pages
title: $(echo ${file##*/} | sed -e 's/\([a-z]\)\([A-Z]\)/\1 \2/g' -e 's/\.html$//')
category: $(echo $file | sed 's#.*/\([^/]*\)/[^/]*#\1#')
---"

FILENAME=$(echo '../../_posts/api/0100-01-01-'${file##*/} | sed -e 's/\([a-z]\)\([A-Z]\)/\1-\2/g' | tr '[:upper:]' '[:lower:]')
CONTENT="$CONTENT\n$(scrape $file)"

echo -e "$CONTENT" > $FILENAME
done

ALL="\
---
layout: pages

title: $(echo ${file##*/} | sed -e 's/\([a-z]\)\([A-Z]\)/\1 \2/g' -e 's/\.html$//')
---"

echo -e "$ALL" > '../../_posts/api/0100-01-01-api.html' 

echo "Complete!"
exit
