@echo off

set PROCESSING_PATH="C:\Program Files\processing\core\library\core.jar"

cd %cd%
javac -cp %PROCESSING_PATH% SimpleOpenNI\*.java
mkdir build\SimpleOpenNI
move /y SimpleOpenNI\*.class build\SimpleOpenNI\
cd build
jar cvfm ..\SimpleOpenNI.jar manifest.txt SimpleOpenNI\*.class

@pause