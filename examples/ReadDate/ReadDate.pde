/*
This example reads the date and time from DS1307 Real-Time Clock
and send this information to your PC using USB/Serial.
Make the connections below, upload the code and open Serial Monitor.

Made by Álvaro Justen aka Turicas

Pin connections on DS1307 module:

[DS1307] <--> [Arduino]
5V       <--> 5V
GND      <--> GND 
SQW      <--> (not connected)
SCL      <--> Analog Input 5
SDA      <--> Analog Input 4

This software is free software.
*/

#include <string.h>
#include <Wire.h>
#include <DS1307.h>

char dateTime[20];
DS1307Class::DateTime RTCValues;

void setup() {
    Serial.begin(9600);
    Serial.println("Reading information from RTC...");

    DS1307.begin();
}

void loop() {
    DS1307.getDate(&RTCValues);

    sprintf(dateTime, "20%02d-%02d-%02d %02d:%02d:%02d", RTCValues.year,
            RTCValues.month, RTCValues.dayOfMonth, RTCValues.hour, RTCValues.minute,
            RTCValues.second);
    Serial.print(dateTime);
    Serial.print(" - day of week: ");
    Serial.println(fromNumberToWeekDay(RTCValues.dayOfWeek));

    delay(1000);
}
