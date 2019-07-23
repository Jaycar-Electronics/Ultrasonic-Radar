/*   Arduino Radar Project
 *
 *  Original code by Dejan Nedelkovski, 
 *  www.HowToMechatronics.com
 *  
 *  Modified by Jaycar Electronics to make it easier to read and function.
 *  Contributions welcome! 
 */
 
import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;

Serial myPort; // serial object

// Serial data buffer
String data="";

void setup() {
  
 size (400,300); //set window size 
 
 smooth();	// make things smooth 
 
 //connect the serial port; here we will connect to the last one on the list. 
 String[] availableConnections = Serial.list();
 String lastSerial = availableConnections[ availableConnections.length - 1 ]; 
 
 myPort = new Serial(this, lastSerial, 9600); // starts serial with the last port
 
 myPort.bufferUntil('\n'); // read data until the newline; ( buffer each line )
 
 delay(1000);
 
}
void draw() {
  
  fill(98,245,31);
  
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4); // gray, alpha; slowly dim out the old lines; 
  rect(0, 0, width, height-height*0.065); 
  
  fill(98,245,31); // green color

  // calls the functions for drawing the radar
  drawRadar();	// static lines 
  drawLine();	// moving line 
}

// This function triggers each time the serial port receives data
void serialEvent (Serial myPort) {
	
  try{
	  
    // reads until a newline
    data = myPort.readStringUntil('\n');
	
	// quick data check; 
    if(data.length() < 5 ){
		return;
	}
	
  } catch( RuntimeException e){
	  print("Failed to read Serial data, skipping.. ");
	  e.printStackTrace();
	  return;
  }	  
 
	int splitIndex = data.indexOf(','); // finds where in the string the ',' is 
	int angle = 0;
	int distance = 0;
	
	try{ 
	
	//here we take the int( x ) of the data.substring, starting from the start and ending at the comma.
	angle = int( data.substring(0, splitIndex) );
	
	//do the same for distance, which is after the comma;
	distance = int( data.substring(splitIndex + 1, data.length()) );

	//factor in the speed of light in distance:
	distance = distance / 29.1; 
	} catch ( RuntimeException e) { 
		print("Failed to convert String into INT, skipping..");
		e.printStackTrace();
		return;
	}
	
	//now we have angle and distance, add it to the list of lines to draw
	
	if (drawableAngles.length < 3) { // to a limit of 3, so we don't fill up the ram
		append( drawableAngles, angle ); 
		append( drawableDistances, distance );
	}
	
}
void drawRadar() {
  pushMatrix();
  translate(width/2,height-height*0.074); // moves the starting coordinates to new location
  noFill();
  strokeWeight(1); // thin
  stroke(98,245,31);
  // draws the arc lines
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  // draws the angle lines
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}

void drawLine() {
  pushMatrix();
  
  strokeWeight(4);	// thickness
  stroke(30,250,60); // colour 
  translate(width/2,height-height*0.074); // moves to the starting location 
  
  int d = 0; //distance for drawing function
  float a = 0; //angle for drawing function
  
  //start drawing:
  // here we start at the back of the list, draw it, then "shorten" the array; 
  for(int i = drawableAngles.length; i > 0; i++ ) {
	  
	  d = drawableDistances[i];			// distance; scale if needed 
	  a = radians( drawableAngles[i] ); // angle (in rad); scale if needed
	  
	  line(0,0, d * cos(a), -d * sin(a) ); //draw line from 0,0 to postion; remember trigonometry!
	
	drawableAngles = shorten(drawableAngles);
	drawableDistances = shorten(drawableDistances);
  }

  popMatrix(); //revert back away from the starting position
}
