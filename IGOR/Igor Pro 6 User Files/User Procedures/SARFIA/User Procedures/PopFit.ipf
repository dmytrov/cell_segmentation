#pragma rtGlobals=1		// Use modern global access method.

Function/wave PopFit_line(Pop,start,stop)

	Wave Pop
	variable start, stop		//scaled variables
	
	variable startP, stopP, ii, nTraces
	String WNote, Buffer
	
	nTraces = dimSize(Pop, 1)
	
	Make/o/n=(ntraces,2) PopCoef_line
	
	
	WNote=Note(Pop)
	buffer=StringByKey("LabelList",WNote,"=","\r")
	
	if(StrLen(Buffer))		//checking if PopWave is an ExpDB
	
		For(ii=0;ii<nTraces;ii+=1)
			
			Wave trace = TraceFromDB(Pop,ii)
			startP=(start - DimOffset(trace,0))/DimDelta(trace,0)
			stopP=(stop - DimOffset(trace,0))/DimDelta(trace,0)
	
			CurveFit /m=0/N/Nthr=0/q line trace[startP,StopP]
			Wave w_Coef
			
			PopCoef_line[ii][] =w_coef[q] 
	
			KillWaves Trace
		EndFor
		
	else					//normal PopWave
		startP=(start - DimOffset(pop,0))/DimDelta(pop,0)
		stopP=(stop - DimOffset(pop,0))/DimDelta(pop,0)
	
		For(ii=0;ii<nTraces;ii+=1)
			CurveFit /m=0/N/Nthr=0/q line pop[startP,StopP][ii]
			Wave w_Coef
			
			PopCoef_Line[][ii] =w_coef[p] 
		endFor
	
	endif
	

	return  PopCoef_line
End

////////////////////////////////////////////////////

Function/wave PopFit_Exp(Pop,start,stop)

	Wave Pop
	variable start, stop		//scaled variables
	
	variable startP, stopP, ii, nTraces
	String WNote, Buffer
	
	nTraces = dimSize(Pop, 1)
	
	Make/o/n=(ntraces,3) PopCoef_SE
	
	
	WNote=Note(Pop)
	buffer=StringByKey("LabelList",WNote,"=","\r")
	
	if(StrLen(Buffer))		//checking if PopWave is an ExpDB
	
		For(ii=0;ii<nTraces;ii+=1)
			
			Wave trace = TraceFromDB(Pop,ii)
			startP=(start - DimOffset(trace,0))/DimDelta(trace,0)
			stopP=(stop - DimOffset(trace,0))/DimDelta(trace,0)
	
			CurveFit /m=0/N/Nthr=0/q exp_XOffset trace[startP,StopP]
			Wave w_Coef
			
			PopCoef_SE[ii][] =w_coef[q] 
	
			KillWaves Trace
		EndFor
		
	else					//normal PopWave
		startP=(start - DimOffset(pop,0))/DimDelta(pop,0)
		stopP=(stop - DimOffset(pop,0))/DimDelta(pop,0)
	
		For(ii=0;ii<nTraces;ii+=1)
			CurveFit /m=0/N/Nthr=0/q exp_XOffset pop[startP,StopP][ii]
			Wave w_Coef
			
			PopCoef_SE[][ii] =w_coef[p] 
		endFor
	
	endif
	

	return  PopCoef_SE
End