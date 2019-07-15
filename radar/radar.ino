
#include <Servo.h>

#define TRIG 
#define ECHO
#define SERVO

Servo rotator; 
int angle = 15; //sensible default

void setup(){
    pinMode(TRIG, OUTPUT);
    pinMode(ECHO, INPUT);

    rotator.attach(SERVO);
    rotator.write(angle); //we start at the angle
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

    delay(30); //wait for servo to stop moving
    int distance = calculateDistance();

    //send the information to the computer
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(); //newline to finish it off

    /* start moving in the proper direction */    
    if (forwardSweep){
        angle++;
    }
    else {
        angle--;
    }

    rotator.write(angle);
}

int calculateDistance(){

    long duration = 0;
    
    digitalWrite(TRIG, LOW);
    delayMicroseconds(2);

    digitalWrite(TRIG, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG, LOW);

    duration = pulseIn(ECHO, LOW);

    return duration * 0.017;
    
}