/* --------------------------------------------------------------------------
 * SimpleOpenNI IR Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;


SimpleOpenNI  context;

void setup()
{
  size(1280, 480, P2D);
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  context.enableDepth();
  
  // enable rgbMap generation
  context.enableRGB();
  
  // align depth data to image data
  context.alternativeViewPointDepthToImage();
  // may not work for all hardware
  //context.setDepthColorSyncEnabled(true);
  
  background(200,0,0);
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  image(context.depthImage(),0,0);
  
  // draw rgbImageMap
  image(context.rgbImage(),context.depthWidth(),0);
}
