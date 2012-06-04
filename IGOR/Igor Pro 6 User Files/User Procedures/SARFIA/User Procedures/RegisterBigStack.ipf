#pragma rtGlobals=1		// Use modern global access method.

Function RegisterBigStack(picwave, target)

wave picwave
string target

variable dims, type, fraction,  condition = 1, counter = 0, zdim
string info, name

info = waveinfo(picwave,0)
type = NumberByKey("NUMTYPE", info)
//	NUMTYPE	A number denoting the numerical type of the wave:
//		1:	Complex, added to one of the following:
//		2:	32-bit (single precision) floating point
//		4:	64-bit (double precision) floating point
//		8:	8-bit signed integer
//		16:	16-bit signed integer
//		32:	32-bit signed integer
//		64:	Unsigned, added to 8, 16 or 32 if wave is unsigned
dims = wavedims(picwave)
name = Nameofwave(picwave)



if (dims != 3)
	DoAlert 0, "<"+name+"> ins not a stack. Aborting RegisterStack." 
	return -1
endif

zdim = dimsize(picwave, 2)
fraction = round(zdim/2)





duplicate /o picwave, regcalcwave

if (dims != 2)
	redimension /s regcalcwave
endif

duplicate /o regcalcwave, ref
redimension /N=(-1,-1) ref

duplicate /o regcalcwave, part1
deletepoints /M=2  0, fraction, part1
duplicate /o regcalcwave, part2
deletepoints /M=2 fraction, (zdim-fraction), part2
killwaves regcalcwave





	imageregistration /q /stck /csnr=0 /refm=0 /tstm=0 testwave=part1, refwave=ref
	Print "Done part1, have patience..."
	wave m_regout
	duplicate /O m_regout, part1
	
	imageregistration /q /stck /csnr=0 /refm=0 /tstm=0 testwave=part2, refwave=ref
	duplicate /O m_regout, part2

	concatenate /o/np {part1,part2}, regcalcwave

regcalcwave= SelectNumber(numtype(regcalcwave[p][q])==2,regcalcwave[p][q],0)	//replace NaN's with 0

copyscaling(picwave,regcalcwave)
duplicate /o picwave, $target


killwaves /z  ref, regcalcwave, M_Regout, M_Regmaskout, M_RegParams, W_RegParams , part1, part2
print "Done custom IR"
end
