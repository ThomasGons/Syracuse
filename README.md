## Syracuse

The famous [Collatz(or Syracuse) conjecture](https://en.wikipedia.org/wiki/Collatz_conjecture), although not proven, can be illustrated by this project.
In fact, this program will generate the following graphs for all sequences between two given positive integer bounds and "overlay" them:
  - AllData, the complete sequence's curve;
  - AltitudeMax, the highest value;
  - AltitudeDuration, the time during which the sequence has not entered the cycle (1-2-4)
  - FlightDuration, the time during which values are greater than first value Uo;
 
## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Features](#features)
## Install

Nothing could be simpler ! Just clone this git repository with https or ssh protocol.

```bash
git clone https://github.com/Tucobad/Syracuse.git # https

# or

git clone git@github.com:Tucobad/Syracuse.git # ssh
```

## Usage

First you will need to give you the execution right with ``chmod``
```bash
chmod u+x syracuse.bash
```
Then for a basic run, just run ``./syracuse.bash [START] [END]``.<br>
The graphs are in ``Images`` directory and the synthesis in the directory of the same name. <br>
As time went by, options were added, some of which are explained below but all are explained <br> in the help or the manual.

## Features

&nbsp;&nbsp;&nbsp;&nbsp;The structure of the project is given in the manual which is accessible with the ``-m`` or ``--manual`` option.<br>
You can even copy the manual into ``/usr/share/man/man8`` to use the ``man`` command from anywhere.<br>

&nbsp;&nbsp;&nbsp;&nbsp;The synthesis is saved in ``Synthesis`` dir but you can display it directly at the end of the execution <br>with option ``-s`` or ``--synthesis`` as follows:
```bash
./syracuse.bash -s [START] [END]
```

Recently, the ``--color`` option has been added to change the color of the curves.<br>

```bash
./syracuse.bash --color <"HEX"> or <"color"> [START] [END]
```
The available reference colors are present in ``Config/refColors`` otherwise all hexadecimal color codes are accepted
