# Lucas-Kanade-tracking
Lucas Kanade tracking and Background substraction

This project implements Lucas-Kanade algorithm to achieve motion tracking and background substraction in a given image sequence(video).

Structure:
/code
  - Matlab code
/data
  - data required for the program to run. Sample videos for which the program works.
/reference
  - Papers that are referred for this implementation
/results
  - Screenshots of the results of each program.

### Tracking a car in the video
  Given a car's position in the first frame of the video, the program can track the car in the entire video. The initial position is represented as a rectangle in the form [x1, y1, x2, y2], which represents the left top and right bottom corners.
##### Assumption: 
  Only translation is considered as possible transformation in the template.
##### Implementation: 
  Inverse compositional apporach of Lucas-Kanade is used, which does all the computation on the template image once, and uses that in the remaining iteration to calculate. This is much faster when compared to normal Lucas Kanade implementation.
  ![alt tag](https://raw.githubusercontent.com/gmichaeljaison/Lucas-Kanade-tracking/master/results/car-sequence.jpg)
  
  
