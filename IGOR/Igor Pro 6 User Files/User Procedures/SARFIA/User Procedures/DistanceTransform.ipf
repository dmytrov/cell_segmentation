#pragma rtGlobals=1		// Use modern global access method.


/////////////////////////////////////////////////////////////////////////////////////////
// These functions calculate a distance transform of a 2D or 3D binary wave. The output can be Euclidean 	//
// distances in pixels, Manhattan distances in pixels or scaled Euclidean distances.						//
//																										//
// Note: These functions use a very slow algorithm. Although the functions are multithreaded, processing 	//
// large waves will take a very, very long time. Processing speed can be increased by calculating the 		//
// distance transform of a pixelated wave and then resampling the result, using the ImageInterpolate 		//
// function with the pixelate and resample keywords, respectively.  										//
//																										//
// DistanceTransform (image,metric) Calculates the distance transform of the 2D or 3D wave image, 		//
// which must be binary, i.e. contain only 0 and 1. Metric can be 0 (Euclidean distances in pixels), 		//
// 1 (Manhattan distances in pixels), or 2 (scaled Euclidean distances). Scaling does work, even if pixels 	//
//  are not quadratic (or cubic).																			//
/////////////////////////////////////////////////////////////////////////////////////////





Function DistanceTransform(image,metric)
	Wave image	//must be binary, i.e. only values of 0 and 1
	Variable Metric //0=Euclidean (pixel-based), 1=Manhattan, 2=Euclidean (scaled)
	
	Variable WD = WaveDims(image), wmin, wmax
	
	wmin=WaveMin(image)
	wmax=WaveMax(image)
	
	if(wmin != 0 || wmax != 1)
		printf "%s is not a binary wave\r",NameOfWave(image)
		return 1
	endif
	
	Switch (WD)
		Case 0:
			Return 1
		Break
	
		Case 1:
			Return 1
		Break
		
		Case 2:
			DistanceTransform2D(image,metric)
		Break
		
		Case 3:
			DistanceTransform3D(image,metric)
		Break
		
		Case 4:
			Print "Not yet implemented"
			Return 1
		Break
	
	
	EndSwitch
	
	Return 0
End



///////////////////////////////////////////////////////////////////////////////////

	
Static Function DistanceTransform2D(image,metric)					//calculates distance transform of binary image image
	Wave image	//must be binary, i.e. only values of 0 and 1
	Variable Metric //0=Euclidean (pixel-based), 1=Manhattan, 2=Euclidean (scaled)
	
	variable xDim, yDim, ii, xLoc, yLoc, xDelta, yDelta
	string resultname = NameOfWave(image) + "_DT"		//name of resulting wave
	
	xDim=DimSize(image,0)
	yDim=DimSize(image,1)
	xDelta = DimDelta(image,0)
	yDelta = DimDelta(image,1)
	
	Duplicate/o/free image, calc, DM
	Duplicate/o image,$resultname
	Wave DT=$resultname					//Distance Transform
	redimension/s DT
	MatrixOP/o calc = image / image			//Make 0 to NaN
	
	Make/o/free/n=(2*xDim+1,2*yDim+1) DMcent		//centered distance map to serve as a master
	
	//Calculate distances of centered distance map
	Switch(metric)
		Case 0:	//Euclidean
			MultiThread DMcent=sqrt((p-xDim)^2+(q-yDim)^2)
		break	
		
		Case 1://Manhattan
			MultiThread DMcent=(abs(p-xDim)+abs(q-yDim))
		break		
		
		Case 2:	//scaled Euclidean
			MultiThread DMcent=sqrt(((p-xDim)*xDelta)^2+((q-yDim)*yDelta)^2)
		break
			
		Default:		//Euclidean
			Print "Using Euclidean metric."
			MultiThread DMcent=sqrt((p-xDim)^2+(q-yDim)^2)
		Break
		
	EndSwitch
	
	MultiThread DT=distAssign(p,q,xdim,ydim,image,DMcent,calc)
	return 0
End


ThreadSafe Static function distAssign(ii,jj,xdim,ydim,image,DMcent,calc)
	Variable ii,jj,xdim,ydim
	Wave image,DMcent,calc
	
	if(image[ii][jj])	
		return 0
	endif
	
	Duplicate/o/free/r=[xDim-ii,2*(xDim)-ii-1][yDim-jj,2*(yDim)-jj-1] DMcent DM	
	MatrixOP/o/free DM2=DM*calc		
	return WaveMin(DM2)	 
End



///////////////////////////////////////////////////////////////////////////////////

Static Function DistanceTransform3D(image,metric)					//calculates distance transform of binary volume image
	Wave image	//must be binary, i.e. only values of 0 and 1
	Variable Metric //0=Euclidean (pixel-based), 1=Manhattan, 2=Euclidean (scaled)
	
	variable xDim, yDim, zDim,ii, xLoc, yLoc, xDelta, yDelta, zDelta
	string resultname = NameOfWave(image) + "_DT"		//name of resulting wave
	
	xDim=DimSize(image,0)
	yDim=DimSize(image,1)
	zdim=DimSize(image,2)
	xDelta = DimDelta(image,0)
	yDelta = DimDelta(image,1)
	zDelta=DimDelta(image,2)
	
	Duplicate/o/free image, calc, DM
	Duplicate/o image,$resultname
	Wave DT=$resultname					//Distance Transform
	redimension/s DT
	MatrixOP/o calc = image / image			//Make 0 to NaN
	
	Make/o/free/n=(2*xDim+1,2*yDim+1,2*zDim+1) DMcent		//centered distance map to serve as a master
	
	//Calculate distances of centered distance map
	Switch(metric)
		Case 0:	//3D Euclidean
			MultiThread DMcent=sqrt((p-xDim)^2+(q-yDim)^2+(r-zDim)^2)
		break	
		
		Case 1://3D Manhattan
			MultiThread DMcent=(abs(p-xDim)+abs(q-yDim)+abs(r-zDim))	
		break		
		
		Case 2:	//3D scaled Euclidean	
			MultiThread DMcent=sqrt(((p-xDim)*xDelta)^2+((q-yDim)*yDelta)^2+((r-zDim)*zDelta)^2)
		break
		
		Default:		//3D Euclidean
			Print "Using Euclidean metric."
			MultiThread DMcent=sqrt((p-xDim)^2+(q-yDim)^2+(r-zDim)^2)
		Break
		
	EndSwitch
	
	MultiThread DT=distAssign3D(p,q,r,xdim,ydim,zDim,image,DMcent,calc)
	return 0
End


ThreadSafe Static function distAssign3D(ii,jj,kk,xdim,ydim,zDim,image,DMcent,calc)
	Variable ii,jj,kk,xdim,ydim,zDim
	Wave image,DMcent,calc
	
	if(image[ii][jj][kk])	
		return 0
	endif
	
	Duplicate/o/free/r=[xDim-ii,2*(xDim)-ii-1][yDim-jj,2*(yDim)-jj-1][zDim-kk,2*(zDim)-kk-1] DMcent DM	
	MatrixOP/o/free DM2=DM*calc		
	return WaveMin(DM2)	 
End



///////////////////////////////////////////////////////////////////////////////////

