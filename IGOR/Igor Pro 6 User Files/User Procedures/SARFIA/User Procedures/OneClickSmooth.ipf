#pragma rtGlobals=1		// Use modern global access method.
#include "SaveTiff"
#include "EqualizeScaling"

Function OCS()

string topwave,twname

Twname=WinName(0,1,1)

if(stringmatch(TWname,""))
	topwave=""
else

	GetWindow $TWname, wavelist
	wave /t w_wavelist

	topwave = w_wavelist[0][0]
endif


Filter2($topWave)

string newname=topWave+"_fil"

Display/k=1
AppendImage $newName
DoUpDate
WMAppend3DImageSlider(); DoUpdate
SizeImage(300)

end

/////////////////////////////////////

Function Filter2(image)
	wave image
	Variable Filtering3D=0
	
	
	if ((wavedims(image) < 2) | (wavedims(image) > 3)) 
		String AbortStr=Nameofwave(image)+" is not an image/stack."
		Abort AbortStr
	endif
	
	duplicate /o/free image, f_image
	
	string method
	
	string methods = "Average;Gauss;Hybridmedian;Max;Median;Min;Point;PCA"
	variable eN = 3, ii, zDim
	
	zDim=DimSize(image,2)
	
	//prompt topwave, "Image", popup, WaveList("*",";","")
	prompt method, "Method",popup, methods
	prompt eN, "Filter Size/Number of Principal Components"
	prompt Filtering3D, "Filter in z-axis (0/1)?"
	
	doPrompt /help="ImageFilter" "Filter parameters for "+nameofwave(image), method,eN, Filtering3D
	
	if(v_flag)
		Abort
	endif
	
	if(wavedims(image) == 3 && Filtering3D >0)
	
		strswitch(method)
			case "average":
				imagefilter /n=(eN) /o avg3d f_image
			break
			
			case "Gauss":
				imagefilter /n=(eN) /o gauss3d f_image
			break
			
			case "Hybridmedian":
				imagefilter /o hybridmedian f_image
			break
			
			case "Max":
				imagefilter /n=(eN) /o max3d f_image
			break
			
			case "Median":
				imagefilter /n=(eN) /o median3d f_image
			break
			
			case "Min":
				imagefilter /n=(eN) /o min3d f_image
			break
			
			case "Point":
				imagefilter /n=(eN) /o point3d f_image
			break
			
			case "PCA":
				 Wave PCA_res=SmoothByPCA(f_image, eN)
				 Fastop f_image=PCA_res
				Killwaves/z PCA_res, m_r, m_c, wv2dx
			break
			
		endswitch
		
	elseif(wavedims(image) == 3 && Filtering3D <=0)
	
	strswitch(method)
			case "average":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o avg f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "Gauss":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o gauss f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "Hybridmedian":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o hybridmedian f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "Max":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o max f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "Median":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o median f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "Min":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o min f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "Point":
				For(ii=0;ii<zDim;ii+=1)
					Duplicate/o/free/r=[][][ii] image f_slice
					imagefilter /n=(eN) /o point f_slice
					f_image[][][ii]=f_slice[p][q]
				EndFor
			break
			
			case "PCA":
				 Wave PCA_res=SmoothByPCA(f_image, eN)
				 MultiThread f_image=PCA_res
				 Killwaves/z PCA_res, m_r, m_c, wv2dx
			break
			
		endswitch
		
		
		
		
	Elseif(wavedims(image) == 2)
	
		strswitch(method)
			case "average":
				imagefilter /n=(eN) /o avg f_image
			break
			
			case "Gauss":
				imagefilter /n=(eN) /o gauss f_image
			break
			
			case "Hybridmedian":
				imagefilter /o FindEdges f_image
			break
			
			case "Max":
				imagefilter /n=(eN) /o max f_image
			break
			
			case "Median":
				imagefilter /n=(eN) /o median f_image
			break
			
			case "Min":
				imagefilter /n=(eN) /o min f_image
			break
			
			case "Point":
				imagefilter /n=(eN) /o point f_image
			break
			
			case "PCA":
				Abort "PCA works only with stacks"
			break
			
		endswitch
	
	
	Else
		abort "This Wave doesn't seem to be an image"
	endif
	
	string newname=nameofwave(image)+"_fil"
	
	duplicate /o f_image, $(newname)
	wave w=$(newname)

return 1
end

//////////////////////////Smoothing by PCA//////////////////////////////////

Function/wave Make2Dx(wv)		//convert 3D to 2D
	Wave wv
	
	Variable xd, yd, zd, ii, arow, acol
	
	xd = dimsize(wv,0)
	yd = DimSize(wv,1)
	zd = DimSize(wv,2)
	
	Make /o/n=(zd,xd*yd) wv2Dx
	
	
	for(ii=0;ii<xd*yd;ii+=1)
	
		arow = mod(ii,xd)
		acol = floor(ii/xd)
		
		Matrixop/o/free Beams = Beam(wv,arow,acol)
	
		wv2dx[][ii] = Beams[p]
		
	endfor
	
	setscale/p x,DimOffSet(wv,2),DimDelta(wv,2),WaveUnits(wv,2) wv2dx
	
	return wv2dx
end

///////////////////////////////////////////

Function/wave Make3Dx(wv,xd,yd)		//reverse Make2Dx
	Wave wv
	Variable xd, yd
	
	Variable ii, zd, arow, acol, npts
	
	
	zd=dimsize(wv,0)
	npts = xd*yd
	
	if(DimSize(wv,1) !=  npts)
		Abort "Mismatch"
	endif	
	
	Make /o/n=(xd,yd,zd) wv3D = NaN
	
	for(ii=0;ii<yd;ii+=1)
	
		arow = mod(ii,yd)
		acol = trunc(ii/xd)
	
		wv3d[][ii][] = wv[r][p+ii*(xd)]
	
	
	endfor

	
	return wv3d		//unscaled
end

/////////////////////////////////////////

Function/wave SmoothByPCA(wv, PC)
	Wave wv
	variable PC 		//number of principal components to leave
	
	Variable xdim, ydim
	

	xdim = dimsize(wv,0)
	ydim = dimsize(wv,1)

	Wave wv2d = Make2Dx(wv)

	pca /q/scmt/srmt/leiv wv2d
	

	
	wave M_R, M_C
	
	Duplicate/o/free M_R MRMod
	
	MRMod = 0
	MRMod[][0,PC-1] = M_R
	
	MatrixOP/o/free smooth2D=MRMod x M_C
	
	Wave Smoothed = Make3Dx(smooth2D,xdim,ydim)
	
	CopyScaling(wv,smoothed)
	
	return smoothed


End