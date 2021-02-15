https://github.com/totovr/SimpleOpenNI/issues/2

spacorum commented on Nov 18, 2020
Amazing! I actually saved the jar source with my fork: https://github.com/n1ckfg/SimpleOpenNI/tree/Processing_3.4_test/SimpleOpenNI/src ...tried a couple path fixes and recompiled but no luck. Do you have an idea of how you would implement that directly in the source?

FINALLY! Thanks to your fork I was able to apply a definitive fix for the infamous path bug in .exe files. With your build.bat file and small changes to the solution posted in this link, you can easily generate a brand new .jar file which works perfectly with standalone .exe files. Here´s how (requires Processing 3.4 + SimpleOpenNI-Processing_3.4):

Edit @n1ckfg ´s fork "SimpleOpenNI-Processing_3.4_test\SimpleOpenNI\src\SimpleOpenNI\SimpleOpenNI.java" file with any text editor.

Insert this code before line 32:
static String workingDir = System.getProperty("user.dir");

Replace lines 50 and 56 with:
nativLibPath = getLibraryPathWin() + workingDir + "/SimpleOpenNI/library/";

(optional) Edit @n1ckfg ´s .bat file and replace the "core.jar" location with the one at your current Processing library path if it´s not the same (as in my case). Save file changes if required.

Launch build.bat file, which generates the new SimpleOpenNI.jar

Overwrite the current file at export folder "\application.windows64\lib" with the new one.

Manually copy the folder SimpleOpenNI to the same folder where your .exe is located. (the one that contains subfolders: "documentation", "examples" and "library").

Launch the .exe file and this time it will load the SimpleOpenNI library and run the Kinect. Et voilà!

This should do the trick. Thanks again!

