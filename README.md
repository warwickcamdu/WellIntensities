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
  - Number of wells: This is the total number of wells you expect to be in the image. If a different number of wells is found, the macro will ask if you want to crop a region (see below). The default is 6.
  - Number of rows: This is the total number of rows of wells you expect to be in the image. An error will be returned if the number of wells is not divisible by the number of rows.
  - Time step: Interval of time between each image (e.g. if imaging was carried out every 10 mins, enter 10). The first column of the results file will be the time of each image starting from t=0. The default is 1.
  
The macro should then run. The macro opens images individually so should only require as much RAM as it takes to open a single 2D image, rather than the whole image sequence. The results will be displayed on the screen, including the first image from the stack and a mask with the ROIs displayed, so that the identification of the wells can be checked. A clean up script is run at the beginning of the macro so the windows do not have to be closed before the next run. A clean up macro is also provided to close all the windows, just do: Plugins > Marco > Run... and open CleanUp.ijm.

## Crop a region
If the wrong number of wells are found the macro will ask if you want to crop a region. If you choose not to, uncheck the box and the macro will exit. If you choose to crop a region, click OK. Select a region using click and drag, making sure to only include the number of wells specified in the earlier dialog box. When finished click OK on the remaining dialog box.

## To Download the Macro
Click the green Code button above and select "Download Zip". Unzip the folder to your desired location.


## Acknowledgements
If you use this macro or an adapted version please acknowledge CAMDU. Guidance for acknowledging CAMDU can be found here:
https://warwick.ac.uk/fac/sci/med/research/biomedical/facilities/camdu/acknowledgementpolicy/
