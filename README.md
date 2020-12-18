# BEP 2020 - Formation Control w/ Guidance

This is the README file of the Bachelor End Project 2020 done at the Technical University Delft.

Authors: Maud van Lent, Sander Boers, Simon Pipers, Pieter d'Hont.  
Supervisor: V. Garafano.

# How to run
Open the Simulink file and press RUN. The simulation data will be saved to `.mat` files. These files can be loaded with the MATLAB file `Plotter.m`. Check if names of the files are correct and that they are in the same folder. To then plot the virtual boats, press run in MATLAB script editor.

# Contents
A Table of contents is given of all the files included in this repository, with a description of what the use-case is.  
|               Filename               | Description |
|:------------------------------------:|-------------|
| delfiaFormationAssumptions           |             |
| delfiaFormationStatefeedback         |             |
| delfiaFormationAssumptionsRobustness |             |
| delfiaModelAssumptions               |             |
| delfiaModelStatefeedback             |             |
| delfiaModelAssumptionsRobustness     |             |
| lineOfSightSingleVessel              |             |
| distanceFromCenter                   |             |
| PIDassumptions                       |             |
| PIDstatefeedback                     |             |
| plot_center.m                        |             |
| plot_vehicle.m                       |             |
| singleVesselPlotter.m                |             |
| formationPlotter.m                   |             |

# Explanation
Here a short explanation is given about the Simulink blocks on what they do and how to edit them.  
The parameters of the delfia model are somewhat hidden. They are placed in an Init-callback of Simulink, this way the parameters are loaded automatically. To edit them, go to Modeling -> Model parameters -> Callbacks -> Initfcn.

## Simulink components

### Rotation matrices
These are MATLAB-function blocks. The input is the vector it's being multiplied to and the rotation angle. The output is the new rotated vector.

### PID Controller
The PID controller is a subsystem, containing three separate PID blocks. This is because a vector can't be the input for a PID block, so the vector is split (`[x,y,theta]`) and put in individual PID blocks. Every block also has a saturation block attached, this is for the force boundary. The parameters of the PID can be edited inside.

### Marine craft dynamics
In this subsystem the equation of motion of the Delfia 1* is applied. The input is the control vector tau and the initial position of the boat. The output is eta, which consists of the x,y position and angle theta. Inside are different matrices and constants, that are being multiplied. Also two integrator blocks, which integrate the signal. First from acceleration to velocity and then to position.

### Formation control
Here all the adding and subtracting with positions and formation references are done. The output is the three error functions for the PID. 

### Line-of-Sight (LOS)
This function block has the LOS feature. Inside is the reference path specified. If another reference path is needed, edit it here. The output is the desired position of the formation and the heading angle. The option to extend or decrease the `delta_theta` can be found in this function block as well.

### Other reference paths
There is an ability to switch LOS off and use other references. For example, let the formation go to a point. Other examples are line, circle and lemniscate. The desired position and heading is then directly given to the vessels, instead of LOS calculations.

### To-file block
This is used to export the simulation data. Before the export, a Rate transmission block is placed. This is done so all the export data is with equal timesteps.

## MATLAB plotter script
With this script, the simulation can be plotted. Check if the export data is in the same folder. It first loads all the data, then plots an 2D overview of the formation and finally error plots are given. Indivual plot components can be commented or uncommented if not needed. 
