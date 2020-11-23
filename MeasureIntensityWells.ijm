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
    if (isOpen("ROI Manager")) {
    	selectWindow("ROI Manager");
    	run("Close");
	}
}

//Segments the wells by thresholding and fitting circles
function get_rois(input,filename){
	open(input+filename);
	//This must be the same in both functions
	run("Median...", "radius="+med_rad);
	run("Duplicate...", "title=Mask");
	//Q: Is this the right thresholding tool to use?
	setAutoThreshold("Huang dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Analyze Particles...", "size=1000-Infinity show=Nothing add");
	run("Set Measurements...", "area bounding redirect=None decimal=3");
	roi_count=roiManager("count");
	//Check to see if the number of wells found is what is expected. If not stop and show error.
	if (roi_count!=num_wells){
		Dialog.create("Unexpected number of wells found");
		Dialog.addMessage(roi_count+" wells found");
		Dialog.show();
		exit("Unexpected number of wells found");
	}
	
	//Estimate image calibration from row containing largest bounding box
	roi_list=Array.getSequence(num_wells);
	roiManager("select",roi_list);
	roiManager("Measure");
	run("Summarize");
	//Find well with largest bounding box
	//getResult counts from 0
	max_width=getResult("Width",Table.size-1);
	max_height=getResult("Height",Table.size-1);
	selectWindow("Results");
	run("Close");
	roiManager("Measure");
	Table.setColumn("Well", roi_list);
	updateResults();
	if (max_width>=max_height){
		Table.sort("Width");
		column="Width";
	} else {
		Table.sort("Height");
		column="Height";
	}
	max_ind_well=getResult("Well",Table.size-1);
	wells_per_row=num_wells/num_rows;
	//Find well row containing that bounding box
	max_well_row=Math.floor(max_ind_well/wells_per_row);
	roiManager("select",Array.slice(roi_list,max_well_row*wells_per_row,(max_well_row*wells_per_row)+(wells_per_row-1)));
	selectWindow("Results");
	run("Close");
	roiManager("Measure");
	Well_Diam=getResult(column, "Mean");

	//Estimate how many pixels in well diameter
	for (i=0;i<num_wells;i++){
		roiManager("select",i);
		run("Fit Circle");
		run("Measure");
		Diameter=getResult("Height");
		//Estimated that Well_Diam is approx 15.6 mm
		run("Enlarge...", "enlarge="+(Well_Diam-Diameter)/2);
		roiManager("add");
	}
	//Clean up temporary rois
	roiManager("select",roi_list);
	roiManager("delete");

	//Group well rows
	min_well=0;
	max_well=num_wells/num_rows;
	while (max_well<=num_wells) {
		roiManager("select",Array.slice(roi_list,min_well,max_well));
		roiManager("Combine");
		roiManager("Add");
		min_well=max_well;
		max_well=max_well+(num_wells/num_rows);
	}
	//Clean up temporary rois and results
	roiManager("select",roi_list);
	roiManager("delete");

	run("Clear Results");
	//close("*");
}

//Measures intensity of each group of wells
function measure_rois(input,filename){
	open(input+filename);
	//This should be the same in both functions
	run("Median...", "radius="+med_rad);
	roiManager("Measure");
	close();
}

//Reformat the results into a table for easy plotting
function reformatResults(num_rows,time_step){
	headings = split(String.getResultsHeadings);
	Time=Array.getSequence(nResults/num_rows);
	for (j=0;j<Time.length;j++) {
		Time[j]*=time_step;
	}
	Table.create("Mean Well Intensities Over Time");
	Table.setColumn("Time",Time);
	for (n = 0; n < num_rows; n++){
		for (a=0; a< lengthOf(headings); a++){
			Table.setColumn(headings[a]+d2s(n+1,0) ,Time);
		}
	}
	for (n = 0; n < Table.size; n++) {
		for (i = 0; i < num_rows; i++) {
			Table.set(headings[0]+d2s(i+1,0) ,n, getResult("Mean", n*num_rows+i));
			Table.set(headings[1]+d2s(i+1,0) ,n, getResult("StdDev", n*num_rows+i));
		}
	}
	Table.update;
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
Dialog.addNumber("Number of wells", 6);
Dialog.addNumber("Number of rows", 2);
Dialog.addNumber("Time Step", 1);
Dialog.show();
result_title=Dialog.getString();
med_rad=Dialog.getNumber();
num_wells=Dialog.getNumber();
num_rows=Dialog.getNumber();
time_step=Dialog.getNumber();

if (num_wells%num_rows==0){
	//Get the position of the wells from first file
	get_rois(dir_in,list[0]);
	setBatchMode(true);
	run("Set Measurements...", "mean standard redirect=None decimal=3");
	//Measure rois for all images in directory
	for (i = 0; i < list.length; i++){
        measure_rois(dir_in, list[i]);
	}

	//Reformat results
	reformatResults(num_rows,time_step);
	//Close results window to avoid confusion
	selectWindow("Results");
    run("Close" );
	//Save results and close windows
	selectWindow("Mean Well Intensities Over Time");
	saveAs("Results", dir_out+result_title);
	IJ.renameResults(result_title,"Results");
	//cleanUp();
	setBatchMode(false);
}
else {
	print("Number of wells is not divisible by number or rows. Stopping macro")
	}	