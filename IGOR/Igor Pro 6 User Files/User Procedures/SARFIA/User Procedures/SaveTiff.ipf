#pragma rtGlobals=1		// Use modern global access method.
#include "normalize"

Function SaveTiff(wvin, [depth])
wave wvin
variable depth

duplicate/o/free wvin wv
redimension/s wv

if (wavedims(wv) == 1)
	DoAlert 0, "<"+nameofwave(wv)+"> is not an image. Nothing will be saved."
	return -1
endif

If (paramisdefault(depth))
	depth=16
elseif ((depth != 1) && (depth != 8) && (depth != 16) && (depth != 24) && (depth != 32) && (depth != 40) )
	doalert 1, "Only bit depths of 1, 8, 16, 32, 24 and 32 can be selected. Continue with default value 16?"
		if (v_flag != 1)
			return -1
		else
			depth = 16
		endif
endif

normalise(wv, 0, 2^depth-1, name="stwv")
wave stwv

if (depth < 16)
	redimension /B/U stwv
elseif (depth < 32)
	redimension /W/U stwv
else
	redimension /I/U stwv
endif

if (wavedims(wv) == 2)
	ImageSave /t="TIFF" /D=(depth) stwv as nameofwave(wvin)
else
	ImageSave /t="TIFF" /s /D=(depth) stwv as nameofwave(wvin)

endif


killwaves /z stwv
end


//////////////////////////////////////////////////////

Function SizeImage(Size,[WindowName])
	Variable Size
	string WindowName
	
	String TWName
	Variable xRange, yRange
	
	If(ParamIsDefault(WindowName))
		TWName=WinName(0,1,1)
	Else
		TWName=WindowName
	Endif
	
	DoUpdate
	
	GetAxis /w=$TWName/q left
	if(v_flag)
		GetAxis /w=$TWName/q right
	endif
	
	yRange = abs(v_max-v_min)
	
	GetAxis /w=$TWName/q bottom
	if(v_flag)
		GetAxis /w=$TWName/q top		//picture?
	endif
	xRange = abs(v_max-v_min)
	
	
	If(xRange > yRange)
		 ModifyGraph /w=$TWName width=(Size), Height=(Size*yRange/xRange)
	Else
		ModifyGraph /w=$TWName Height=(Size), Width=(Size/yRange*xRange)
	Endif
	
	DoUpDate
	ModifyGraph/w=$TWName height=0, width=0		//unlock size

End