
#include <Servo.h>

#define TRIG 8
#define ECHO 9
#define SERVO A1

Servo rotator; 
int angle = 15; //sensible default
bool forwardSweep = true;

void setup(){
    Serial.begin(9600);
    pinMode(TRIG, OUTPUT);
    pinMode(ECHO, INPUT);

    rotator.attach(SERVO);
    rotator.write(angle); //we start at the angle
    Serial.print("\n");
}
void loop(){

    /* think about what we should be doing */
    if (angle < 15){ 
        forwardSweep = true;

    } else if (angle > 165) {
        forwardSweep = false; //move backwards

    }

    //we havent moved yet, but we're at some angle; 
    //take a reading and output to computer:

    delay(20); //wait for servo to stop moving
    long distance = calculateDistance();

    //send the information to the computer
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance,DEC);
    Serial.print("\n"); // newline to finish it off
    // println() will produce "\r\n" which you have to 
    // account for in processing

    /* start moving in the proper direction */    
    if (forwardSweep){
        angle++;
    }
    else {
        angle--;
    }

    rotator.write(angle);
}

long calculateDistance(){

    unsigned long duration = 0;
    
    digitalWrite(TRIG, LOW);
    delayMicroseconds(5);

    digitalWrite(TRIG, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG, LOW);

    duration = pulseIn(ECHO, HIGH,100000);

    //return the raw duration, divided by 2.
    // the computer can convert to proper numbers.
    // by duration/29.1 seconds
    return duration >>1;
}
