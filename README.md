# Well Intensities
Author: Laura Cooper, l.cooper.5@warwick.ac.uk

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
  - Number of wells, must be even: This is the total number of wells you expect to be in the image. It is assumed there are two rows of wells and therefore this number must be even or the macro will return an error. The default is 6.
  
The macro should then run. The macro opens images individually so should only require as much RAM as it takes to open a single 2D image, rather than the whole image sequence

## To Download the Macro
Click the green Code button above and select "Download Zip". Unzip the folder to your desired location.


## Acknowledgements
If you use this macro or an adapted version please acknowledge CAMDU. Guidance for acknowledging CAMDU can be found here:
https://warwick.ac.uk/fac/sci/med/research/biomedical/facilities/camdu/acknowledgementpolicy/
