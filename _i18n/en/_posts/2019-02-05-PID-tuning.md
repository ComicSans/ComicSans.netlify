---
layout: post
title: "PID tuning in marlin firmware"
categories: [howto, 3d-printing, marlin]
---

PID tuning is the process of optimizing your printers temperature settings. Setting optimal P, I and D values can prevent temperature fluctuations.

<!--more-->

PID stands for _Proportional, Integral, Derivative_ - and is a control loop feedback mechanism used by marlin to keep your printer at a stable temperature.

Run:

```
M106 // start the fans at 100%
M303 E-0 S230 C8 // run 8 test cycles for the first extruder at 230°C
```

This will take a while and the result of each test run is printed to the console. At the end you will see something like this:

```
bias: 91 d: 91 min: 206.48 max: 213.59
Ku: 32.59 Tu: 26.48
Classic PID
Kp: 21.56 // P value
Ki: 1.38  // I value
Kd: 62.73 // D value
```

Run:

```
M301 P21.56 I1.38 D62.73 // Set the new values as seen above
M500 // save to EEPROM
```

You can add them to _configuration.h_ and compile your firmware with these default values:

```
#define  DEFAULT_Kp 21.56
#define  DEFAULT_Ki 1.38
#define  DEFAULT_Kd 62.73
```
