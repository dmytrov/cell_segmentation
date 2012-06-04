#pragma rtGlobals=1		// Use modern global access method.


Function FitPop(pop, reject, [targetname])

wave pop, reject
string targetname

if(paramisdefault(targetname))
	targetname=nameofwave(pop) + "_Coefs"
endif

duplicate /o pop, calc_sbpop, calc_fits
make /o /n=(dimsize(pop,0)) fit_result
setscale /p x,dimoffset(pop,0),dimdelta(pop,0),waveunits(pop,0) fit_result
setscale /p y,0,1,waveunits(pop,-1) fit_result
duplicate/o fit_result, ToBeFitted


variable numtraces=dimsize(pop,1)

make /o/n=(numtraces,3) PopCoef=0
make /o/n=(numtraces) PopFitConstants
duplicate/o pop, Fits
fastop fits=0

variable ii,jj
make /o/n=3 w_coef, w_fitconstants

For(ii=0;ii<numpnts(reject);ii+=2)
		calc_sbpop[x2pnt(calc_sbpop,reject[ii]),x2pnt(calc_sbpop,reject[ii+1])][]=NaN
endfor

For(jj=0;jj<numtraces;jj+=1)
	
	ToBeFitted[]=calc_sbpop[p][jj]
	
	//Try
		CurveFit/NTHR=0 /m=0 /n=1 /q exp_XOffset ToBeFitted  /D=fit_result;		//fit_result is specified only to generate the right number of points and x-scaling
		//y = K0+K1*exp(-(x-x0)/K2)
		fit_result=w_coef[0]+w_coef[1]*exp(-(x-w_fitconstants[0])/w_coef[2])	//the destination is overwritten with the fit function, because it contains regions that have not been fitted
		PoPCoef[][jj]=w_coef[p]
		PopFitConstants[jj]=w_fitconstants[0]
		Fits[][ii]=fit_result[p]
	//	AbortOnRTE	
	//Catch
	//	PoPCoef[][jj]=NaN
	//	PopFitConstants[jj]=NaN
	//	Fits[][ii]=NaN
	//EndTry
	
endfor

duplicate/o PopCoef, $targetname
killwaves/z calc_sbpop, calc_fits, fit_result, ToBeFitted, w_coef, w_fitconstants,w_sigma, PopCoef
end