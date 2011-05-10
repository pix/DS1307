/*
This example firstly waits for Serial input and then sets date and time on DS1307
Real-Time Clock based on what user sent.
Secondly it reads the date and time from DS1307 Real-Time Clock
and send this information to your PC using USB/Serial (like the ReadDate example).
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

#include <Wire.h>
#include <DS1307.h>

int i = 0;
char dateTime[22];
DS1307Class::DateTime RTCValues;

void setup() {
    Serial.begin(9600);
    Serial.println("Please enter date and time in the format \"YYYY-MM-DD HH:MM:SS D\",");
    Serial.println("Where D is the number of the day of week (0 = Sunday, 6 = Saturday).");
    Serial.println("Example: 2011-04-23 02:25:27 6");
    DS1307.begin();

    while (i < 21) {
        if (Serial.available()) {
            char c = Serial.read();
            dateTime[i] = c;
            i++;
        }
    }
    dateTime[i] = '\0';

    RTCValues.year = atoi(dateTime + 2);
    RTCValues.month = atoi(dateTime + 5);
    RTCValues.dayOfMonth = atoi(dateTime + 8);
    RTCValues.dayOfWeek = atoi(dateTime + 20);
    RTCValues.hour = atoi(dateTime + 11);
    RTCValues.minute = atoi(dateTime + 14);
    RTCValues.second = atoi(dateTime + 17);

    DS1307.setDate(&RTCValues);
    Serial.println("Date and time set!");
    Serial.println("Reading data from RTC...");
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
