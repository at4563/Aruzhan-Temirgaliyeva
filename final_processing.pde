import processing.sound.*;
import processing.serial.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;

PFont font;
PFont titleFont;
String instructions = "Hello, dear user! Put the brown box in front of you with eyes at the front on your head. Brush you hand near the thing that looks like dynamics and then, immerse yourself in calm music... When tired just exit by good old red X button";
String hiddentext = "I swear, its gonna be comforting...";

int lf = 10;  
String myString = null;
Serial myPort; 
int duration = 0;
int screen = 0;

void setup() {
 size(1000, 800);

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
  minim = new Minim(this);
  player = minim.loadFile("audio_for_final.mp3"); 
  
  titleFont = createFont("Courier New Italic", 24);
  font = createFont("Courier New Bold", 10);
  textAlign(CENTER);
  textSize(70);
}

void draw() {
  
    switch(screen) {
    
  case 0: //screen1 - instructions
    fill(255);
    textFont(titleFont);
    text(instructions, width/2, height/4, width/2, height/1.5);
    ellipse(width/4, height/2, 300, 300);

    //right eyeball
    fill(255);
    ellipse(width/3.5, height/2, 50, 50);

    //left eyeball
    fill(255);
    ellipse(width/5, height/2, 50, 50);

    //pupil right
    fill(0);
    ellipse(width/4.9, height/2, 10, 10);

    //pupil left
    fill(0);
    ellipse(width/3.5, height/2, 10, 10);

    line(width/4.5, height/1.9, width/3.9, height/1.9); //face that looks dissporovingly

   if ( millis() < 5000 ) { //shows for 3 sec
      textFont(font);
      text(hiddentext, width/4, height/1.8); //hidden pop up motivational text
    }
    
    break;
    }
  // check if there is something new on the serial port
  while (myPort.available() > 0) {
    // store the data in myString 
    myString = myPort.readStringUntil(lf);
    // check if we really have something
    if (myString != null) {
      myString = myString.trim(); // let's remove whitespace characters
      // if we have at least one character...
      if(myString.length() > 0) {
        println(myString); // print out the data we just received
        // if number (e.g. 123) received, it will store it in duration, then use this to change the background color. 
        try {
          duration = Integer.parseInt(myString);
          // As the range of an analog sensor is between 0 and 1023, we need to 
          // convert it in order to use it for the background color brightness
          int brightness = (int)map(duration, 0, 1023, 0, 255);
          background(brightness);
        } catch(Exception e){}
        if(myString.equals("T")){
          if(player.isPlaying() == false){
            player.play();
          }
      }
      
    }
  }
}
}
