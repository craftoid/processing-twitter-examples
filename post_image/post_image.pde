
import twitter4j.*;
import twitter4j.conf.*;
import twitter4j.api.*;

 
import controlP5.*;
ControlP5 cp5;

ConfigurationBuilder cb;
Twitter twitter;
PImage img;

int border = 10;
int buttonheight = 100;

void setup() {
  
  size(displayWidth, displayHeight);

  // twitter authentication
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(consumer_key);
  cb.setOAuthConsumerSecret(consumer_secret);
  cb.setOAuthAccessToken(access_token);
  cb.setOAuthAccessTokenSecret(access_token_secret);
  twitter = new TwitterFactory(cb.build()).getInstance();
  
  // add a button
  cp5 = new ControlP5(this);
  PFont p = createFont("Verdana",24);
  cp5.setControlFont(p); 
   
  cp5.addButton("click")
    .setLabel("Click to Tweet this Image")
    .setPosition(border, height - buttonheight - border)
    .setSize(width - 2*border, buttonheight)
    .setColorBackground(0xff000000)
    .setColorActive(0xffcc0000)
    .align(ControlP5.CENTER, ControlP5.CENTER, ControlP5.CENTER, ControlP5.CENTER) 
  ;
}

void draw() {
  
  // get an image from the camera
  img = captureImage();
  
  // show image
  image(img, 0, 0);
  
}

PImage captureImage() {
  
  int step = 3;
  background(255);
  noFill();
  int n = min(width, height) - 20;
  for (int i = n; i > 0; i-=step) {
    fill((i%step) * 255);
    ellipse(width/2, height/2, i, i);
  }
  
  return get();
   
}

void click() {
    String filename = "output/snapshot.jpg";
    tweet("Posting an image from processing...", img, filename);
}


void tweet(String msg) {

  // create new status
  StatusUpdate status = new StatusUpdate(msg);

  // tweet it
  try {
    twitter.updateStatus(status);
  } 
  catch(TwitterException e) {
    println(e);
    e.printStackTrace();
  }
}

void tweet(String msg, PImage img, String filename) {

  // save the image to a file and load it
  img.save(filename);
  File f = new File(sketchPath(filename));

  // create new status
  StatusUpdate status = new StatusUpdate(msg);
  status.setMedia(f);

  // tweet it
  try {
    twitter.updateStatus(status);
  } 
  catch(TwitterException e) {
    println(e);
    e.printStackTrace();
  }
}


