/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   MuscleJ: A high content analysis method to study skeletal muscles.
// Copyright (C) 2018  Anne Danckaert – Alicia Mayeuf-Louchart
//
//   This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License.
// 
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
// 
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   MuscleJ: A high content analysis method to study skeletal muscles.
//
// The MuscleJ macro is a compilation of tools allowing for the analysis of fiber phenotypes.
//
//
// Authors: Anne Danckaert – Alicia Mayeuf-Louchart
//
// Features
// Fiber morphology – Centro Nuclei Fiber detection (CNF) – Vessel detection – Satellite Cell detection (Sat) – Fiber typing
//
// Citation : Mayeuf-Louchart et al. SkeletalMuscle (2018) 8:25
// Tutorial in Additional file 1: Tutorial

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function AreaClassAttribution(Area,FiberAreaClassCount) {
	if (Area < 250) {
		FiberAreaClassCount[0]= FiberAreaClassCount[0]+1;
	}
	else if ((Area < 500) && (Area >= 250)) {
		FiberAreaClassCount[1]= FiberAreaClassCount[1]+1;	
	}
	else if ((Area < 750) && (Area >= 500)) {
		FiberAreaClassCount[2]= FiberAreaClassCount[2]+1;	
	}
	else if ((Area < 1000) && (Area >= 750)) {
		FiberAreaClassCount[3]= FiberAreaClassCount[3]+1;	
	}
	else if ((Area < 2000) && (Area >= 1000)) {
		FiberAreaClassCount[4]= FiberAreaClassCount[4]+1;	
	}
	else if ((Area < 3000) && (Area >= 2000)) {
		FiberAreaClassCount[5]= FiberAreaClassCount[5]+1;	
	}
	else if ((Area < 4000) && (Area >= 3000)) {
		FiberAreaClassCount[6]= FiberAreaClassCount[6]+1;	
	}
	else if ((Area < 5000) && (Area >= 4000)) {
		FiberAreaClassCount[7]= FiberAreaClassCount[7]+1;	
	}
	else if ((Area < 6000) && (Area >= 5000)) {
		FiberAreaClassCount[8]= FiberAreaClassCount[8]+1;	
	}
	else if (Area >= 6000) {
		FiberAreaClassCount[9]= FiberAreaClassCount[9]+1;
	}
 }
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChooseColorCartography(Area, nLast,NameAreaImage) {
	Color = newArray(3);
	selectWindow(NameAreaImage);
	run("RGB Color");
   	roiManager("select", nLast);
	if (Area < 250) {
		Color[0]=255;
		Color[1]=255;
		Color[2]=255;	
	}
	if ((Area < 500) && (Area >= 250)) {
		Color[0]=221;
		Color[1]=255;
		Color[2]=221;	
	}
	if ((Area < 750) && (Area >= 500)) {
		Color[0]=189;
		Color[1]=255;
		Color[2]=189;	
	}
	if ((Area < 1000) && (Area >= 750)) {
		Color[0]=153;
		Color[1]=255;
		Color[2]=153;	
	}
	if ((Area < 2000) && (Area >= 1000)) {
		Color[0]=120;
		Color[1]=255;
		Color[2]=120;	
	}
	if ((Area < 3000) && (Area >= 2000)) {
		Color[0]=90;
		Color[1]=255;
		Color[2]=90;	
	}
	if ((Area < 4000) && (Area >= 3000)) {
		Color[0]=0;
		Color[1]=200;
		Color[2]=20;	
	}
	if ((Area < 5000) && (Area >= 4000)) {
		Color[0]=0;
		Color[1]=150;
		Color[2]=0;	
	}
	if ((Area < 6000) && (Area >= 5000)) {
		Color[0]=0;
		Color[1]=100;
		Color[2]=0;	
	}
	if (Area >= 6000) {
		Color[0]=0;
		Color[1]=50;
		Color[2]=10;	
	}
 	
	setForegroundColor(Color[0], Color[1], Color[2]);
	roiManager("Fill");
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FillFiberCartography(LamininWindows,ROIFiberFile,NameAreaImage,FiberArea,LegendBox) {
	selectWindow(LamininWindows);
	run("Duplicate...", "title="+NameAreaImage);
	run("Enhance Contrast...", "saturated=0.3");

	run("Add to Manager");
	roiManager("Open", ROIFiberFile);
	run("Select None");
	nbFibers=roiManager("count");

	for (i=0 ; i<nbFibers; i++) {
		ChooseColorCartography(FiberArea[i], i, NameAreaImage);
	}
	if (LegendBox=="Yes") {
		RangeArea=newArray("<250","250-500","500-750","750-1000","1000-2000","2000-3000","3000-4000","4000-5000","5000-6000",">6000");
		ColorArea=newArray(255,255,255,221,255,221,189,255,189,153,255,153,120,255,120,90,255,90,0,200,20,0,150,0,0,100,0,0,50,10);

		roiManager("reset");
		selectWindow(NameAreaImage);
		getDimensions(width, height, channels, slices, frames);
		for (i=0; i < 10; i++) {
			makeRectangle(0, i*100, 200, 100);
			roiManager("Add");
		}

		for (i=0; i < 10; i++) {
			roiManager("select", i);
			setForegroundColor(ColorArea[3*i],ColorArea[3*i+1],ColorArea[3*i+2]);
			roiManager("Fill");
			if (i<8) {
	  			setColor("black");
			}
			else {
				setColor("white");
			}
			setFont("Sanserif", 40);
			if (i<4) {
				drawString(RangeArea[i], 25, i*100+75);
			}
			else {
				drawString(RangeArea[i], 10, i*100+75);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FillCentroNucleiCartography(LamininWindows,ROICentroFiberFile,NameCentroImage,CentroNuclei,LegendBox) {
	
	selectWindow(LamininWindows);
	run("Duplicate...", "title="+NameCentroImage);
	run("Enhance Contrast...", "saturated=0.3");

	run("Add to Manager");
	roiManager("Open", ROICentroFiberFile);
	run("Select None");
		
	nbFibers=roiManager("count");


	for (i=0 ; i<nbFibers; i++) {
		selectWindow(NameCentroImage);
		run("RGB Color");

		roiManager("select", i);
		if (CentroNuclei[i] == 1) {
			setForegroundColor(255, 255, 0);
		}
		if (CentroNuclei[i] == 2) {
			setForegroundColor(255, 128, 0);
		}
		if (CentroNuclei[i] > 2) {
			setForegroundColor(255, 0, 0);
		}
		if (CentroNuclei[i] == 0) {
			setForegroundColor(255, 255, 255);
		}
		roiManager("Fill");
	}
	if (LegendBox=="Yes") {
		
		roiManager("reset");
		selectWindow(NameCentroImage);
		getDimensions(width, height, channels, slices, frames);
		
		BottomY=height-100;
		BottomYMidle=height-25;
		
		makeRectangle(0, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 0);
		setForegroundColor(255, 255, 255);
		roiManager("Fill");
	  	setColor("black");
		setFont("Sanserif", 50);
		drawString("0", 50, BottomYMidle);
	  
		makeRectangle(100, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 1);
		setForegroundColor(255, 255, 0);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 50);
		drawString("1", 125, BottomYMidle);
	
		
		makeRectangle(200, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 2);
		setForegroundColor(255, 128, 0);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 50);
		drawString("2", 225, BottomYMidle);
	
	
		makeRectangle(300, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 3);
		setForegroundColor(255, 0, 0);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 50);
		drawString("3+", 325, BottomYMidle);
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FillSatCellCartography(LamininWindows,NameSatCellImage,SatCell,LegendBox) {
	
	selectWindow(LamininWindows);
	run("Duplicate...", "title="+NameSatCellImage);
	run("Enhance Contrast...", "saturated=0.3");

	run("Add to Manager");
	roiManager("Open", ROIFiberFile);
	run("Select None");
		
	nbFibers=roiManager("count");


	for (i=0 ; i<nbFibers; i++) {
		selectWindow(NameSatCellImage);
		run("RGB Color");

		roiManager("select", i);
		if (SatCell[i] == 1) {
			setForegroundColor(255, 200, 255);
		}
		if (SatCell[i] >= 2) {
			setForegroundColor(255, 50, 255);
		}
		if (SatCell[i] == 0) {
			setForegroundColor(255, 255, 255);
		}
		roiManager("Fill");
	}

	if (LegendBox=="Yes") {
		
		roiManager("reset");
		selectWindow(NameSatCellImage);
		getDimensions(width, height, channels, slices, frames);
		
		BottomY=height-100;
		BottomYMidle=height-25;
		
		makeRectangle(0, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 0);
		setForegroundColor(255, 255, 255);
		roiManager("Fill");
	  	setColor("black");
		setFont("Sanserif", 50);
		drawString("0", 50, BottomYMidle);
	  
		makeRectangle(100, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 1);
		setForegroundColor(255, 200, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 50);
		drawString("1", 125, BottomYMidle);
	
		
		makeRectangle(200, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 2);
		setForegroundColor(255, 50, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 50);
		drawString("2+", 225, BottomYMidle);
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FillVesselsCartography(LamininWindows,NameVesselImage,CountVessel,LegendBox) {

	selectWindow(LamininWindows);
	run("Duplicate...", "title="+NameVesselImage);
	run("Enhance Contrast...", "saturated=0.3");

	run("Add to Manager");
	roiManager("Open", ROIFiberFile);
	run("Select None");
		
	nbFibers=roiManager("count");


	for (i=0 ; i<nbFibers; i++) {
		selectWindow(NameVesselImage);
		run("RGB Color");
		roiManager("select", i);
		if (CountVessel[i]<=1) setForegroundColor(255, 255, 255);
		else 
			if ((CountVessel[i]>= 2) && (CountVessel[i]<4))	setForegroundColor(200, 150, 255);
			else 
				if ((CountVessel[i]>= 4) && (CountVessel[i]<6)) setForegroundColor(200, 100, 255);
				else
					if ((CountVessel[i]>= 6) && (CountVessel[i]<8)) setForegroundColor(200, 0, 255);
					else
						if ((CountVessel[i]>= 8) && (CountVessel[i]<10)) setForegroundColor(100, 0, 150);
						else
							if (CountVessel[i]>= 10) setForegroundColor(100, 0, 100);
		roiManager("Fill");
	}
	if (LegendBox=="Yes") {
		
		roiManager("reset");
		selectWindow(NameVesselImage);
		getDimensions(width, height, channels, slices, frames);
		
		BottomY=height-100;
		BottomYMidle=height-25;
		
		makeRectangle(0, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 0);
		setForegroundColor(255, 255, 255);
		roiManager("Fill");
	  	setColor("black");
		setFont("Sanserif", 40);
		drawString("0-1", 25, BottomYMidle);
	  
		makeRectangle(100, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 1);
		setForegroundColor(200, 150, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 40);
		drawString("2-3", 125, BottomYMidle);
		
		makeRectangle(200, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 2);
		setForegroundColor(200, 100, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 40);
		drawString("4-5", 225, BottomYMidle);

		makeRectangle(300, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 3);
		setForegroundColor(200, 0, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 40);
		drawString("6-7", 325, BottomYMidle);

		makeRectangle(400, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 4);
		setForegroundColor(100, 0, 150);
		roiManager("Fill");
		setColor("white");
		setFont("Sanserif", 40);
		drawString("8-9", 425, BottomYMidle);

		makeRectangle(500, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 5);
		setForegroundColor(100, 0, 100);
		roiManager("Fill");
		setColor("white");
		setFont("Sanserif", 40);
		drawString("10+", 525, BottomYMidle);
	}
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function TypeCartographyFill(NameTypeImage,FiberPhenoType1,FiberPhenoType2a,FiberPhenoType2b,FiberPhenoType2x,LegendBox)
{
	Color = newArray(3);
	selectWindow(NameTypeImage);
	run("RGB Color");
	
	nbFibers= roiManager("count")- 1;
	for (i=0 ; i<nbFibers; i++) {
		selectWindow(NameTypeImage);
		// Ambiguous Type
		Color[0]=255;
		Color[1]=255;
		Color[2]=255;
		// Type I
		if ((FiberPhenoType1[i] ==1) && (FiberPhenoType2a[i]==0) && (FiberPhenoType2b[i]==0)) {
			Color[0]=255;
			Color[1]=0;
			Color[2]=0;
		}
		else
		// Type IIA
		if ((FiberPhenoType1[i] ==0) && (FiberPhenoType2a[i]==1) && (FiberPhenoType2b[i]==0)) {
			Color[0]=185;
			Color[1]=0;
			Color[2]=255;
		}
		else
		// Type IIB
		if ((FiberPhenoType1[i] ==0) && (FiberPhenoType2a[i]==0) && (FiberPhenoType2b[i]==1)) {
			Color[0]=0;
			Color[1]=0;
			Color[2]=255;
		}
		else
		// Type IIB ambig
		if ((FiberPhenoType1[i] ==0) && (FiberPhenoType2a[i]==0) && (FiberPhenoType2b[i]==2)) {
			Color[0]=0;
			Color[1]=0;
			Color[2]=255;
		}
		else
		// Type I or IIA
		if ((FiberPhenoType1[i] ==1) && (FiberPhenoType2a[i]==1) && (FiberPhenoType2b[i]==0)) {
			Color[0]=255;
			Color[1]=0;
			Color[2]=255;
		}
		else
		// Type I or IIB
		if ((FiberPhenoType1[i] ==1) && (FiberPhenoType2a[i]==0) && (FiberPhenoType2b[i]>0)) {
			Color[0]=255;
			Color[1]=140;
			Color[2]=255;
		}

		else
		// Type IIA or IIB
		if ((FiberPhenoType1[i] ==0) && (FiberPhenoType2a[i]==1) && (FiberPhenoType2b[i]>0)) {
			Color[0]=150;
			Color[1]=150;
			Color[2]=255;
		}
		else
		// Type IIX
		if (FiberPhenoType2x[i] ==1) {
			Color[0]=0;
			Color[1]=30;
			Color[2]=139;
		}
   		roiManager("select", i);
   		setForegroundColor(Color[0], Color[1], Color[2]);
		roiManager("Fill");
	}
	// Add legend on bottom left
	if (LegendBox=="Yes") {
		
		roiManager("reset");
		selectWindow(NameTypeImage);
		getDimensions(width, height, channels, slices, frames);
		
		BottomY=height-225;
		BottomYMidle=height-150;

		BottomYHyb=height-100;
		BottomYHybMidle=height-25;
		
		makeRectangle(0, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 0);
		setForegroundColor(255, 0, 0);
		roiManager("Fill");
	  	setColor("black");
		setFont("Sanserif", 50);
		drawString("I", 50, BottomYMidle);
	  	
		makeRectangle(100, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 1);
		setForegroundColor(185, 0, 255);
		roiManager("Fill");
		setColor("white");
		setFont("Sanserif", 50);
		drawString("IIA", 125, BottomYMidle);
	
		makeRectangle(200, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 2);
		setForegroundColor(0, 30, 139);
		roiManager("Fill");
		setColor("white");
		setFont("Sanserif", 50);
		drawString("IIX", 225, BottomYMidle);
	
		makeRectangle(300, BottomY, 100, 100);
		roiManager("Add");
		roiManager("select", 3);
		setForegroundColor(0, 0, 255);
		roiManager("Fill");
		setColor("white");
		setFont("Sanserif", 50);
		drawString("IIB", 325, BottomYMidle);
		drawString("Pure Types", 425, BottomYMidle);
		
		// Hybrid
		
		makeRectangle(0, BottomYHyb, 100, 100);
		roiManager("Add");
		roiManager("select", 4);
		setForegroundColor(255, 0, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 35);
		drawString("I-IIA", 25, BottomYHybMidle);

		makeRectangle(100, BottomYHyb, 100, 100);
		roiManager("Add");
		roiManager("select", 5);
		setForegroundColor(255, 140, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 35);
		drawString("I-IIB", 125, BottomYHybMidle);
		
		makeRectangle(200, BottomYHyb, 100, 100);
		roiManager("Add");
		roiManager("select", 6);
		setForegroundColor(150, 150, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 35);
		drawString("IIA-IIB", 205, BottomYHybMidle);

		makeRectangle(300, BottomYHyb, 100, 100);
		roiManager("Add");
		roiManager("select", 7);
		setForegroundColor(255, 255, 255);
		roiManager("Fill");
		setColor("black");
		setFont("Sanserif", 35);
		drawString("ND", 325, BottomYHybMidle);
		setColor("white");
		setFont("Sanserif", 50);
		drawString("Hybrid Types", 425, BottomYHybMidle);
		
		roiManager("reset");
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function NucleiDetectionOnDAPI(System,DAPIWindows) {

	//open nuclei image	

	selectWindow(DAPIWindows);
	run("Duplicate...", "title=[DAPI Temp]");

	// Segmentation of nuclei
	if (System=="Spinning Disk") {
		run("Enhance Contrast...", "saturated=0.1");
	}
	else {
		run("Enhance Contrast...", "saturated=0.1 normalize");
	}
	run("Subtract Background...", "rolling=50");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Options...", "iterations=1 count=2 black do=Erode");
	run("Watershed");
	run("Ultimate Points");
	setThreshold(1, 255);
	run("Convert to Mask");
	run("Options...", "iterations=2 count=1 black do=Dilate");
	run("Analyze Particles...", "size=1-200 pixel display clear");
	nbNuclei= nResults - 1;
	roiManager("reset");	
	selectWindow("Results"); 
	run("Close");

	return nbNuclei;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ArtefactDetectionOnLaminin(FiberImageWindows, bCrop, LimitDetectionFiberArea, bArtefacts) {

	selectWindow(FiberImageWindows);
	run("Duplicate...", "title=[Fiber Temp]");
	getStatistics(area, mean, min, max, std, histogram);
	//MinArea=1000;
	MinArea=0.05*area;

	// Segmentation of entire section
	run("Enhance Contrast", "saturated=0.60 normalize equalize");
	if (bCrop)
		setAutoThreshold("Li dark");
	else
		setAutoThreshold("Otsu dark");
	run("Convert to Mask");
	run("Fill Holes");
	run("Analyze Particles...", "size="+MinArea+"-Infinity add display clear");

	MaxSurf=0;
	// Max Area has been kept
	if (nResults >0) {
		selectWindow("Results");
		MaxIndex=0;
		for (i=0; i<nResults; i++) {
			CurrentArea=getResult("Area", i);
			if (MaxSurf < CurrentArea) {
				MaxIndex=i;
				MaxSurf=CurrentArea;
			}
		}
		run("Close");
		selectWindow("ROI Manager");
		if (roiManager("count") > 1) {
			for (i=0; i < roiManager("count"); i++) {
				if (i != MaxIndex) {
					roiManager("Select", i);
					roiManager("Delete");
				}
			}
		}
		roiManager("Set Color", "red");
		roiManager("Set Line Width", 0);

		// Quality Check
		selectWindow(FiberImageWindows);
		run("Duplicate...", "title=[Fiber Quality Check]");
		selectWindow("Fiber Quality Check");
		run("Enhance Contrast...", "saturated=10 normalize equalize");
		run("Gaussian Blur...", "sigma=2");
		run("Enhance Contrast...", "saturated=1 normalize");
		run("Subtract Background...", "rolling=20");
		if (bCrop == false) {
			run("Gaussian Blur...", "sigma=10");
			run("Subtract Background...", "rolling=50");
		}
		getStatistics(area, mean, min, max, std, histogram);
		if (bCrop == false) {
			ThresholdF=mean+std/3.0;
		}
		else {
			ThresholdF=mean;
		}
		run("Find Maxima...", "noise="+ThresholdF+" output=[Segmented Particles] light");
		
		selectWindow("Fiber Quality Check Segmented");
		run("Invert");
		run("Options...", "iterations=2 count=1 black do=Dilate");
		run("Options...", "iterations=3 count=1 black do=Close");
		run("Invert");
		
		selectWindow("ROI Manager");		
		roiManager("Select", 0); // ROI selected as max area
		
		run("Analyze Particles...", "size=0-infinity circularity=0.45-1.00 display add in_situ");
		selectWindow("Results");
		TotFiberArea=0;
		for (i=1; i < roiManager("count")-1; i++) {
			TotFiberArea=TotFiberArea+getResult("Area", i);
		}
		
		selectWindow("Results");
		run("Close");
		selectWindow("Fiber Quality Check Segmented");
		close();
		selectWindow("Fiber Quality Check");
		close();
		FibersAreaPercent= TotFiberArea/MaxSurf;
		FibersAreaPercent= 100*FibersAreaPercent;
			
		if (FibersAreaPercent < LimitDetectionFiberArea) {
			bArtefacts=true;
		}

			
		AllROI=roiManager("count")-1;
		
		i=1;
		while (i <= AllROI) {
			roiManager("Select", 1);
			roiManager("Delete");
			i=i+1;	
		}
		
	}

	selectWindow("Fiber Temp");
	close();

	return MaxSurf;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FiberShapeDetectionOnLaminin(FiberImageWindows,ROIFiberFile,ROICentroFiberFile,ROISatCellFiberFile,ROIVesselFiberFile,FiberArea,FiberFeret,MinFiberFeret,FiberAreaClassCount,nThreshold, bCrop) {
	
	// Segmentation of Fibers
	selectWindow(FiberImageWindows);
	run("Duplicate...", "title=[Fiber Temp]");
	selectWindow("Fiber Temp");
	run("Enhance Contrast...", "saturated=10 normalize equalize");
	run("Gaussian Blur...", "sigma=2");
	run("Enhance Contrast...", "saturated=1 normalize");
	run("Subtract Background...", "rolling=20");
	if (bCrop == false) {
		run("Gaussian Blur...", "sigma=10");
		run("Subtract Background...", "rolling=50");
	}
	getStatistics(area, mean, min, max, std, histogram);
	if (bCrop == false) {
		ThresholdF=mean+std/3.0;
	}
	else {
		ThresholdF=mean;
	}
	run("Find Maxima...", "noise="+ThresholdF+" output=[Segmented Particles] light");
	nThreshold[0]=ThresholdF;
	
	selectWindow("Fiber Temp Segmented");
	run("Invert");
	run("Options...", "iterations=2 count=1 black do=Dilate");
	run("Options...", "iterations=3 count=1 black do=Close");
	run("Invert");
	
	roiManager("Select", 0); // ROI selected as max area
	run("Analyze Particles...", "size=0-infinity circularity=0.00-1.00 display add in_situ");
	selectWindow("Results");
	AreaMean=Variance=0;
	for (i=1; i <roiManager("count")-1; i++) {
		AreaMean=AreaMean+getResult("Area", i);
	}
	AreaMean=AreaMean/(roiManager("count")-2);
	for (i=1; i <roiManager("count")-1; i++) {
		Variance=Variance+((getResult("Area", i)-AreaMean)*(getResult("Area", i)-AreaMean));
	}
	selectWindow("Results");
	run("Close");
	
	Variance=Variance/(roiManager("count")-2);
	StdDev=sqrt(Variance);
	MinArea=100;
	if (bCrop) {
		MaxArea=AreaMean+4*StdDev;
	}
	else
		MaxArea=AreaMean+3*StdDev;

	AllROI=roiManager("count")-1;
	
	i=1;
	while (i <= AllROI) {
		roiManager("Select", 1);
		roiManager("Delete");
		i=i+1;	
	}
	
	TotSurfaceFibers =0;

	nbFibers=nbFibersLast=0;

	// second quality check to eliminate outliers
	roiManager("Select", 0); // ROI selected as max area
	run("Analyze Particles...", "size=MinArea-MaxArea circularity=0.45-1.00 display add in_situ");
	nbFibers= roiManager("count")-1;
	selectWindow("Results");
	for (j=0; j<nbFibers; j++) {
		FiberArea[j]=getResult("Area", j);
		AreaClassAttribution(FiberArea[j],FiberAreaClassCount);
		FiberFeret[j]=getResult("Feret", j);
		MinFiberFeret[j]=getResult("MinFeret", j);
		TotSurfaceFibers=TotSurfaceFibers+FiberArea[j];
	}
	selectWindow("ROI Manager");
	roiManager("Select", 0); // ROI selected as max area
	roiManager("Delete");
	roiManager("Show All without labels");
	roiManager("Set Color", "green");
	roiManager("Set Line Width", 0);
	roiManager("Save", ROIFiberFile);

	
	selectWindow("Results");
	run("Close");

	// Save ROIs for Fiber Morphology Analysis
	if (nbFibers > 0) {
		selectWindow("ROI Manager");
		// Save ROIs for FCN Analysis
		for (i=0 ; i<nbFibers; i++) {
		    roiManager("select", i);
		    //1/5 of Feret Diameter Length
		    RealFNCROIwithFeret=MinFiberFeret[i]/5; // previousversion 8
		    run("Enlarge...", "enlarge=-"+RealFNCROIwithFeret);
		    //run("Enlarge...", "enlarge=-15");
		    roiManager("Add");
		}
		for (i=0 ; i<nbFibers; i++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}
		roiManager("Set Color", "blue");
		roiManager("Set Line Width", 0);
		roiManager("Save", ROICentroFiberFile);
		roiManager("reset");
	
		// Save ROIs for Satellite Cell Analysis and Peri nuclei counting
		roiManager("Open", ROIFiberFile);
		nbSelectedFibers=roiManager("count");
		roiManager("Open", ROICentroFiberFile);
		AllFibersROI=roiManager("count");
		selectWindow("ROI Manager");
		roiManager("Show All without labels");
		for (i=0 ; i<nbSelectedFibers; i++) {
			iEnlarge=i+nbSelectedFibers;
			MultiSelect= newArray(i,iEnlarge);
			roiManager("Select", MultiSelect);
			roiManager("XOR");
			roiManager("Add");

		}
		selectWindow("ROI Manager");
		for (i=0; i < AllFibersROI; i++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}
		roiManager("Set Color", "#ffc800");
		roiManager("Set Line Width", 0);

		roiManager("Save", ROISatCellFiberFile);
		roiManager("reset");
		
		// Save ROIs for Vessel counting		
		roiManager("Open", ROIFiberFile);
		nbSelectedFibers=roiManager("count");
		roiManager("Show All without labels");
		
		for (i=0 ; i<nbSelectedFibers; i++) {
			roiManager("Select", i);
			RealVROIwithFeret=MinFiberFeret[i]/8;
		    run("Enlarge...", "enlarge="+RealVROIwithFeret);
			roiManager("Add");
		}
		AllFibersROI=roiManager("count");
		for (i=0 ; i<nbSelectedFibers; i++) {
			iEnlarge=i+nbSelectedFibers;
			MultiSelect= newArray(i,iEnlarge);
			roiManager("Select", MultiSelect);
			roiManager("XOR");
			roiManager("Add");
		}
		selectWindow("ROI Manager");
		for (i=0; i < AllFibersROI; i++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}
		roiManager("Set Color", "cyan");
		roiManager("Set Line Width", 0);

		roiManager("Save", ROIVesselFiberFile);
		roiManager("reset");
	}
	
	selectWindow("Fiber Temp Segmented");
	run("Close");
	selectWindow("Fiber Temp");
	run("Close");

	return TotSurfaceFibers;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function CentroNucleiFiberTracking(ROIFiberFile,ROICentroFiberFile,ROIPeriFiberFile,DAPIWindows,CentroNuclei,PeriNuclei) {

	selectWindow("DAPI Temp");
	run("Make Binary");
	
	run("Add to Manager");
	roiManager("Open", ROICentroFiberFile);

	nbFibers=roiManager("count");
	NbCentroNucleiCount = 0;
	
	roiManager("Show None");
	for (i=0; i<nbFibers; i++) {

		selectWindow("DAPI Temp");
	    roiManager("select", i);
	    run("Analyze Particles...", "size=1-100 pixel circularity=0.45-1.00 display clear");
	    
	    CentroNuclei[i] = nResults;
     	if (CentroNuclei[i] > 0) {
    		NbCentroNucleiCount = NbCentroNucleiCount+1;
    	}
	}
	roiManager("reset");

	roiManager("Open", ROIPeriFiberFile);

	nbFibers=roiManager("count");
	
	roiManager("Show None");
	for (i=0; i<nbFibers; i++) {

		selectWindow("DAPI Temp");
	    roiManager("select", i);
	    run("Analyze Particles...", "size=1-100 pixel circularity=0.45-1.00 display clear");
	    PeriNuclei[i] = nResults;
	}
	roiManager("reset");
	return NbCentroNucleiCount;
}

/////////////////////////////////////////A REVOIR//////////////////////////////////////////////////////////
function SatCellDetectionOnPax7(System,Pax7Windows, DAPIWindows, nThreshold) {
	
	
	selectWindow(Pax7Windows);
	run("Duplicate...", "title=[Sat Temp]");
	selectWindow("Sat Temp");
	
	// Segmentation of cell
	if (System=="Spinning Disk") {
		run("Enhance Contrast...", "saturated=0.1");
	}
	else {
		run("Enhance Contrast...", "saturated=0.1 normalize");
	}

	run("Subtract Background...", "rolling=50");
	setAutoThreshold("Yen dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Fill Holes");
	run("Analyze Particles...", "size=3-100 circularity=0.45-1.00 display add clear"); // in microns!!
	nbSatCells= nResults;
	NbPosSatCells=0;
	if (nbSatCells>0) {
		selectWindow("Results"); 
		run("Close");
		
		// Algo without threshold
		selectWindow("DAPI Temp");
		run("Make Binary");
		NbPosSatCells = 0;
	
		roiManager("Show None");
	
		for (i=0 ; i<nbSatCells; i++) {
	
			selectWindow("DAPI Temp");
		    roiManager("select", i);
		    run("Analyze Particles...", "size=1-100 pixel circularity=0.45-1.00 display clear");
	     	if (nResults > 0) {
	    		NbPosSatCells = NbPosSatCells+1;
	    	}
	    	else {
	    		roiManager("select", i);
				roiManager("Delete");
				i = i-1;
				nbSatCells = nbSatCells-1;
	    	}
		}
		if (NbPosSatCells>0) {
			setForegroundColor(0, 0, 0);
			selectWindow("Sat Temp");
			run("Select All");
			run("Fill", "slice");
		
			setForegroundColor(255, 255, 255);
			selectWindow("Sat Temp");
			for (i=0 ; i<NbPosSatCells; i++) {
			    roiManager("select", i);
				roiManager("Fill");
			}
			
		
			nThreshold[2]=0;
			roiManager("reset");	
			
			selectWindow("Sat Temp");
			run("Options...", "iterations=1 count=2 black do=Erode");
			//run("Watershed");
			run("Ultimate Points");
			setThreshold(1, 255);
			run("Convert to Mask");
			run("Options...", "iterations=2 count=1 black do=Dilate");
			selectWindow("DAPI Temp");
			run("Close");
		}
	}

	return NbPosSatCells;	
}
///////////////////////////////////A REVOIR////////////////////////////////////////////////////////////////////////////////////
function SatCellsTracking(ROIFile, ROISatCellFiberFile,SatCells) {

	selectWindow("Sat Temp"); // after ultimate points, satellite cells are represented by their Gravity Center
	run("Make Binary");

	roiManager("Open", ROISatCellFiberFile);
	nbSelectedFibers = roiManager("count");

	roiManager("Show None");
	numFibers=0;

	nbFiberWithSatCell=0;
	RealIndex=0;

	for (i=0; i<nbSelectedFibers; i++) {
		selectWindow("Sat Temp");
	    roiManager("select", i);
	    run("Analyze Particles...", "size=1-100 circularity=0.00-1.00 display clear");
    	SatCells[numFibers] = nResults;
	    if (nResults > 0) {
	    	nbFiberWithSatCell = nbFiberWithSatCell+1;
	    }
	    numFibers=numFibers+1;
	}

	selectWindow("Results");
	run("Close");
	
	roiManager("reset");	
	return nbFiberWithSatCell;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VesselDetectionOnCD31(System,VesselWindows,ROIVessel,VascularisationCriteria, VesselsFileName) {

	selectWindow(VesselWindows);
	run("Duplicate...", "title=[Vessel Temp]");
	selectWindow("Vessel Temp");

	// Segmentation of nuclei
	if (System=="Spinning Disk") {
		run("Enhance Contrast...", "saturated=0.1");
	}
	else {
		run("Enhance Contrast...", "saturated=0.1 normalize");
	}
	
	run("Subtract Background...", "rolling=50");
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Fill Holes");
	run("Median...", "radius=3");
	run("Analyze Particles...", "size=5-Infinity display clear");
	selectWindow("Results");
	VascularisationCriteria[1]= nResults; 
	for (i=0; i < nResults; i++) {
		VascularisationCriteria[0]=VascularisationCriteria[0]+getResult("Area",i);
	}

	run("Close");	
	roiManager("reset");	

	run("Analyze Particles...", "size=5-100 circulary=0.4-1.00 display add clear");
	
	selectWindow("ROI Manager");
	roiManager("Save", ROIVessel);
	nbVessels=nResults - 1;
	
	setForegroundColor(0, 0, 0);
	selectWindow("Vessel Temp");
	run("Select All");
	run("Fill", "slice");

	setForegroundColor(255, 255, 255);
	selectWindow("Vessel Temp");
	for (i=0 ; i<=nbVessels; i++) {
	    roiManager("select", i);
		roiManager("Fill");
	}
	
	roiManager("reset");
	selectWindow("Results"); 
	run("Close");

	selectWindow("ROI Manager");
	roiManager("Open", ROIVessel);
	selectWindow(VesselWindows);
	roiManager("Show All");
	run("Set Measurements...", "area mean centroid redirect=None decimal=3");
	roiManager("Measure");
	selectWindow("Results"); 
	saveAs("Results", VesselsFileName);
	run("Set Measurements...", "area mean centroid feret's redirect=None decimal=3");
	selectWindow("Results"); 
	run("Close");


	return nbVessels;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VesselTracking(ROIVesselFiberFile,VesselWindows,Vessels) {
	
	selectWindow("Vessel Temp");
	run("Ultimate Points");
	setThreshold(1, 255);
	run("Convert to Mask");
	run("Options...", "iterations=2 count=1 black do=Dilate");
	run("Make Binary");
	roiManager("reset");	
	roiManager("Open", ROIVesselFiberFile);
	nbSelectedFibers = roiManager("count");
	numFibers=0;
	nbRealFiberVessels=0;

	for (i=0 ; i<nbSelectedFibers; i++) {
		roiManager("select", i);
	    run("Analyze Particles...", "size=1-100 pixel circularity=0.45-1.00 display clear summarize");
	    Vessels[i] = nResults;
    	if (Vessels[i] > 0) {
    		nbRealFiberVessels = nbRealFiberVessels+1;
    	}
     	numFibers=numFibers+1;
    }
	
	roiManager("reset");
	selectWindow("Results"); 
	run("Close");
	selectWindow(VesselWindows);
	run("Close");
	selectWindow("Vessel Temp");
	run("Close");
	
	return nbRealFiberVessels;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FiberTypeDetection(ROIFile,TypeWindows,FiberType,FiberPhenoType,TypeAnalysis,nThreshold)
{

	selectWindow(TypeWindows);
	if (TypeAnalysis==5) {
		run("Subtract Background...", "rolling=50");
	}
	getStatistics(area, mean, min, max, std, histogram);
	if (TypeAnalysis==5) {
		ThresholdFound=mean+std;
		nThreshold[6]=mean; // Type IIB ambig
	}
	else {
		ThresholdFound=mean+3*std;
	}
	nThreshold[TypeAnalysis]=ThresholdFound;
	roiManager("reset");
	roiManager("Open", ROIFile);
	roiManager("Show None");
	nbSelectedFibers = roiManager("count");
	nbFiberType=0;

	//run("Convert to Mask");

	for (i=0 ; i<nbSelectedFibers; i++) {
		FiberType[i] =0;
		FiberPhenoType[i]=0;
	    roiManager("select", i);
	    roiManager("Measure");
		selectWindow("Results");
		FiberType[i]=getResult("Mean",i);
		if (FiberType[i]>ThresholdFound) {
			FiberPhenoType[i]=1;
			nbFiberType=nbFiberType+1;
		}
		if (TypeAnalysis==5) {
			if ((FiberType[i]<= ThresholdFound) && (FiberType[i]>nThreshold[6])){
				FiberPhenoType[i]=2;
				nbFiberType=nbFiberType+1;
			}
		}
	}
	run("Close");
	roiManager("reset");
	run("Clear Results");
	
	return nbFiberType;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FiberIntensityDetection(ROIFile,IntensityWindows,Intensity) 
{
	selectWindow(IntensityWindows);

	roiManager("reset");
	roiManager("Open", ROIFile);
	roiManager("Show None");
	nbSelectedFibers = roiManager("count");

	for (i=0 ; i<nbSelectedFibers; i++) {
		Intensity[i] =0;
	    roiManager("select", i);
	    roiManager("Measure");
		selectWindow("Results");
		Intensity[i]=getResult("Mean",i);
	}
	run("Close");
	roiManager("reset");
	run("Clear Results");
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////        					MAIN PROGRAM            				////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

Dialog.create("MUSCLEJ : Fiber Phenotype");

Dialog.setInsets(0, 0, 0);
Dialog.addMessage("Data Acquisition\n=============");

items = newArray("Apotome/WideField","Confocal/Spinning Disk");
Dialog.addRadioButtonGroup("Microscopy", items, 1, 2, "Apotome/WideField");

items = newArray("Single Z","Z stack");
Dialog.addRadioButtonGroup("Volume", items, 1, 2, "Single Z");

items = newArray("Entire","Crop");
Dialog.addRadioButtonGroup("Scanned muscle area", items, 1, 2, "Entire");

items = newArray("Original File Format","TIFF (16bits) by channel");
Dialog.addRadioButtonGroup("Data Format", items, 1, 2, "Original File Format");

Dialog.setInsets(0, 0, 0);
Dialog.addMessage(" \nData Analysis\n=============");
labels=newArray("Fiber Morphology", "Fiber Type1", "Centro Nuclei Detection", "Fiber Type2A","Satellite Cells","Fiber Type2B","Vessel","Intensity Only");
defaults = newArray(1,0,0,0,0,0,0,0);
Dialog.addCheckboxGroup(4, 2, labels, defaults);
Dialog.addSlider("Artefact Detection (%area min)", 10, 100, 40);

Dialog.setInsets(0, 0, 0);
Dialog.addMessage(" \nData Cartography\n==============");


items = newArray("None","Fiber Area Classes","Centro Nuclei Classes","Sat Cell","Fiber Types","Vessels");

Dialog.addChoice("Cartography Choice:", items,"None");
items = newArray("Yes","No");

Dialog.addChoice("Legend", items,"No");
Dialog.show();

System=Dialog.getRadioButton();
OneZ=Dialog.getRadioButton();
FullSection=Dialog.getRadioButton();
bCrop=false;

if (FullSection=="Crop") {
	bCrop=true;
}
FileFormat=Dialog.getRadioButton();

checkAnalysis = newArray(0,0,0,0,0,0,0,0);
NumChannel = newArray(-1,-1,-1,-1,-1,-1,-1,-1);

for (i=0; i<8; i++) {
     checkAnalysis[i] = Dialog.getCheckbox();
 }
LimitDetectionFiberArea = Dialog.getNumber();     

CartographyBox=Dialog.getChoice();
LegendBox=Dialog.getChoice();

Dialog.create("Channel Information");
items = newArray("","1","2","3","4");
if (FileFormat=="TIFF (16bits) by channel") {
	Dialog.addChoice("Nb Channels to read for a set of TIFF files?", items);
	Dialog.addString("Pixel width (micron)", "");
	Dialog.addString("Pixel height (micron)", "");
}
NameAnalysis=newArray("Fiber Morphology", "Fiber Type1", "Centro Nuclei Detection", "Fiber Type2A","Satellite Cells","Fiber Type2B","Vessel","Intensity Only");
Dialog.addChoice("Fiber Shape", items);
for (i=1; i<= 7; i++) {
	if (checkAnalysis[i]) {
		if (i==4) {
			Dialog.addChoice("Nuclei Detection", items);
		}
		Dialog.addChoice(NameAnalysis[i], items);
	}
}

Dialog.show();

// Check answer coherence from Dialog Box Channel Information
NbChannels=1;
if (FileFormat=="TIFF (16bits) by channel") {
	NbChannels=Dialog.getChoice();
	XResol=Dialog.getString();
	YResol=Dialog.getString();
	if ((XResol=="") || (YResol=="")) {
		Dialog.create("Channel Information");
		Dialog.addMessage("Error in pixel size");
		Dialog.show();
		exit();
	}
}
ChannelNuclei=ChannelFiber=ChannelSatCell=ChannelVessel=ChannelSlow_Fast=-1;

///////////////////////////////////////////////////////////////
depart=getDirectory("Select Image File Folder for batch");
list = getFileList(depart);
arrivee=getDirectory("Select Result Folder to save ROI, tables and Cartographies");
listdone = getFileList(arrivee);

ArtefactDir=arrivee+"/Artefacts/";
ROIDir=arrivee+"/ROI/";
CartoDir=arrivee+"/Cartography/";
ResultDir=arrivee+"/Results_byfile/";

if (listdone.length < 4) {
	File.makeDirectory(ArtefactDir);
	File.makeDirectory(ROIDir);
	File.makeDirectory(CartoDir);
	File.makeDirectory(ResultDir);
}
else {
	listdone = getFileList(ROIDir);
}

TableResume = newArray(100);

nCurrentLine=1;

NumChannel[0]=Dialog.getChoice();
if (FileFormat=="TIFF (16bits) by channel") { ChannelFiber = parseInt(NumChannel[0]);} else { ChannelFiber = parseInt(NumChannel[0])-1;}

for (i=1; i<= 7; i++) {
	if (checkAnalysis[i]) {
		if (i==4) {
			NumChannel[2]=Dialog.getChoice();
		}
		NumChannel[i]=Dialog.getChoice();
	}
}

if (checkAnalysis[2]) {
	if (FileFormat!="TIFF (16bits) by channel") ChannelNuclei = parseInt(NumChannel[2])-1; else ChannelNuclei = parseInt(NumChannel[2]);
}
if (checkAnalysis[4]) {
	if (FileFormat!="TIFF (16bits) by channel") {
		ChannelNuclei = parseInt(NumChannel[2])-1;
		ChannelSatCell= parseInt(NumChannel[4])-1;
	}
	else {
		ChannelNuclei = parseInt(NumChannel[2]);
		ChannelSatCell= parseInt(NumChannel[4]);
	}
}

if (checkAnalysis[6]) {
	if (FileFormat!="TIFF (16bits) by channel") ChannelVessel= parseInt(NumChannel[6])-1; else ChannelVessel= parseInt(NumChannel[6]);
}
if (checkAnalysis[1]) {
	if (FileFormat!="TIFF (16bits) by channel") ChannelType1= parseInt(NumChannel[1])-1; else ChannelType1= parseInt(NumChannel[1]);
}
if (checkAnalysis[3]) {
	if (FileFormat!="TIFF (16bits) by channel") ChannelType2A= parseInt(NumChannel[3])-1; else ChannelType2A= parseInt(NumChannel[3]);
}
if (checkAnalysis[5]) {
	if (FileFormat!="TIFF (16bits) by channel") ChannelType2B= parseInt(NumChannel[5])-1; else ChannelType2B= parseInt(NumChannel[5]);
}
if (checkAnalysis[7]) {
	if (FileFormat!="TIFF (16bits) by channel") ChannelIntensity= parseInt(NumChannel[7])-1; else ChannelIntensity= parseInt(NumChannel[7]);
}

run("Set Measurements...", "area mean centroid feret's redirect=None decimal=3");

/////////////////////////////////////////////////////////////////////
if (FileFormat!="TIFF (16bits) by channel") {
	print(depart+"==> "+list.length+" sections to treat");
}
else {
	print(depart+"==> "+list.length/NbChannels+" set of images to treat");

}

NameGlobalResult="RunGlobalResult";
FullName=newArray(20);

if (FileFormat=="TIFF (16bits) by channel") {
	// Check of resolution 
	Dialog.create("MUSCLEJ : Resolution Check");
	
}
for (ik=0; ik<list.length; ik=ik+NbChannels) {
	// Generic information
	FiberFeret = newArray(10000);
	MinFiberFeret = newArray(10000);
	FiberArea = newArray(10000);

	CentroNuclei = newArray(10000);
	PeriNuclei = newArray(10000);
	SatCells = newArray(10000);
	Vessels = newArray(10000);
	Intensity = newArray(10000);
	FiberType1 = newArray(10000);
	FiberType2a = newArray(10000);
	FiberType2b = newArray(10000);
	FiberPhenoType1 = newArray(10000);
	FiberPhenoType2a = newArray(10000);
	FiberPhenoType2b = newArray(10000);
	FiberPhenoType2x = newArray(10000);
	nThreshold = newArray(0,0,0,0,0,0,0,0,0,0);
	FiberAreaClassCount = newArray(0,0,0,0,0,0,0,0,0,0);
	VascularisationCriteria = newArray(0,0);
	
	nbFibers=nFeretMean=NbCentroNucleiCount=NbCellSat=NbRealSatCells=nbFiberWithSatCell=nbVessels=nFiberswithVessels=0;
	nbFiberType1=nbFiberType2a=nbFiberType2a_Ambig=nbFiberType2b=nbFiberType2b_Ambig=nbFiberType2x=nbFiberArtefactHyb1=nbFiberArtefactHyb2=nbFiberArtefactHyb3=nbFiberArtefact=IntensityMean=0;
	SurfaceTotSection=TotFiberFeret=PercentVascularisation=NbTotVessels=0;
	
	GlobalName="";
	FullName = split(list[ik],".");
	GlobalName=FullName[0];
	TempGlobalName="";
	if (FileFormat =="TIFF (16bits) by channel") {
		TempGlobalName=substring(GlobalName, 0, lengthOf(GlobalName)-3);
		GlobalName=TempGlobalName;
	}

	print("File in process: "+GlobalName);
	NameNucleiImage = GlobalName+"_Nuclei.jpg";
	NameLamininImage = GlobalName+"_Fibers.jpg";
	NameNucleiResult = GlobalName+"_Nuclei.txt";
	NameCentroImage = GlobalName+"_CentroFibers.jpg";
	NameSatCellImage = GlobalName+"_SatelliteCells.jpg";
	NameSatCellPosImage = GlobalName+"_SatelliteCellsPos.jpg";
	NameAreaImage = GlobalName+"_FiberArea.jpg";
	NameTypeImage = GlobalName+"_FiberType.jpg";
	NameVesselsImage = GlobalName+"_FiberVessels.jpg";
	NameLamininResult = GlobalName+"_FiberDetails";
	// ROI associated to functionalities
	ROIFiberFile = ROIDir+GlobalName+"_ROI_F.zip";
	ROICentroFiberFile = ROIDir+GlobalName+"_ROI_CNF.zip";
	ROISatCellFiberFile = ROIDir+GlobalName+"_ROI_SC.zip";
	ROIVesselFiberFile = ROIDir+GlobalName+"_ROI_V.zip";
	
	ROISectionFile = ROIDir+GlobalName+"_SectionROI.zip";
	ROISatFile=ROIDir+GlobalName+"_ROI_SatCell.zip";
	ROIVessel=ROIDir+GlobalName+"_VesselROI.zip";
	VesselsFileName=arrivee+GlobalName+"_VesselDetails.txt";

	currentFile=depart+list[ik];
	newGlobalName="";
	if (FileFormat =="TIFF (16bits) by channel") {
		newGlobalName=GlobalName+"_c";
		LamininWindows=newGlobalName+ChannelFiber+"."+FullName[1];
	}

	if (FileFormat !="TIFF (16bits) by channel") {
		LamininWindows=newGlobalName+ChannelFiber;
	}
	else {
		LamininWindows=newGlobalName+ChannelFiber+"."+FullName[1];
	}

	filefound=false;
	SurfaceTotFibers=0;
	SurfaceTotSection=0;
	TableResume[nCurrentLine]="";

	
	if (checkAnalysis[0]) {
		if (FullName[1] =="czi") {
			run("Bio-Formats Importer", "open=currentFile autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT series_1");
			CurrentWindows=getTitle();
			Title = split(CurrentWindows,"=");
			newGlobalName=Title[0]+"=";
			LamininWindows=newGlobalName+ChannelFiber;
		}
		else
		if (FileFormat!="TIFF (16bits) by channel") {
			run("Bio-Formats Importer", "open=currentFile autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT");
			CurrentWindows=getTitle();
			Title = split(CurrentWindows,"=");
			newGlobalName=Title[0]+"=";
			LamininWindows=newGlobalName+ChannelFiber;
		}
		else {
			file1=depart+LamininWindows;
			run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
			run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
		}
		

		if (OneZ=="Z stack") {
			selectWindow(LamininWindows);
			run("Z Project...", "projection=[Max Intensity]");
			selectWindow(LamininWindows);
			run("Close");
			selectWindow("MAX_"+LamininWindows);
			rename(LamininWindows);
		}

		// Artefact detection on Laminin (First quality Check)
		bArtefacts=false;
		SurfaceTotSection=ArtefactDetectionOnLaminin(LamininWindows, bCrop, LimitDetectionFiberArea, bArtefacts);
		
		if (!bArtefacts) {
			// Fiber shape detection on Laminin
			SurfaceTotFibers=FiberShapeDetectionOnLaminin(LamininWindows,ROIFiberFile,ROICentroFiberFile,ROISatCellFiberFile,ROIVesselFiberFile,FiberArea,FiberFeret,MinFiberFeret,FiberAreaClassCount,nThreshold, bCrop);
	
			FibersAreaPercent=0;
			if (SurfaceTotFibers>0) {
				FibersAreaPercent= SurfaceTotFibers/SurfaceTotSection;
				FibersAreaPercent= 100*FibersAreaPercent;
				roiManager("reset");
				roiManager("Open", ROIFiberFile);
				roiManager("Show None");
				nbFibers = roiManager("count");
				FiberAreaMean = SurfaceTotFibers/nbFibers;
				for (k=0 ; k<nbFibers; k++) {
					TotFiberFeret=TotFiberFeret+FiberFeret[k];
				}
	
				nFeretMean = TotFiberFeret/nbFibers;
				if (ik==0) {
					TableResume[0]="FileName\tTotale Section Surface\tNb Segmented Fiber\tFiber Area Mean\tFiber Feret Mean\t<250 µm2\t250-500 µm2\t500-750 µm2\t750-1000 µm2\t1000-2000 µm2\t2000-3000 µm2\t3000-4000 µm2\t4000-5000 µm2\t5000-6000 µm2\t>6000 µm2";
					NameGlobalResult =NameGlobalResult+"_FM";
					NameLamininResult = NameLamininResult+"_FM";
				}
				TableResume[nCurrentLine]=GlobalName+"\t"+SurfaceTotSection+"\t"+nbFibers+"\t"+FiberAreaMean+"\t"+nFeretMean+"\t"+FiberAreaClassCount[0]+"\t"+FiberAreaClassCount[1]+"\t"+FiberAreaClassCount[2]+"\t"+FiberAreaClassCount[3]+"\t"+FiberAreaClassCount[4]+"\t"+FiberAreaClassCount[5]+"\t"+FiberAreaClassCount[6]+"\t"+FiberAreaClassCount[7]+"\t"+FiberAreaClassCount[8]+"\t"+FiberAreaClassCount[9];
	
				filefound=true;
			}
		}
		roiManager("reset");
		// Track artefacts (Check Quality)
		if (bArtefacts) {
			print("File: "+GlobalName+" FibersArea%: "+FibersAreaPercent+" ==>Section rejected (artefact in fiber channel)");
			selectWindow(LamininWindows);
			run("Enhance Contrast", "saturated=0.35");
			saveAs("Jpeg", ArtefactDir+NameLamininImage);
			filefound=false;
			run("Close All");
		}
		else {
			// Save Fiber Area cartography
			if (CartographyBox=="Fiber Area Classes") {
				FillFiberCartography(LamininWindows,ROIFiberFile,NameAreaImage,FiberArea,LegendBox);
				selectWindow(NameAreaImage);
				run("RGB Color");
				saveAs("Jpeg", CartoDir+NameAreaImage);
			}
		}
	}
	else {
		// check if ROI exist already
		for (j=0; j < listdone.length; j++)
		{
			filesearch=ROIDir+listdone[j];
			if (filesearch == ROIFiberFile) {
				run("Add to Manager");
				roiManager("Open", ROIFiberFile);
				roiManager("Show None");
				nbFibers = roiManager("count");
				if (FullName[1] =="czi") {
					run("Bio-Formats Importer", "open=currentFile autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT series_1");
					CurrentWindows=getTitle();
					Title = split(CurrentWindows,"=");
					newGlobalName=Title[0]+"=";
					LamininWindows=newGlobalName+ChannelFiber;
				}
				else
				if (FileFormat!="TIFF (16bits) by channel") {
					run("Bio-Formats Importer", "open=currentFile autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT");
					CurrentWindows=getTitle();
					Title = split(CurrentWindows,"=");
					newGlobalName=Title[0]+"=";
					LamininWindows=newGlobalName+ChannelFiber;
				}
				else {
					file1=depart+LamininWindows;
					run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
					run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
				}
				if (OneZ=="Z stack") {
					selectWindow(LamininWindows);
					run("Z Project...", "projection=[Max Intensity]");
					selectWindow(LamininWindows);
					run("Close");
					selectWindow("MAX_"+LamininWindows);
					rename(LamininWindows);
				}

				selectWindow("ROI Manager");

				for (k=0 ; k < roiManager("count"); k++) {
					roiManager("select", k);
	    			roiManager("Measure");
				}
				run("Select None");
				selectWindow("Results");
				for (k=0 ; k<nbFibers; k++) {
					FiberArea[k]=getResult("Area", k);
					AreaClassAttribution(FiberArea[k],FiberAreaClassCount);
					FiberFeret[k]=getResult("Feret", k);
					MinFiberFeret[k]=getResult("MinFeret", k);
					SurfaceTotFibers=SurfaceTotFibers+FiberArea[k];
					TotFiberFeret=TotFiberFeret+FiberFeret[k];
				}
				FiberAreaMean = SurfaceTotFibers/nbFibers;
				nFeretMean = TotFiberFeret/nbFibers;
				selectWindow("Results");
				run("Close");

				roiManager("reset");
				selectWindow("ROI Manager");
				run("Close");
				if (ik==0) {
					TableResume[0]="FileName\tNb Segmented Fiber\tFiber Area Mean\tFiber Feret Mean\t<250 µm2\t250-500 µm2\t500-750 µm2\t750-1000 µm2\t1000-2000 µm2\t2000-3000 µm2\t3000-4000 µm2\t4000-5000 µm2\t5000-6000 µm2\t>6000 µm2";
				}
				TableResume[nCurrentLine]=GlobalName+"\t"+nbFibers+"\t"+FiberAreaMean+"\t"+nFeretMean+"\t"+FiberAreaClassCount[0]+"\t"+FiberAreaClassCount[1]+"\t"+FiberAreaClassCount[2]+"\t"+FiberAreaClassCount[3]+"\t"+FiberAreaClassCount[4]+"\t"+FiberAreaClassCount[5]+"\t"+FiberAreaClassCount[6]+"\t"+FiberAreaClassCount[7]+"\t"+FiberAreaClassCount[8]+"\t"+FiberAreaClassCount[9];

				filefound=true;
				j=listdone.length;
				if (CartographyBox=="Fiber Area Classes") {
					FillFiberCartography(LamininWindows,ROIFiberFile,NameAreaImage,FiberArea,LegendBox);
					selectWindow(NameAreaImage);
					run("RGB Color");
					saveAs("Jpeg", CartoDir+NameAreaImage);
				}
			}
		}
	}
	if(!filefound) {
			print("fiber ROI file does not exist or is in artefact folder, file will be exclude from analysis batch");
	}
	else {

		// ON DAPI
		// FIRST OPTION: Analysis of centronuclei fibers
		// Nuclei Detection on DAPI
		if (checkAnalysis[2] || checkAnalysis[4])  {
			if (FileFormat !="TIFF (16bits) by channel") {
				DAPIWindows=newGlobalName+ChannelNuclei;
			}
			else {
				DAPIWindows=newGlobalName+ChannelNuclei+"."+FullName[1];
				file1=depart+DAPIWindows;
				run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(DAPIWindows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(DAPIWindows);
				run("Close");
				selectWindow("MAX_"+DAPIWindows);
				rename(DAPIWindows);
			}

			nbNuclei= NucleiDetectionOnDAPI(System,DAPIWindows);
		}
		if (checkAnalysis[2]) {
			if (nbNuclei <nbFibers)  {
				print("File: "+GlobalName+" nbTotNuclei: "+nbNuclei+" nbTotFibers: "+nbFibers+" ==>Section_rejected_(artefact_in_nuclei_channel)");
				selectWindow(DAPIWindows);
				saveAs("Jpeg", ArtefactDir+NameNucleiImage);
				close();
			}
			else {
				NbCentroNucleiCount= CentroNucleiFiberTracking(ROIFiberFile,ROICentroFiberFile,ROISatCellFiberFile,DAPIWindows,CentroNuclei, PeriNuclei);
				NameLamininResult = NameLamininResult+"_CNF";

				if (ik==0) {
					NameGlobalResult =NameGlobalResult+"_CNF";
					TableResume[0]=TableResume[0]+"\tNb CNF\tCNF Area Mean\t1CN\t1CN Area Mean\t2CN\t2CN Area Mean\t3+CN\t3+CN Area Mean";
				}
				if (NbCentroNucleiCount>0) {
					NbCentroNucleiClass1=NbCentroNucleiClass2=NbCentroNucleiClass3=0;
					CN1Area=CN2Area=CN3Area=0;
					for (i=0; i<nbFibers; i++) {
			     		if (CentroNuclei[i] == 1) {
	    					NbCentroNucleiClass1 = NbCentroNucleiClass1+1;
	    					CN1Area= CN1Area+FiberArea[i];
	    					CNFAreaMean=CNFAreaMean+FiberArea[i];
	    				}
	    				else
	 		     		if (CentroNuclei[i] == 2) {
	    					NbCentroNucleiClass2 = NbCentroNucleiClass2+1;
	    					CN2Area= CN2Area+FiberArea[i];
	    					CNFAreaMean=CNFAreaMean+FiberArea[i];
	    				}
	 		     		if (CentroNuclei[i] >= 3) {
	    					NbCentroNucleiClass3 = NbCentroNucleiClass3+1;
	    					CN3Area= CN3Area+FiberArea[i];
	    					CNFAreaMean=CNFAreaMean+FiberArea[i];
	    				}
	 				}
	 				if (NbCentroNucleiClass1 >0) {
	 					CN1Area/=NbCentroNucleiClass1;
	 				}
	 				if (NbCentroNucleiClass2 >0) {
	 					CN2Area/=NbCentroNucleiClass2;
	 				}
	 				if (NbCentroNucleiClass3 >0) {
	 					CN3Area/=NbCentroNucleiClass3;
	 				}
	 				CNFAreaMean/=NbCentroNucleiCount;
				}

				TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+NbCentroNucleiCount+"\t"+CNFAreaMean+"\t"+NbCentroNucleiClass1+"\t"+CN1Area+"\t"+NbCentroNucleiClass2+"\t"+CN2Area+"\t"+NbCentroNucleiClass3+"\t"+CN3Area;

				if (CartographyBox=="Centro Nuclei Classes") {
					FillCentroNucleiCartography(LamininWindows,ROICentroFiberFile,NameCentroImage,CentroNuclei,LegendBox);
					selectWindow(NameCentroImage);
					run("RGB Color");
					saveAs("Jpeg", CartoDir+NameCentroImage);
				}
			}
		}
		
		// SECOND OPTION: Analysis of satellite Cells
		if (checkAnalysis[4]) {
			if (FileFormat !="TIFF (16bits) by channel") {
				Pax7Windows=newGlobalName+ChannelSatCell;
			}
			else {
				Pax7Windows=newGlobalName+ChannelSatCell+"."+FullName[1];
				file2=depart+Pax7Windows;
				run("Bio-Formats Importer", "open=file2 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(Pax7Windows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(Pax7Windows);
				run("Close");
				selectWindow("MAX_"+Pax7Windows);
				rename(Pax7Windows);
			}
			
			nbRealSatCells=SatCellDetectionOnPax7(System,Pax7Windows,DAPIWindows,nThreshold);

			if (nbRealSatCells>0) {
				nbFiberWithSatCell=SatCellsTracking(ROIFiberFile,ROISatCellFiberFile,SatCells);
				if (CartographyBox=="Sat Cell") {
					FillSatCellCartography(LamininWindows,NameSatCellImage,SatCells,LegendBox);
					selectWindow(NameSatCellImage);
					run("RGB Color");
					saveAs("Jpeg", CartoDir+NameSatCellImage);
					run("Close");
				}
			}
			else {
				nbFiberWithSatCell=0;
			}
			NameLamininResult = NameLamininResult+"_SC";

			if (ik==0) {
				NameGlobalResult =NameGlobalResult+"_SC";
				TableResume[0]=TableResume[0]+"\tFibers with SatCells\tNb Sat Cells (Pax7+)";
			}
			TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbFiberWithSatCell+"\t"+nbRealSatCells;
			
		}
		// ON CD31
		// THIRD OPTION: Analysis of Vessels
		if (checkAnalysis[6]) {
			if (FileFormat !="TIFF (16bits) by channel") {
				VesselWindows=newGlobalName+ChannelVessel;
			}
			else {
				VesselWindows=newGlobalName+ChannelVessel+"."+FullName[1];
				file1=depart+VesselWindows;
				run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(VesselWindows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(VesselWindows);
				run("Close");
				selectWindow("MAX_"+VesselWindows);
				rename(VesselWindows);
			}
			
			nbVessels= VesselDetectionOnCD31(System,VesselWindows,ROIVessel,VascularisationCriteria,VesselsFileName);

			// Criteria 1: TotVesselSurface Criteria 2: NbTotVessels
			if (checkAnalysis[0]) {
				PercentVascularisation= 100*VascularisationCriteria[0]/SurfaceTotSection;
				Vascularisation_bymm2= 1000000*VascularisationCriteria[1]/SurfaceTotSection;
			}
			
			nFiberswithVessels=VesselTracking(ROIVesselFiberFile,VesselWindows,Vessels);
			NameLamininResult = NameLamininResult+"_V";

			if (ik==0) {
				NameGlobalResult=NameGlobalResult+"_V";
				TableResume[0]=TableResume[0]+"\tTot Vessels\tFibers with Vessels\tVascularisation surface(%)\t Vessels by mm2";
			}
			if (checkAnalysis[0]) {
				TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbVessels+"\t"+nFiberswithVessels+"\t"+PercentVascularisation+"\t"+Vascularisation_bymm2;
			}
			else {
				TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbVessels+"\t"+nFiberswithVessels+"\t"+"NaN"+"\t"+"NaN";
			}

			if (CartographyBox=="Vessels") {
				FillVesselsCartography(LamininWindows,NameVesselsImage,Vessels,LegendBox);
				selectWindow(NameVesselsImage);
				run("RGB Color");
				saveAs("Jpeg", CartoDir+NameVesselsImage);
				close();
			}
		}
		// FOURTH OPTION: Analysis of fiber types
		roiManager("reset");
		// Type 1
		if (checkAnalysis[1]) {
			if (FileFormat !="TIFF (16bits) by channel") {
				Type1Windows=newGlobalName+ChannelType1;
			}
			else {
				Type1Windows=newGlobalName+ChannelType1+"."+FullName[1];
				file1=depart+Type1Windows;
				run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(Type1Windows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(Type1Windows);
				run("Close");
				selectWindow("MAX_"+Type1Windows);
				rename(Type1Windows);
			}

			nbFiberType1=FiberTypeDetection(ROIFiberFile,Type1Windows,FiberType1,FiberPhenoType1,1,nThreshold);
			NameLamininResult = NameLamininResult+"_T1";
			if (ik==0) {
				NameGlobalResult=NameGlobalResult+"_T1";
			}
			selectWindow(Type1Windows);
			close();

		}
		// Type 2A
		if (checkAnalysis[3]) {
			if (FileFormat !="TIFF (16bits) by channel") {
				Type2AWindows=newGlobalName+ChannelType2A;
			}
			else {
				Type2AWindows=newGlobalName+ChannelType2A+"."+FullName[1];
				file1=depart+Type2AWindows;
				run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(Type2AWindows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(Type2AWindows);
				run("Close");
				selectWindow("MAX_"+Type2AWindows);
				rename(Type2AWindows);
			}
			
			nbFiberType2a=FiberTypeDetection(ROIFiberFile,Type2AWindows,FiberType2a,FiberPhenoType2a,3,nThreshold);
			NameLamininResult = NameLamininResult+"_T2A";
			if (ik==0) {
				NameGlobalResult=NameGlobalResult+"_T2A";
			}
			
			selectWindow(Type2AWindows);
			close();
		}
		// Type 2B
		if (checkAnalysis[5]) {
			if (FileFormat !="TIFF (16bits) by channel") {
				Type2BWindows=newGlobalName+ChannelType2B;
			}
			else {
				Type2BWindows=newGlobalName+ChannelType2B+"."+FullName[1];
				file1=depart+Type2BWindows;
				run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(Type2BWindows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(Type2BWindows);
				run("Close");
				selectWindow("MAX_"+Type2BWindows);
				rename(Type2BWindows);
			}

			nbFiberType2b=FiberTypeDetection(ROIFiberFile,Type2BWindows,FiberType2b,FiberPhenoType2b,5,nThreshold);
			NameLamininResult = NameLamininResult+"_T2B";
			if (ik==0) {
				NameGlobalResult=NameGlobalResult+"_T2B";
			}
			
			selectWindow(Type2BWindows);
			close();
		}
		// Intensity only
		if (checkAnalysis[7]) {
			if (FileFormat !="TIFF (16bits) by channel") {
				IntensityWindows=newGlobalName+ChannelIntensity;
			}
			else {
				IntensityWindows=newGlobalName+ChannelIntensity+"."+FullName[1];
				file1=depart+IntensityWindows;
				run("Bio-Formats Importer", "open=file1 autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
				run("Properties...", "channels=1 slices=1 frames=1 unit=micron pixel_width=XResol pixel_height=YResol voxel_depth=1.0000000 global");
			}
			if (OneZ=="Z stack") {
				selectWindow(IntensityWindows);
				run("Z Project...", "projection=[Max Intensity]");
				selectWindow(IntensityWindows);
				run("Close");
				selectWindow("MAX_"+IntensityWindows);
				rename(IntensityWindows);
			}

			FiberIntensityDetection(ROIFiberFile,IntensityWindows,Intensity);
			selectWindow(list[ik+ChannelIntensity]);
			getStatistics(area, mean, min, max, std, histogram);
			nThreshold[7]=mean;
			close();
		}

		roiManager("reset");
		selectWindow(LamininWindows);
		roiManager("Open", ROIFiberFile);
		roiManager("Show None");
	    roiManager("select", 0);
	    roiManager("Measure");
		selectWindow("Results");
		run("Clear Results");
		roiManager("reset");	

		// Fill table by fiber
		for (j=0; j<nbFibers; j++) {
			setResult("Area", j, FiberArea[j]);
			setResult("Max Feret", j, FiberFeret[j]);
			setResult("Min Feret", j, MinFiberFeret[j]);
			if (checkAnalysis[2]) {
				setResult("CentroNuclei", j, CentroNuclei[j]);
				setResult("PeriNuclei", j, PeriNuclei[j]);
			}
			if (checkAnalysis[4]) {
				setResult("Sat. Cells", j, SatCells[j]);
			}
			if ((checkAnalysis[1]) || (checkAnalysis[3]) || (checkAnalysis[5]))  {
				if ((FiberPhenoType1[j] ==1) && (FiberPhenoType2a[j]==0) && (FiberPhenoType2b[j]==0)) {
						setResult("Fiber PhenoType", j, "I");
				}
				if ((FiberPhenoType1[j] ==0) && (FiberPhenoType2a[j]==1) && (FiberPhenoType2b[j]==0)) {
						setResult("Fiber PhenoType", j, "IIA");
				}
				if ((FiberPhenoType1[j] ==0) && (FiberPhenoType2a[j]==0) && (FiberPhenoType2b[j]==1)) {
						setResult("Fiber PhenoType", j, "IIB");
				}
				if ((FiberPhenoType1[j] ==1) && (FiberPhenoType2a[j]==1) && (FiberPhenoType2b[j]==0)) {
					nbFiberType1 = nbFiberType1-1;
					nbFiberType2a = nbFiberType2a-1;
					nbFiberArtefactHyb1=nbFiberArtefactHyb1+1;
					setResult("Fiber PhenoType", j, "I-IIA");
				}
				if ((FiberPhenoType1[j] ==1) && (FiberPhenoType2a[j]==0) && (FiberPhenoType2b[j]>0)) {
					setResult("Fiber PhenoType", j, "I-IIB");
					nbFiberType1 = nbFiberType1-1;
					nbFiberType2b = nbFiberType2b-1;
					nbFiberArtefactHyb2=nbFiberArtefactHyb2+1;
				}
				if ((FiberPhenoType1[j] ==0) && (FiberPhenoType2a[j]==1) && (FiberPhenoType2b[j]>0)) {
					setResult("Fiber PhenoType", j, "IIA-IIB");
					nbFiberType2a = nbFiberType2a-1;
					nbFiberType2b = nbFiberType2b-1;
					nbFiberArtefactHyb3=nbFiberArtefactHyb3+1;
				}
				if ((FiberPhenoType1[j] ==1) && (FiberPhenoType2a[j]==1) && (FiberPhenoType2b[j]>0)) {
					setResult("Fiber PhenoType", j, "NC");
					nbFiberType1 = nbFiberType1-1;
					nbFiberType2a = nbFiberType2a-1;
					nbFiberType2b = nbFiberType2b-1;
					nbFiberArtefact=nbFiberArtefact+1;
				}
				if ((FiberPhenoType1[j] ==0) && (FiberPhenoType2a[j] ==0) && (FiberPhenoType2b[j] ==0)) {
					FiberPhenoType2x[j]=1;
					setResult("Fiber PhenoType", j, "IIX");
					nbFiberType2x++;
				}
				if ((FiberPhenoType1[j] ==0) && (FiberPhenoType2a[j]==0) &&(FiberPhenoType2b[j] == 2)) {
					setResult("Fiber PhenoType", j, "IIb");
					nbFiberType2b = nbFiberType2b-1;
					nbFiberType2b_Ambig=nbFiberType2b_Ambig+1;
				}
			}
			if (checkAnalysis[6]) {
				setResult("Vessels", j, Vessels[j]);
			}
			if (checkAnalysis[7]) {
				setResult("Intensity", j, Intensity[j]);
				IntensityMean=IntensityMean+ Intensity[j];
			}
			
		}
		if ((checkAnalysis[1]) || (checkAnalysis[3]) || (checkAnalysis[5]))  {
			if (ik==0) {
				TableResume[0]=TableResume[0]+"\tFiber TypeI\tTypeI Threshold";
				TableResume[0]=TableResume[0]+"\tFiber TypeIIA\tTypeIIA Threshold";
				TableResume[0]=TableResume[0]+"\tFiber TypeIIB\tTypeIIB Threshold\tFiber TypeIIb(low signal)\tTypeIIb Threshold\t";
				TableResume[0]=TableResume[0]+"\tFiber TypeIIX\tI-IIA\tI-IIB\tIIA-IIB\tNot Def.";
			}
			TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbFiberType1+"\t"+nThreshold[1];
			TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbFiberType2a+"\t"+nThreshold[3];
			TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbFiberType2b+"\t"+nThreshold[5]+"\t"+nbFiberType2b_Ambig+"\t"+nThreshold[6];
			TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+nbFiberType2x+"\t"+nbFiberArtefactHyb1+"\t"+nbFiberArtefactHyb2+"\t"+nbFiberArtefactHyb3+"\t"+nbFiberArtefact;
		}
		
		if (CartographyBox=="Fiber Types") {
			selectWindow(LamininWindows);
			rename(NameTypeImage);
			selectWindow(NameTypeImage);
			run("RGB Color");
			roiManager("Open", ROIFiberFile);
			TypeCartographyFill(NameTypeImage,FiberPhenoType1,FiberPhenoType2a,FiberPhenoType2b,FiberPhenoType2x,LegendBox);
			selectWindow(NameTypeImage);
			run("RGB Color");
			saveAs("Jpeg", CartoDir+NameTypeImage);
			close();
		}

		IntensityMean = IntensityMean/nbFibers;
		if (checkAnalysis[7]) {
			NameLamininResult = NameLamininResult+"_Int";
			

			if (ik==0) {
				NameGlobalResult = NameGlobalResult+"_Int";
				TableResume[0]=TableResume[0]+"\tFiber Intensity Mean";
			}
			TableResume[nCurrentLine]=TableResume[nCurrentLine]+"\t"+IntensityMean;
		}

		selectWindow("Results");
		NameLamininResult = NameLamininResult+".txt";
		
		saveAs("Text", ResultDir+NameLamininResult);
		//run("Close");

		run("Clear Results");
		labels = split(TableResume[0], "\t");
        items=split(TableResume[nCurrentLine], "\t");
	    for (j=0; j<items.length; j++)
	       setResult(labels[j], 0, items[j]);

		updateResults();
		selectWindow("Results");
		saveAs("Text", ResultDir+GlobalName+"_"+NameGlobalResult+"_Temp.txt");
		run("Close");

		nCurrentLine=nCurrentLine+1;
	}
	run("Close All");
}
file=depart+list[0];
run("Bio-Formats Importer", "open=file autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
getStatistics(area, mean, min, max, std, histogram);
labels = split(TableResume[0], "\t");
for (i=1; i<nCurrentLine; i++) {
      items=split(TableResume[i], "\t");
      for (j=0; j<labels.length; j++)
         setResult(labels[j], i-1, items[j]);
}
updateResults();
selectWindow("Results");
saveAs("Text", arrivee+NameGlobalResult+".txt");
run("Close All");
