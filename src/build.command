#!/bin/bash

PROCESSING_PATH="/Applications/Processing/Processing.app/Contents/Java/core.jar"

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR

javac -cp $PROCESSING_PATH SimpleOpenNI/*.java
mkdir build/SimpleOpenNI
mv SimpleOpenNI/*.class build/SimpleOpenNI/
cd build
jar cvfm ../SimpleOpenNI.jar manifest.txt SimpleOpenNI/*.class
