#!/usr/bin/env bash

inputDir="$1"
outputDir="$2"
maxDepth=""

if [ "$3" != "" ]; then
  maxDepth="$4"
fi

find "$inputDir" -type f | while read -r file; do
  relPath="${file#$inputDir/}"
  slashCount=$(echo "$relPath" | tr -cd '/' | wc -c)
  depth=$((slashCount + 1))

  if [ -n "$maxDepth" ] && [ "$depth" -gt "$maxDepth" ]; then
	toDrop=$((depth - maxDepth))
	trimmedPath="$relPath"
	for i in $(seq 1 "$toDrop"); do
	  trimmedPath="${trimmedPath#*/}"
	done
	relPath="$trimmedPath"
  fi

  dstDir="$outputDir/$(dirname "$relPath")"
  mkdir -p "$dstDir"

  fileName="$(basename "$relPath")"

  if [ -e "$dstDir/$fileName" ]; then
	baseName="${fileName%.*}"
	extension="${fileName##*.}"
	counter=1
	newFileName="${baseName}_$counter.$extension"
	while [ -e "$dstDir/$newFileName" ]; do
	  counter=$((counter+1))
	  newFileName="${baseName}_$counter.$extension"
	done
	fileName="$newFileName"
  fi

  cp "$file" "$dstDir/$fileName"
done