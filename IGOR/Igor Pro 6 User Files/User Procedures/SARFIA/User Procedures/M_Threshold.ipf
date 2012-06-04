#pragma rtGlobals=1		// Use modern global access method.
#include "MultiROI"

Function M_Threshold(inputwave, outputwave, levels)
Wave inputwave
String Outputwave
variable levels

variable xdim, ydim, xcount = 0, ycount = 0
If (DimSize(inputwave, 2))
	Print "Running thresholding on a stack"
	Print "Only First Layer will be affected"
endif


xdim = dimsize(inputwave, 0)
ydim = dimsize(inputwave, 1)

duplicate /o/r=[][] inputwave, calcwave
//make /o/n=(xdim,ydim) calcwave



wavestats /q /m=2 inputwave
FastOP calcwave = 1



xcount = 0
do
	ycount = 0
	do
	
	//calcwave[xcount][ycount] = trunc((inputwave[xcount][ycount] - minval) *levels / range)
	if (inputwave[xcount][ycount] > (v_max-levels*v_sdev))
			calcwave[xcount][ycount] = 0
		endif
	
	ycount +=1
	while (ycount < ydim)
xcount +=1
while (xcount < xdim)


//make /o/n=(xdim,ydim) $outputwave = calcwave
duplicate /o calcwave, $outputwave
killwaves /z calcwave

end

////////////////////thres 2 roi//////////////////


function thresh2roi(inputwave, outputwave)
Wave inputwave
String Outputwave


variable xdim, ydim, xcount = 0, ycount = 0

If (DimSize(inputwave, 2))
	Print "Running thresholding on a stack"
	Print "Only First Layer will be affected"
endif

xdim = dimsize(inputwave, 0)
ydim = dimsize(inputwave, 1)

duplicate /o inputwave, calcwave



do
	ycount = 0
	do
	
	if(inputwave[xcount][ycount])
	calcwave[xcount][ycount] = 0 //zero ROI pixels
	else
	calcwave[xcount][ycount] = 1
	endif
	
	ycount +=1
	while (ycount < ydim)
xcount +=1
while (xcount < xdim)


duplicate /o calcwave, $outputwave
killwaves /z calcwave
end




///////////////////////////////////////////////////////////////////////////

Function M_Threshold4(sourcewave, targetwave, start, detect)
wave sourcewave
string targetwave
variable start, detect

variable xdim, ydim, xcount = 0, ycount = 0, roicount = 0, x2, y2, condition, minx, condition2, maxx, type, pixelnumber = 0
variable x3,y3, pxtrack, threshold, roinumber, dlimit
string info

info =waveinfo(sourcewave, 0)
type =  NumberByKey("NUMTYPE", info)


xdim = dimsize(sourcewave, 0)
ydim = dimsize(sourcewave, 1)
make /o/n=(xdim*ydim,2) pointstore

duplicate /o sourcewave, mtcalcwave
if (type > 5)
	redimension /d mtcalcwave
endif
FastOP mtcalcwave = 2

WaveStats /Q/M=2 sourcewave

threshold = V_max-v_sdev*start


ycount = 0
do	//ycount
xcount = 0
	do //xcount
	pixelnumber = 0
		if (sourcewave[xcount][ycount] > threshold)
		
			mtcalcwave[xcount][ycount]= 0
		
		endif

xcount +=1
	while(xcount<xdim)
ycount +=1
while (ycount<ydim)

roinumber = multiroi(mtcalcwave,"mrROIwave")
wave mrROIwave

FastOP mtCalcWave = 1

roicount = 1
do //roicount
	duplicate /o mrROIwave, buROIwave
	buROIwave += ROIcount
	redimension /b/u buROIwave

	imagestats /m=1 /R=buROIwave sourcewave
	x3= v_maxRowLoc
	y3=v_maxColLoc
	dlimit = v_max * detect

			pixelnumber =1
			pxtrack = 0
			mtcalcwave[x3][y3]= -roicount
			pointstore[pixelnumber - 1][0] = xcount
			pointstore[pixelnumber - 1][1] = ycount

			
			do //pxtrack
				x2 = -1
				y2 = -1
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = 0
				y2 = -1
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = 1
				y2 = -1
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = -1
				y2 = 0
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = 1
				y2 = 0
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = -1
				y2 = 1
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = 0
				y2 = 1
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				x2 = 1
				y2 = 1
				if ((sourcewave[x3+x2][y3+y2] > dlimit) && (mtcalcwave[x3+x2][y3+y2]==1))
					pixelnumber +=1
					mtcalcwave[x3+x2][y3+y2]= -roicount
					pointstore[pixelnumber - 1][0] = x3+x2
					pointstore[pixelnumber - 1][1] = y3+y2
				endif
				
				
			pxtrack +=1
			x3 = pointstore[pxtrack][0]
			y3 = pointstore[pxtrack][1]
			while(pxtrack <= pixelnumber)
			

roicount+=1
while(roicount<=roinumber)




duplicate /o mtcalcwave, $targetwave
killwaves /z mtcalcwave, pointstore ,  mrROIwave, buROIwave
return ROIcount
end