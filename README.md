# Well Intensities
Author: Laura Cooper, camdu@warwick.ac.uk

ImageJ Macro for measuring the fluoresence intensity of wells in a well plate.

The macro automatically detects the position of the wells, estimates the pixel resolution based on the size of the control wells and measures the intensity of the upper wells and the lower wells. It then returns a .csv file containing these values for each image.

## To Run the Macro
In Fiji go to Plugins > Marco > Run... and open the MeasureIntensityWells.ijm file.\
You will then be asked:
1) "Which folder contains the images?" Navigate inside the folder that contains the images. This should contain 2D images files.
2) "Where should the results file be saved?" Navigate inside the folder where you would like the resulting .csv file to be saved.
3) Required Inputs: 
  - Name of the results file: Enter the name of the results file here. This should have the .csv file extension.
  - Median radius: This is the radius of the median used to smooth the image and remove bright spots. The default is 3.
  - Number of wells: This is the total number of wells you expect to be in the image. It is assumed there are two rows of wells and therefore this number must be even or the macro will return an error. The default is 6.
  - Number of rows: This is the total number of rows of wells you expect to be in the image. An error will be returned if the number of wells is not divisible by the number of rows.
  
The macro should then run. The macro opens images individually so should only require as much RAM as it takes to open a single 2D image, rather than the whole image sequence. The results will be displayed on the screen, including the first image from the stack and a mask with the ROIs displayed, so that the identification of the wells can be checked. A clean up script is run at the beginning of the macro so the windows do not have to be closed before the next run. A clean up macro is also provided to close all the windows, just do: Plugins > Marco > Run... and open CleanUp.ijm.

## To Download the Macro
Click the green Code button above and select "Download Zip". Unzip the folder to your desired location.


## Acknowledgements
If you use this macro or an adapted version please acknowledge CAMDU. Guidance for acknowledging CAMDU can be found here:
https://warwick.ac.uk/fac/sci/med/research/biomedical/facilities/camdu/acknowledgementpolicy/
