// Closes the "Results" and "Log" windows and all image windows
function cleanUp() {
    requires("1.30e");
    if (isOpen("Results")) {
         selectWindow("Results"); 
         run("Close" );
    }
    if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );
    }
    while (nImages()>0) {
          selectImage(nImages());  
          run("Close");
    }
}

//Segments the wells by thresholding and fitting circles
function get_rois(input,filename){
	open(input+filename);
	//Q: What radius should be used for the median?
	//This must be the same in both functions
	run("Median...", "radius="+med_rad);
	run("Duplicate...", "title=Mask");
	//Q: Is this the right thresholding tool to use?
	setAutoThreshold("Huang dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	//Q: Make minimum particle size bigger? 1000?
	run("Analyze Particles...", "size=100-Infinity show=Nothing add");

	run("Set Measurements...", "area bounding redirect=None decimal=3");
	roi_count=roiManager("count");
	//Check to see if the number of wells found is what is expected. If not stop and show error.
	//Q: Are there 6 wells in every image or do some have more?
	if (roi_count!=num_wells){
		Dialog.create("Unexpected number of wells found");
		Dialog.addMessage(roi_count+" wells found");
		Dialog.show();
		exit("Unexpected number of wells found");
	}
	//Estimate image calibration from upper wells
	for (i=0;i<num_wells/2;i++){
		roiManager("select",i)
		run("Fit Circle");
		run("Measure");
	}
	run("Summarize");
	//Estimate how many pixels in well diameter
	Well_Diam=getResult("Height",num_wells/2);
	Well_Diam=round(Well_Diam);
	selectWindow("Results");
	run("Close");
	
	for (i=0;i<num_wells;i++){
		roiManager("select",i);
		run("Fit Circle");
		run("Measure");
		Diameter=getResult("Height");
		//Estimated that Well_Diam is approx 15.6 mm
		run("Enlarge...", "enlarge="+(Well_Diam-Diameter)/2);
		roiManager("add");
	}

	//Clean up temporary rois and results
	roi_list=Array.getSequence(num_wells);
	roiManager("select",roi_list);
	roiManager("delete");
	//Group upper and lower wells
	roiManager("select",Array.slice(roi_list,0,num_wells/2));
	roiManager("Combine");
	roiManager("Add");
	roiManager("select",Array.slice(roi_list,num_wells/2,num_wells));
	roiManager("Combine");
	roiManager("Add");
	roiManager("select",roi_list);
	roiManager("delete");
	run("Clear Results");
	//close("*");
}

//Measures intensity of each group of wells
function measure_rois(input,filename){
	open(input+filename);
	//Q: Calibrate image before measuring so results in mm?
	//This should be the same in both functions
	run("Median...", "radius="+med_rad);
	roiManager("Measure");
	close("*");	
}
//Close everything before starting
cleanUp();

//Get directories for inputs and outputs
dir_in=getDirectory("Which folder contains the images?");
dir_out=getDirectory("Where should the resulting .csv file be saved?");
//Get list of files in input directory
list=getFileList(dir_in);

//Create Input Dialog box to get values used in macro
Dialog.create("Required Inputs");
//What call results file
Dialog.addString("Name of results file:", "Results.csv");
//What radius to use for the median filter
Dialog.addNumber("Median radius:", 3);
//How many wells should there be?
Dialog.addNumber("Number of wells, must be even:", 6);
Dialog.show();
result_title=Dialog.getString();
med_rad=Dialog.getNumber();
num_wells=Dialog.getNumber();

setBatchMode(true);
//Get the position of the wells from first file
get_rois(dir_in,list[0]);
run("Set Measurements...", "area mean standard modal min median redirect=None decimal=3");
//Measure rois for all images in directory
for (i = 0; i < list.length; i++){
        measure_rois(dir_in, list[i]);
}

//Reformat results
headings = split(String.getResultsHeadings);
File.open(dir_out+result_title);
	line = "Image Number";
	for (a=0; a<lengthOf(headings); a++)
    line = line + "," + headings[a];
	print(line);
	print("Upper Wells");
//Copy every even row to file
for (i = 0; i < nResults(); i+=2) {
	//Start with blank line
	line = d2s(i/2+1,0);
	for (a=0; a<lengthOf(headings); a++)
    line = line + "," + getResult(headings[a],i);
	print(line);
}
print("Lower Wells");
//Copy every odd row to file
for (i = 1; i < nResults(); i+=2) {
	//Start with blank line
	line = d2s((i-1)/2+1,0);
	for (a=0; a<lengthOf(headings); a++)
    line = line + "," + getResult(headings[a],i);
	print(line);
}
//Save results and close windows
saveAs("Text", dir_out+result_title);
cleanUp();
setBatchMode(false);