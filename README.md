# Modelling Human Gait using a Nonlinear Differential Equation

We have collected data for six participants aged from 18 to 55 years, three males and three females. The study followed ethical protocols as per ethics requirements (UNE HE19-239). We have measured the vertical coordinates z(t) of the Centre of Mass (COM) for each participant walking or running on the treadmill. The markers we used were the Left and Right PSIS and ASIS, then we computed the average of all four. The data was collected for different integer velocities, at 100 frames per second, over 10 seconds, for each velocity, using an 8 camera, Qualisys Motion capture system with the COM reconstructed using a pelvic marker set within Visual3D.

The data we collected are similar to [A public dataset of running biomechanics and the effects of running speed on lower extremity kinematics and kinetics](https://peerj.com/articles/3298/) and [A public dataset of overground and treadmill walking kinematics and kinetics in healthy individuals](https://peerj.com/articles/4640/), though we concentrated only on the vertical coordinate of participants' centres of mass.

## Data

The following datasets were used in this research:

*  [Centre of Mass position for participants on a treadmill](https://doi.org/10.6084/m9.figshare.15041322.v2)
*  [A public data set of running biomechanics and the effects of running speed on lower extremity kinematics and kinetics](http://doi.org/10.6084/m9.figshare.4543435)
*  [A public data set of overground and treadmill walking kinematics and kinetics of healthy individuals](https://doi.org/10.6084/m9.figshare.5722711)

## Code

### Python

The code in the python directory can be used to convert the online datasets into a format that can be used by the Matlab code.

*  ```convert_csv_to_matlab.py``` converts csv files in the correct format into Matlab files
*  ```get_com_data_online_run.py``` converts data from the running dataset mentioned above into an appropriate csv file
*  ```get_com_data_online_walk.py``` converts data from the walking dataset mentioned above into an appropriate csv file

### Matlab

The Matlab code is used to solve nonlinear differential equations to model human gait.

*  ```make_figures.m``` shows an example of how to use this code to create useful figures.

### R

The R code is used to perform statistical analysis.

The ```k3_data_with_fft_threshold_0.30.csv``` it references is the output of the Matlab script ```get_k3_data.m```.

## Contributors

Corresponding Contributor: [Jelena Schmalz](mailto:jschmalz@une.edu.au)

*  Jelena Schmalz, School of Science & Technology, University of New England, NSW, Australia
*  David Paul, School of Science & Technology, University of New England, NSW, Australia
*  Kathleen Shorter, School of Science & Technology, University of New England, NSW, Australia
*  Xenia Schmalz, Department of Child and Adolescent Psychiatry, Psychosomatics and Psychotherapy, University Hospital, LMU Munich, Germany
*  Matthew Cooper, School of Science & Technology, University of New England, NSW, Australia
*  Aron Murphy, Faculty of Medicine, Nursing and Midwifery and Health Sciences, University of Notre Dame, Australia

## Acknowledgements

The study followed ethical protocols as per ethics requirements (HE19- 239) at the University of New England, Australia.
Thanks to computer science students Ben Fisk, Danielle Galvin and Jarra McIntyre for developing a prototype of the software used for this submission and to sport science student Megan Bancks for the literature research.
Thanks to Adam Harris and Gerd Schmalz for their critical comments and support.
