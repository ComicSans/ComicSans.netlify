---
layout: post
title: "Calibrating extrusion steps in marlin firmware"
categories: [howto, 3d-printing, marlin]
---

An important value for 3D printers is the extrusion value or the amount of plastic that is moved into the hotend whenever you print. This settings is basically set in the gcode file you send to your printer but several values often need adjustment as steppers may vary.

<!--more-->

The technical details are pretty simple: you have a stepper motor that turns a little screw. That little screw graps the filament string and moves it in the hotend where it is melted and printed. The gcode file tells your printer how many turns that screw has to make in order to extrude a defined amount of filament. The amount is measured in steps per millimeter and called the _e steps_.

The problem is that the stepper motor may extrude more or less than the firmware expected. This is a crucial point when you exchange your stepper motor or exchange your extruder mount (based on your setup).

You can compile the marlin firmware with the correct settings or you can override the factory settings and save new values to EEPROM.

Also you need to do some math to calculate the correct stepper value, but I'll help you with this.

## Prerequisites

Basically you need to know how much the desired value for extruded filament differs from the real value. We get the difference by simply measuring the length of extruded plastic. So grab the ruler of your choice and mark the filament a few centimeters from where it enters the extruder. If you have a E3Dv6 hotend or similar, you may disconnect the plastic tube and measure the amount of plastic that appears at the end of the tube.

You need a way to send commands to your printer, so either connect it via USB or use OctoPrint or similar.

You can extrude 10mm filament with this code:

```
G1 E100 F100
```

If your printer extrudes exactly 10mm you are fine and can skip the rest of the tutorial here.

## The correct values

Get the current settings with this command:

```
M503 // list information of the printer settings
```

You'll find a line like _Steps per unit: M92 X100.00 Y100.00 Z400.00 E95_ at the beginning of the text. If you receive an error message you will have to recompile Marlin with M503 support enabled (you find this setting in _configuration.h_ as ```//#define DISABLE_M503```).

The last part beginning with _E_ are the current e steps. You will need them for the next steps.

Now the math starts. You have an expected value and a current value that was extruded. You will need the difference.

Calculate
```
(length you expected / length you got) * current step value
```

This will give you the new step value.

You can test them with this line:

```
M92 E### // ### is the new value
M500 // store value to EEPROM
```

If things work you could add the new value to the `DEFAULT_AXIS_STEPS_PER_UNIT` setting in _configuration.h_.
