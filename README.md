## Syracuse

The famous [Collatz(or Syracuse) conjecture](https://en.wikipedia.org/wiki/Collatz_conjecture), although not proven, can be illustrated by this project.
In fact, this program will generate the following graphs for all sequences between two given positive integer bounds and "overlay" them:
  - AllData, the complete sequence's curve;
  - AltitudeMax, the highest value;
  - AltitudeDuration, the time during which the sequence has not entered the cycle (1-2-4)
  - FlightDuration, the time during which values are greater than first value Uo;
 
## Install

Nothing could be simpler ! Just clone this git repository with https or ssh protocol.

```bash
git clone https://github.com/Tucobad/Syracuse.git # https
# or
git clone git@github.com:Tucobad/Syracuse.git # ssh
```

## Usage

For a basic run, just run ``./syracuse.bash <bound_1> <bound_2>``.<br>
The structure of the project is given in the manual which is accessible with the ``-m`` or ``--manual`` option.<br>
You can even copy the manual into ``/usr/share/man/man8``to use the ``man`` command from anywhere.<br>
Recently, the ``--color`` option has been added to change the color of the curves.<br>
The available reference colors are present in ``Config/refColors`` otherwise all hexadecimal color codes are accepted
