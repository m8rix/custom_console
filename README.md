# Robot

The Robot application is a simulation of a toy robot moving on a square grid.
The robot is free to roam around the surface of the table, there are no other obstructions on the grid surface.

## Installation

Check your ruby version (I am using ruby 2.6.3)
```shell
$ ruby -v
```
In a terminal window, navigate to installed directory.

You will need to install the required gems
```shell
$ bundle install
```
You are now ready to use the app

## Usage
### interactive mode
To enter the robot interactive mode, execute the following command in terminal:

```shell
$ bin/cmd
```
Commands accepted in interactive mode are as follows:
> | accepted command | description |
> | --- | --- |
> | PLACE X,Y,F | Place the toy robot on the table in position X,Y and facing NORTH, SOUTH, EAST or WEST |
> | MOVE        | Move the toy robot one unit forward in the direction it is currently facing. |
> | LEFT        | Rotate the robot 90 degrees left without changing the position of the robot. |
> | RIGHT       | Rotate the robot 90 degrees right without changing the position of the robot. |
> | REPORT      | Announce the X,Y and orientation of the robot. |
> | HELP | Display this help table |
> | EXIT | Exit interactoive mode |

---

### unit tests
To run the rspec test suit, execute the following command in terminal:

```shell
$ rspec
```

---

### application console
To run the application console for this app, execute the following command in terminal:

```shell
$ bin/console
```
