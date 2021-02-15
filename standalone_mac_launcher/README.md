https://github.com/totovr/SimpleOpenNI/issues/2

I've done some research about this problem today. Below are what I have found out:

the error info is:

Can't load SimpleOpenNI library (libSimpleOpenNI.jnilib) : java.lang.UnsatisfiedLinkError: Can't load library: /SimpleOpenNI/library/libSimpleOpenNI.jnilib
Verify if you installed SimpleOpenNI correctly.
http://code.google.com/p/simple-openni/wiki/Installation

java.lang.UnsatisfiedLinkError: SimpleOpenNI.SimpleOpenNIJNI.swig_module_init()V
	at SimpleOpenNI.SimpleOpenNIJNI.swig_module_init(Native Method)
	at SimpleOpenNI.SimpleOpenNIJNI.<clinit>(SimpleOpenNIJNI.java:290)
	at SimpleOpenNI.ContextWrapper.<init>(ContextWrapper.java:54)
	at SimpleOpenNI.SimpleOpenNI.<init>(SimpleOpenNI.java:253)
	at Sketch.settings(Sketch.java:28)
	at processing.core.PApplet.handleSettings(PApplet.java:954)
	at processing.core.PApplet.runSketch(PApplet.java:10786)
	at processing.core.PApplet.main(PApplet.java:10511)
	at Main.main(Main.java:7)
Why this happend?
Open SimpleOpenNI.jar through IntelliJ, and view SimpleOpenNI.class, below are how libSimpleOpenNI.jnilib is loaded:

static {
        String var0 = System.getProperty("os.name").toLowerCase();
        String var1 = "SimpleOpenNI";
        String var2 = System.getProperty("os.arch").toLowerCase();
        if (var0.indexOf("win") >= 0) {
            // ...
        } else if (var0.indexOf("nix") < 0 && var0.indexOf("linux") < 0) {
            if (var0.indexOf("mac") >= 0) {
                var1 = "lib" + var1 + ".jnilib";
                nativLibPath = getLibraryPathLinux() + "/SimpleOpenNI/library/";
                nativDepLibPath = nativLibPath + "osx/";
            }
        } else {
            nativLibPath = "/SimpleOpenNI/library/linux";
            if (var2.indexOf("86") >= 0) {
                var1 = var1 + "32";
            } else if (var2.indexOf("64") >= 0) {
                var1 = "lib" + var1 + "64.so";
                nativLibPath = getLibraryPathLinux() + "/SimpleOpenNI/library/";
                nativDepLibPath = nativLibPath + "linux64/";
            }
        }

        try {
            System.load(nativLibPath + var1);
        } catch (UnsatisfiedLinkError var5) {
            System.out.println("Can't load SimpleOpenNI library (" + var1 + ") : " + var5);
            System.out.println("Verify if you installed SimpleOpenNI correctly.\nhttp://code.google.com/p/simple-openni/wiki/Installation");
        }

        _initFlag = false;
    }
notice that, the result of getLibraryPathLinux() should be added before /SimpleOpenNI/library/libSimpleOpenNI.jnilib, the string appeared in the error information. Let's look at the function:

public static String getLibraryPathLinux() {
        URL var0 = SimpleOpenNI.class.getResource("SimpleOpenNI.class");
        if (var0 != null) {
            String var1 = var0.toString().replace("%20", " ");
            int var2 = var1.indexOf(47);
            boolean var3 = true;
            int var4 = var1.indexOf("/SimpleOpenNI/library");
            return -1 < var2 && -1 < var4 ? var1.substring(var2, var4) : "";
        } else {
            return "";
        }
    }
···

Notice this line

```java
int var4 = var1.indexOf("/SimpleOpenNI/library");
SimpleOpenNI tries to find substring /SimpleOpenNI/library from the full path of SimpleOpenNI.class file. If the substring does not show up, this function return an empty string. This is why processing fails to load SimpleOpenNI.jnilib file in exported application: when running from processing ide, the SimpleOpenNI.jar in ~/Documents/Processing/libraries/SimpleOpenNI/library directory is used, the full path of which contains /SimpleOpenNI/library. On the other hand, when running from exported application, the SimpleOpenNI.jar embedded in the application is used, which does not contain the required substring.

How to solve it.
A new implementation of getLibraryPathLinux is required to fix this problem thoroughly. A temporary solution is given below:

cd into your exported application bundle, go to Contents/MacOS, there should be a executable file with the same name of your exported application, Sketch, for example. Remove this file, and create a new empty file with the same name, edit the file and add the following contents:
#!/bin/bash
cd "$(dirname ${BASH_SOURCE})"
cd ../..
APP_ROOT=$(pwd)
cd Contents/Java

JAR_LIBS=$(ls *.jar | tr "\n" ":")
JAR_LIBS=${JAR_LIBS}./SimpleOpenNI/library/SimpleOpenNI.jar

APP_NAME=$(basename "${BASH_SOURCE}")

# Caution: if your embedded java has a different version, replace jdk1.8.0_181.jdk with the correct name
# if you didn't choose to embedded java in your exported application, set JAVA_BIN=java to use the global java
JAVA_BIN=${APP_ROOT}/Contents/PlugIns/jdk1.8.0_181.jdk/Contents/Home/jre/bin/java

${JAVA_BIN} \
-Djna.nosys=true \
-Djava.ext.dirs=$APP_ROOT/Contents/PlugIns/jdk1.8.0_181.jdk/Contents/Home/jre/lib/ext \
-Xdock:icon=$APP_ROOT/Contents/Resources/sketch.icns \
-Djava.library.path=$APP_ROOT/Contents/Java \
-Dapple.laf.useScreenMenuBar=true \
-Dcom.apple.macos.use-file-dialog-packages=true \
-Dcom.apple.macos.useScreenMenuBar=true \
-Dcom.apple.mrj.application.apple.menu.about.name=${APP_NAME} \
-classpath ${JAR_LIBS} ${APP_NAME}
make this file executable

chmod +x ./Sketch
Copy the entire folder ~/Documents/Processing/libraries/SimpleOpenNI to Contents/Java.