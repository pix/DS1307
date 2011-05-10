/*
  DS1307.cpp - DS1307 Real-Time Clock library
  Copyright (c) 2011 Álvaro Justen aka Turicas.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

extern "C" {
    #include <inttypes.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
}

#include "DS1307.h"
#include "Wire.h"


char* fromNumberToWeekDay(uint8_t dayOfWeek) {
    if (dayOfWeek == 0)
        return "Sunday";
    else if (dayOfWeek == 1)
        return "Monday";
    else if (dayOfWeek == 2)
        return "Tuesday";
    else if (dayOfWeek == 3)
        return "Wednesday";
    else if (dayOfWeek == 4)
        return "Thrusday";
    else if (dayOfWeek == 5)
        return "Friday";
    else if (dayOfWeek == 6)
        return "Saturday";
    else
        return "Not found";

}

static uint8_t fromDecimalToBCD(uint8_t decimalValue) {
    return ((decimalValue / 10) * 16) + (decimalValue % 10);
}

static uint8_t fromBCDToDecimal(uint8_t BCDValue) {
    return ((BCDValue / 16) * 10) + (BCDValue % 16);
}

void DS1307Class::begin() {
    Wire.begin();
}


void DS1307Class::setDate(DS1307Class::DateTime* dateTime) {
    Wire.beginTransmission(DS1307_ADDRESS);
    Wire.send(0); //stop oscillator

    uint8_t* values = reinterpret_cast<uint8_t*>(dateTime);
    for (int i = 6; i >= 0; i--) {
      Wire.send(fromDecimalToBCD(values[i]));
    }

    Wire.send(0); //start oscillator
    Wire.endTransmission();
}

void DS1307Class::getDate(DS1307Class::DateTime* dateTime) {
    Wire.beginTransmission(DS1307_ADDRESS);
    Wire.send(0); //stop oscillator
    Wire.endTransmission();
    Wire.requestFrom(DS1307_ADDRESS, 7);

    uint8_t* values = reinterpret_cast<uint8_t*>(dateTime);
    for (int i = 6; i >= 0; i--) {
        values[i] = fromBCDToDecimal(Wire.receive());
    }
}

DS1307Class DS1307;
