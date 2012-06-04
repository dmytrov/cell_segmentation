#pragma rtGlobals=1		// Use modern global access method.



Function/wave ParticlesPerFrame(ImageStack,[ResultName])
	Wave ImageStack
	string ResultName
	
	
	if(ParamIsDefault(ResultName))
		ResultName=NameOfWave(ImageStack)+"_PC"
	endif
	
	Variable zDim, ii

	zDim = DimSize(ImageStack,2)
	
	Make/o/n=(zDim)/free w_PC
	SetScale /p x,DimOffset(ImageStack,2), DimDelta(ImageStack,2),WaveUnits(ImageStack,2) w_PC
	Duplicate/o/free ImageStack CalcStack
	
	CalcStack=SelectNumber(ImageStack[p][q][r]>=0,ImageStack[p][q][r],NaN)//	Replace >=0 with NaN
	
	For(ii=0;ii<zDim;ii+=1)
		
		imagestats/P=(ii)/m=1 CalcStack
		
		w_PC[ii] = abs(v_max-v_min)

	EndFor

	Duplicate/o w_PC, $ResultName
	return $ResultName
End