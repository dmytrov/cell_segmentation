// ----------------------------------------------------------------------------------------- 
// Module	:	xCFDReader
// Comment	:	Stand-Alone reader for CFD files (and tools)
// Author	:	Thomas Euler
// History	:	07-26-07	Recreated
//
// ----------------------------------------------------------------------------------------- 
// FUNCTIONS
//		function LoadCFD (sFPath, sFName, DoLog)
//			Load CFD file 'sFName' (w/o file extension) from directory 'sFPath' (with 
//			trailing \\) into a new data folder named after the file.
//
//		function CFDFolder2WaveAndInfo (sDFName, sTargetDF, DoLog)
//			Writes all header parameters in the CFD data folder 'sDFName' into the wave notes,
//			renames the wave(s), and moves the wave(s) to the target data folder 'sTargetDF'
//
//		function RetrieveCFDWaveParams (sWaveName, ps)
//			Retrieves the parameters of a CFD wave from its wave notes and writes them in the
//       	structure (type 'TStruct_CFDParams') passed by the calling routine.
//			For example:
//				function Test()
//				  struct TStruct_CFDParams ps
//				  RetrieveCFDWaveParams("exp030716hc4pre_Ch0", ps, 1)
//				  print ps.CFD_Version, ps.CFD_FName
//				end
//
//		function InitCFDReaderGUI ()
//			Creates a panel that simplifies opening CFDs
//
// SUPPORTING FUNCTIONS
//
//		function/S CFDTypeStr(CFDImgType) 
//     		Returns the CFD image type as a string
//
// DEFINITIONS
//		TStruct_CFDParams	: structure
//
// ----------------------------------------------------------------------------------------- 
#pragma rtGlobals=2		// Use modern global access method.
#include "xSupportFuncs"
// ----------------------------------------------------------------------------------------- 
#ifndef CFDReader_NoConstants
constant    CFDIsUndefined      = 0
constant    CFDIsLineScan       = 1
constant    CFDIsXYSeries       = 2
constant    CFDIsZStack         = 3
#endif
strconstant CFDNoteStart        = "CFD_START"	
strconstant CFDNoteEnd          = "CFD_END"

// ----------------------------------------------------------------------------------------- 
Structure  TStruct_CFDParams
  variable CFD_Version
  string   CFD_FName
  variable CFD_Chn
  string   CFD_User
  string   CFD_RecTime
  string   CFD_RecDate
  variable CFD_GrbStart
  variable CFD_GrbStop
  variable CFD_ImgType
  variable CFD_nChan
  variable CFD_dx
  variable CFD_dy
  variable CFD_nFr
  variable CFD_nFrAvg
  variable CFD_SplitFr
  variable CFD_msPerLn
  variable CFD_msPerRt
  variable CFD_ScnOffX
  variable CFD_ScnOffY
  variable CFD_ScnRgeX
  variable CFD_ScnRgeY
  variable CFD_SutX0_um
  variable CFD_SutY0_um
  variable CFD_SutZ0_um
  variable CFD_SutX1_um
  variable CFD_SutY1_um
  variable CFD_SutZ1_um
  variable CFD_zIncr_nm  
  variable CFD_Orient
  variable CFD_ZoomFac
EndStructure

// ----------------------------------------------------------------------------------------- 
structure  TCFDHeaderRaw
// Confoc Header Structure - 256 bytes (was 96)
//  typedef struct ConFocHeader {
	uint16		version;					// program version (0)
	char		name[14];					// data file name (2)
	char		user[16];					// user name (16)
	char		time_[16];					// time of acquisition (32)
	char		date_[16];					// date of acquisition (48)
	uint32		start;						// time at start of grab (64)
	uint32		stop;						// time at end of grab (68)
	int32		zpos;						// x position in 1000's of microns (72)
	int32		hdrsize;					// length of header static + dynamic (76)
	int32		xpos;						// x position in 1000's of microns (80)
	int32		ypos;						// y position in 1000's of microns (84)
	int32 		endPosX;   					//  88 - last x position
	int32 		endPosY;      				//  92 - last y position
	int32 		endPosZ;      				//  96 - last z position
	float 		lAttenuationDepth;			// 100 - For recalculation of used intensity - new 011107 MUM
	int32		bIntensityDevUsed;			// 104 - Has intensity controlling devive been used (102)
	float 		startIntensityInPercent;  // 108 - necessary to recalculate intensity used for single images - MUM 030108	
	int32		rsvd[36];    				// 112 - reserved bytes: 256 total - 112 used = 144 bytes = 36 longs each with 4 byte - MUM 030108
//  }	CFH;

// Scanner parameters - 256 bytes (64 longs)
//	struct Acv {
	int32		buflen;						//  1 actual D/A buffer length, as calc'd 
	int32		pixbuflen;					//  2 actual pixel (dout) buffer length 
	
//    struct {								//  3 flag sets 
// 		unsigned	pol:1;					// Bipolar/Unipolar 
//		unsigned	clksrc:1;				// Clock source for both D/A and Dout 
// 		unsigned	waveform:2;				// waveform type with 1 bit to grow 
//   	unsigned	trigsrc:1;				// Trigger source for both D/A and Dout 
//   	unsigned	trigpol:1;				// Trigger polarity when external 
//   	unsigned	trigmod:2;				// Trigger mode 
//   	unsigned	LineScan:1;				// LineScan Mode 
// #-  	unsigned 	fTacqTimeBase:1;		// Sec/Msec flag 
// #+	unsigned	zt:1;					// z or time series, stage or a dummy is active, 
//										       replaces fTacqTimeBase - MUM 030708
//    	unsigned	rsvd1:6;
//    	unsigned 	rsvd2:16;
//    } flags;
 	int32		Acv_flags;

	uint32		darate;						//  4 D/A clock frequency */
	uint32		dirate;						//  5 Pixel clock rate in mHz*/
	int32		anaoff;						//  6 analog offset in microseconds */

//    struct {								//  7 pixels x and y */
//      unsigned x:16;						// was sxpix */
//      unsigned y:16;						// was sypix */
//    } pixels;
	uint16		pixels_x;
	uint16		pixels_y;	

//    struct {								/*  8 */
//      unsigned	x:16;					/* was pppx */
//      unsigned	y:16;					/* was pppy */
//    } ppp;
	uint16		ppp_x;
	uint16		ppp_y;	

// ***Not used any more with dtfu110.out and later - MUM 030627
// #- struct {								/*  9 */
// #-   unsigned	scan:16;
// #-   unsigned	yretrace:16;
// #- } scan;
// ***Scan parameters struct as replacement for old scan struct - MUM 030627
// #+ struct {								// 9 - 
// #+   unsigned	prePixels:8;			// reclycled unused 'scan:16' - MUM 030715
// #+   unsigned	postPixels:8;			// reclycled unused 'scan:16' - MUM 030715
// #+   unsigned	yretrace:16;			// not used any more with dtfu110.out and later - MUM 030627
// #+ } scanParams;
	uchar		scanParams_prePixels;
	uchar		scanParams_postPixels;	
	uint16		scanParams_yretrace;		
	
// BEFORE VERSION 1.533 -->
//    struct {								/* 10 */
//      unsigned	images:16;
//      unsigned	chans:16;
//    } num;
//    long	reserv[4];						/* reserved up to 14 max*/
// <---
//    TempVal       = pwACV[10-1]  
//    ACVImages     = Trunc(TempVal & 0xFFFF)
//    ACVChans      = Trunc(TempVal / 0xFFFF)    
//
// FROM VERSION 1.533 -->
// #  struct {								/* 10 + 11 */
// #*   unsigned	images:32;				// was 16 bit, extended to 32 - MUM 030627
// #    unsigned	chans:16;
// #+   unsigned	splitParts:16;			// Number of parts to split images into - MUM 030627
//    } num;
	uint32		num_images;
	uint16		num_chans;	
	uint16		num_splitParts;	
	
	uint32		timeLeadY;					// 12 - DA subsystems Y time lead in microseconds - MUM 030715
	
// #+ struct {								// 13
// #+   unsigned	lines:16;				// Number of lines to open shutter in advance, minimum is 1 with dtfu121 and later
// #+   unsigned	usec:16;				// Same in microseconds for tighter control, for eventual use later
// #+ } shutterOffset;
	uint16		shutterOffset_lines;
	uint16		shutterOffset_usecs;	

// #+ struct {								/* 14 */
// #+   unsigned	num:16;					/* Number of images averaged/step */
// #+   unsigned	toss:16;				// Number of images to toss before average - now unused - MUM 030730
// #+ } avg;
// <---
	uint16		avg_num;
	uint16		avg_toss;	

//    struct {								/* 15 */
//      unsigned	x:16;					/* maximum x dimension, targeted was mxsize*/
//      unsigned	y:16;					/* maximum y dimension, targeted was mysize*/
//    } msize;
	uint16		msize_x;
	uint16		msize_y;	
	
	float		scandur;					// 16 target scan duration (msec) */
	float		retracedur;					// 17 target retrace duration (msec) */

	uint32		ZStepSize;					// 18 Z axis increment in nm */
	uint32		DwellTime;					// 19 Time in ms to wait during Z/T series scan */

//    unsigned long cflags;				/* 20 config flag copies */
//      typedef struct ConfigFlags{
//        unsigned		cfgautoload:1;		// autoload flag
//        unsigned		cfgchanged:1;
//        unsigned		Cancel:1;
//        unsigned		StrtResp:1;
//        unsigned		RdyForLoad:1;
//        unsigned		fTopmost:1;			// Stay on top or not
//        unsigned		fTraceOn:1;			// Set trace mode
//        unsigned		fMotCtl:1;			// Stepper Control flag
//        unsigned		fZseries:1;
//        unsigned		fZRetHome:1;
//        unsigned		fWrtEachImg:1;		// write each image
//        unsigned		FNAutoInc:1;		// increment filename after write
//        unsigned		FNAutoSave:1;		// autosave file after acquisition
//        unsigned		FNOverWrite:1;		// over write existing files
//        unsigned		cfgrecall:1;		// bit to service old cfg recall after file read
//        unsigned		fMegaWrite:1;		// bit to indicate megawrites
//        unsigned		fUserMode:1;
//  } CFGFLAGS;
	uint32		cfgflags;
	
// BEFORE VERSION 1.533 -->
// #- struct {							/* 21 */
//      unsigned	num:16;				/* Number of images averaged/step */
//      unsigned	toss:16;			/* Number of images to toss before average */
//    } avg;
// <---
//
// FROM VERSION 1.533 -->
// #+ DWORD	 unused;					// 21 - avg has been put to byte 14, because it is needed on the dt board - MUM 030721
	uint32		unused;
// <--

	uint32		AcqTimeInt;				// 22 Time between acquisitions */
	uint32		TacqCounter;			// 23 number of sets of movies in file, valid Version 3.7.010 */
	uint32		XStepSize;				// 24 X axis increment in nm if Sutter stage used */
	uint32		YStepSize;				// 25 Y axis increment in nm if Sutter stage used */
	uint32		acv_rsvd[39];			// 26 buffer to 64 longs (256) */
//  };

// More scanner parameters - 256 bytes (64 longs)
//	struct Asv {
//    struct {							/*  1 Ranges for scan */
//      unsigned	x:16;
//      unsigned	y:16;
//    } range;
	uint16		range_x;
	uint16		range_y;	

//    struct {							/*  2 Offsets for scan */
//      unsigned	x:16;
//      unsigned	y:16;
//    } offset;
	uint16		offset_x;
	uint16		offset_y;	

//    struct {				  			/*  3 Parking position and orientation */
//      unsigned	park:16;
//      unsigned	orient:16;  		/ degrees *100
//    } scan;
	uint16		scan_park;
	uint16		scan_orient;	

//    struct {							/*  4 Flags */
// #-   int	 	discrete:1;				/* Slow scan value flag */
// #-   int 	ScanAvgMode:1;
//      int		rsvd:32;				// all flags unused - MUM 030724
//    } flags;
	uint32		Asv_flags;
	

	float	 	zoom_fac;				//  5 Zoom factor (factor *10^6) */
	uint32		reserv[9];				//  6 reserved */
	
//    struct {
//      unsigned	Gain:16;			/* 15 Analog module 0 gain, XPG*/
//      unsigned	Offset:16;			/* Analog module 0 offset, XPG */
//    } Acm0;
	uint16		Acm0_Gain;
	uint16		Acm0_Offs;	

//    struct {
//      unsigned	Gain:16;			/* 16 Analog module 1 gain, XPG */
//      unsigned	Offset:16;			/* Analog module 1 offset, XPG */
//    } Acm1;
	uint16		Acm1_Gain;
	uint16		Acm1_Offs;	

	uint32		Asv_rsvd[48];   			//	17 */
//  };
endstructure

// ----------------------------------------------------------------------------------------- 
// ----------------------------------------------------------------------------------------- 
function LoadCFDWithDialog (IsSwapChs)
  variable IsSwapChs

  string   sFPath, sFName, sTemp
  
  sTemp  = SelectFile(".cfd", "")
  sFPath = PathName(sTemp)
  sFName = BaseName(sTemp,".")
  
  LoadCFD(sFPath, sFName, IsSwapChs, 0)
  CFDFolder2WaveAndInfo(sFName, "", 0)
end

// ----------------------------------------------------------------------------------------- 
function LoadCFD (sFPath, sFName, IsSwapChs, DoLog)
  string   sFPath, sFName
  variable IsSwapChs, DoLog

// Temporary variables
//
  string   sSavDF, wInfoName, wACVName, wASVName, TempStr, wChName
  variable refNum, TempVal, ASVZoom_fac, PDataSize, FDataSize
  variable ix, iy, ic, ii
  
// Initialize
//  
  TempStr = ""
  wChName = ""
  sSavDF  = GetDataFolder(1)
  if(DoLog)
    printf "*** Load CFD ...\r\t'%s' in '%s'\r", sFName, sFPath
  endif  

// Create data folder under root
//  
  SetDataFolder root:
  if(DataFolderExists(sFName))
    printf "ERROR: Folder '%s' already exists\r", sFName
    SetDataFolder sSavDF
    return -1
  else
    NewDataFolder $(sFName)
    SetDataFolder sFName
    NewDataFolder $("Header")
  endif  
  
// Make global variables and get access
//
  SetDataFolder Header
  variable/G CfNTVersion 
  string/G   CFDFName     
  string/G   CFDPath      
  variable/G CFHHdrSize   
  variable/G CFDImgType   
  variable/G ACVSplitParts
  variable/G ACVImages    
  variable/G ACVImagesAvrg
  variable/G ACVChans     
  variable/G ACVChansCorr 
  variable/G ACVFlagSet   
  variable/G ACVFlagSet_LS
  variable/G ACVCFlags    
  variable/G ACVPixelsX   
  variable/G ACVPixelsY   
  variable/G ACVScanDur   
  variable/G ACVRetraceDur
  variable/G LS_DurPerLn_s
  variable/G LS_nResCols  
  variable/G ASVScanOffsX 
  variable/G ASVScanOffsY 
  variable/G ASVScanRangeX
  variable/G ASVScanRangeY
  variable/G ACVzInc 
  SetDataFolder ::

  NVAR CfNTVersion   = :Header:CfNTVersion
  SVAR CFDFName      = :Header:CFDFName
  SVAR CFDPath       = :Header:CFDPath

  NVAR CFHHdrSize    = :Header:CFHHdrSize
  NVAR CFDImgType    = :Header:CFDImgType
  NVAR ACVSplitParts = :Header:ACVSplitParts
  NVAR ACVImages     = :Header:ACVImages
  NVAR ACVImagesAvrg = :Header:ACVImagesAvrg  
  NVAR ACVChans      = :Header:ACVChans
  NVAR ACVChansCorr  = :Header:ACVChansCorr  
  NVAR ACVFlagSet    = :Header:ACVFlagSet
  NVAR ACVFlagSet_LS = :Header:ACVFlagSet_LS
  NVAR ACVCFlags     = :Header:ACVCFlags
  NVAR ACVPixelsX    = :Header:ACVPixelsX
  NVAR ACVPixelsY    = :Header:ACVPixelsY
  NVAR ACVScanDur    = :Header:ACVScanDur
  NVAR ACVRetraceDur = :Header:ACVRetraceDur
  NVAR LS_DurPerLn_s = :Header:LS_DurPerLn_s
  NVAR LS_nResCols   = :Header:LS_nResCols
  NVAR ASVScanOffsX  = :Header:ASVScanOffsX    
  NVAR ASVScanOffsY  = :Header:ASVScanOffsY        
  NVAR ASVScanRangeX = :Header:ASVScanRangeX    
  NVAR ASVScanRangeY = :Header:ASVScanRangeY        
  NVAR ACVzInc       = :Header:ACVzInc            

// Check whether file exists, if so open file
//  
  if(DoLog)
    printf "\tOpening file ...\r" 
  endif  
  Open/Z/R refNum as sFPath +sFName +".cfd"
  if(V_flag != 0)
    printf "ERROR: File not found\r" 
    SetDataFolder sSavDF
    KillDataFolder $("root:" +sFName)    
    return -2
  endif  
  CFDFName    = sFName
  CFDPath     = sFPath

// Generate waves named after the data file
//  
  wInfoName          = ":Header:CFH" 
  Make/O/N=(128,2)/T $wInfoName  
  wave/T   pwInfo    = $wInfoName
  wACVName           = ":Header:ACV" 
  Make/O/I/U/N=64 $wACVName  
  wave/I/U pwACV     = $wACVName
  wASVName           = ":Header:ASV1" 
  Make/O/I/U/N=8   $wASVName  
  wave/I/U pwASV1    = $wASVName
  wASVName           = ":Header:ASV2" 
  Make/O/I/U/N=118 $wASVName  
  wave/I/U pwASV2    = $wASVName
  
// Read in header
//
  pwInfo[ 0][0] = "File name"
  pwInfo[ 0][1] = sFName +".cfd"
  pwInfo[ 1][0] = "File path"  
  pwInfo[ 1][1] = sFPath
  
// -----------------------------------------------------------------------------------------  
// Confoc Header Structure - 256 bytes (was 96)
// -----------------------------------------------------------------------------------------  
//  typedef struct ConFocHeader {
//	  unsigned short	version;			// program version (0)
  pwInfo[ 2][0] = "CFHVersion"
  FBinRead/B=3/F=2/U refNum, TempVal
  pwInfo[ 2][1] = Num2Str(TempVal/1000)
  CfNTVersion   = TempVal

//	  char	name[14];						// data file name (2)
  pwInfo[ 3][0] = "CFHName"
  TempStr       = PadString(TempStr, 14, 0x20)
  FBinRead refNum, TempStr
  pwInfo[ 3][1] = TempStr

//	  char	user[16];						// user name (16)
  pwInfo[ 4][0] = "CFHUser"
  TempStr       = PadString(TempStr, 16, 0x20)  
  FBinRead refNum, TempStr
  pwInfo[ 4][1] = TempStr

//	  char	time[16];						// time of acquisition (32)
  pwInfo[ 5][0] = "CFHTime"
  TempStr       = PadString(TempStr, 16, 0x20)    
  FBinRead refNum, TempStr
  pwInfo[ 5][1] = TempStr

//	  char	date[16];						// date of acquisition (48)
  pwInfo[ 6][0] = "CFHDate"
  TempStr       = PadString(TempStr, 16, 0x20)  
  FBinRead refNum, TempStr
  pwInfo[ 6][1] = TempStr
  
//	  DWORD	start;							// time at start of grab (64)
  pwInfo[ 7][0] = "CFHStart"
  FBinRead/B=3/F=3/U refNum, TempVal
  pwInfo[ 7][1] = Num2iStr(TempVal)

//	  DWORD	stop;							// time at end of grab (68)
  pwInfo[ 8][0] = "CFHStop"
  FBinRead/B=3/F=3/U refNum, TempVal
  pwInfo[ 8][1] = Num2iStr(TempVal)

//	  long	zpos;							// z position in 1000's of microns (72)
  pwInfo[ 9][0] = "CFHzPos"
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[ 9][1] = Num2iStr(TempVal)

//	  long	hdrsize;						// length of header static + dynamic (76)
  pwInfo[12][0] = "CFHHeaderSize"  
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[12][1] = Num2iStr(TempVal)
  CFHHdrSize    = TempVal

//	  long	xpos;							// x position in 1000's of microns (80)
  pwInfo[10][0] = "CFHxPos"
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[10][1] = Num2iStr(TempVal)

//	  long	ypos;							// y position in 1000's of microns (84)
  pwInfo[11][0] = "CFHyPos"        
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[11][1] = Num2iStr(TempVal)
  
// ***Record last xyz position too - MUM 020704
// #+ long endPosX;             			//  88 - last x position
// #+ long endPosY;                		//  92 - last y position
// #+ long endPosZ;                		//  96 - last z position
  pwInfo[25][0] = "endPosX"        
  pwInfo[26][0] = "endPosY"        
  pwInfo[27][0] = "endPosZ"            
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[25][1] = Num2iStr(TempVal)
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[26][1] = Num2iStr(TempVal)
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[27][1] = Num2iStr(TempVal)

// ***Intensity parameters shifted 12 byte behind - MUM 020704
// #+ float lAttenuationDepth;          	// 100 - For recalculation of used intensity - new 011107 MUM
  pwInfo[28][0] = "lAttenuationDepth"            
  FBinRead/B=3/F=4   refNum, TempVal
  pwInfo[28][1] = Num2iStr(TempVal)
  
// #+ BOOL  bIntensityDevUsed;          	// 104 - Has intensity controlling devive been used (102)
  pwInfo[29][0] = "bIntensityDevUsed"            
  FBinRead/B=3/F=3   refNum, TempVal
  pwInfo[29][1] = Num2iStr(TempVal)

// #+ float startIntensityInPercent;   	// 108 - necessary to recalculate intensity used for single images - MUM 030108
  pwInfo[30][0] = "startIntensityInPercent"            
  FBinRead/B=3/F=4   refNum, TempVal
  pwInfo[30][1] = Num2iStr(TempVal)
  
// #  LONG  rsvd[36];                   	// 112 - reserved bytes: 256 total - 112 used = 144 bytes = 36 longs each with 4 byte - MUM 030108
//  }	CFH;
  TempStr = PadString(TempStr, 36*4, 0x20)  	// was 42
  FBinRead refNum, TempStr

// -----------------------------------------------------------------------------------------  
// Scanner parameters - 256 bytes (64 longs)
// -----------------------------------------------------------------------------------------  
//	struct Acv {
//   (Read first 15 32-bit values as longs in a temporary wave and copy at the beginning 
//    of the ACV wave)
//
  Make/O/I/U/N=15 wTempACV  
  FBinRead/B=3/F=3/U refNum, wTempACV  
  pwACV         = wTempACV

//    long	buflen;						/*  1 actual D/A buffer length, as calc'd */
//    long	pixbuflen;					/*  2 actual pixel (dout) buffer length */

//    struct {							/*  3 flag sets */
// 		unsigned	pol:1;				/* Bipolar/Unipolar */
//		unsigned	clksrc:1;			/* Clock source for both D/A and Dout */
// 		unsigned	waveform:2;			/* waveform type with 1 bit to grow */
//   	unsigned	trigsrc:1;			/* Trigger source for both D/A and Dout */
//   	unsigned	trigpol:1;			/* Trigger polarity when external */
//   	unsigned	trigmod:2;			/* Trigger mode */
//   	unsigned	LineScan:1;			/* LineScan Mode */
// #-  	unsigned 	fTacqTimeBase:1;	/* Sec/Msec flag */
// #+	unsigned	zt:1;				// z or time series, stage or a dummy is active, 
//										   replaces fTacqTimeBase - MUM 030708
//    	unsigned	rsvd1:6;
//    	unsigned 	rsvd2:16;
//    } flags;
  ACVFlagSet    = pwACV[3-1]
  pwInfo[15][0] = "ACVFlagSet"        
  sprintf TempStr, "%b", ACVFlagSet
  pwInfo[15][1] = TempStr
  ACVFlagSet_LS = (ACVFlagSet & 0x0100) > 0

//    unsigned long	darate;			/*  4 D/A clock frequency */
//    unsigned long	dirate;			/*  5 Pixel clock rate in mHz*/
//    long	anaoff;						/*  6 analog offset in microseconds */

//    struct {							/*  7 pixels x and y */
//      unsigned x:16;					/* was sxpix */
//      unsigned y:16;					/* was sypix */
//    } pixels;
  pwInfo[17][0] = "ACVPixelsX"                
  pwInfo[18][0] = "ACVPixelsY"                  
  TempVal       = pwACV[7-1]  
  ACVPixelsX    = Trunc(TempVal & 0xFFFF)  
  ACVPixelsY    = Trunc(TempVal / 0xFFFF)
  pwInfo[17][1] = Num2iStr(ACVPixelsX)
  pwInfo[18][1] = Num2iStr(ACVPixelsY)

//    struct {							/*  8 */
//      unsigned	x:16;				/* was pppx */
//      unsigned	y:16;				/* was pppy */
//    } ppp;
//
// ***Not used any more with dtfu110.out and later - MUM 030627
// #- struct {							/*  9 */
// #-   unsigned	scan:16;
// #-   unsigned	yretrace:16;
// #- } scan;
// ***Scan parameters struct as replacement for old scan struct - MUM 030627
// #+ struct {							// 9 - 
// #+   unsigned	prePixels:8;		// reclycled unused 'scan:16' - MUM 030715
// #+   unsigned	postPixels:8;		// reclycled unused 'scan:16' - MUM 030715
// #+   unsigned	yretrace:16;		// not used any more with dtfu110.out and later - MUM 030627
// #+ } scanParams;

  if (CfNTVersion < 4533) 
// BEFORE VERSION 1.533 -->
//    struct {							/* 10 */
//      unsigned	images:16;
//      unsigned	chans:16;
//    } num;
//    long	reserv[4];					/* reserved up to 14 max*/
// <---
    TempVal       = pwACV[10-1]  
    ACVImages     = Trunc(TempVal & 0xFFFF)
    ACVChans      = Trunc(TempVal / 0xFFFF)    
  else
// FROM VERSION 1.533 -->
// #  struct {							/* 10 + 11 */
// #*   unsigned	images:32;			// was 16 bit, extended to 32 - MUM 030627
// #    unsigned	chans:16;
// #+   unsigned	splitParts:16;		// Number of parts to split images into - MUM 030627
//    } num;
// #+ long			timeLeadY;			// 12 - DA subsystems Y time lead in microseconds - MUM 030715
// #+ struct {							// 13
// #+   unsigned	lines:16;			// Number of lines to open shutter in advance, minimum is 1 with dtfu121 and later
// #+   unsigned	usec:16;			// Same in microseconds for tighter control, for eventual use later
// #+ } shutterOffset;
// #+ struct {							/* 14 */
// #+   unsigned	num:16;				/* Number of images averaged/step */
// #+   unsigned	toss:16;			// Number of images to toss before average - now unused - MUM 030730
// #+ } avg;
// <---
    ACVImages     = pwACV[10-1]  
    TempVal       = pwACV[11-1]  
    ACVChans      = Trunc(TempVal & 0xFFFF)
    ACVSplitParts = Trunc(TempVal / 0xFFFF)
    TempVal       = pwACV[14-1]     
    ACVImagesAvrg = Trunc(TempVal & 0xFFFF)     
  endif  
  pwInfo[13][0] = "ACVImages"                 
  pwInfo[14][0] = "ACVChans"                    
  pwInfo[31][0] = "ACVSplitParts"                      
  pwInfo[32][0] = "ACVImagesAvrg"                        
  pwInfo[13][1] = Num2iStr(ACVImages)
  pwInfo[14][1] = Num2iStr(ACVChans)
  pwInfo[31][1] = Num2iStr(ACVSplitParts)    
  pwInfo[32][1] = Num2iStr(ACVImagesAvrg)      

//    struct {							/* 15 */
//      unsigned	x:16;				/* maximum x dimension, targeted was mxsize*/
//      unsigned	y:16;				/* maximum y dimension, targeted was mysize*/
//    } msize;

//    float	scandur;					/* 16 target scan duration (msec) */
//    float	retracedur;					/* 17 target retrace duration (msec) */
  FBinRead/B=3/F=4   refNum, ACVScanDur
  FBinRead/B=3/F=4   refNum, ACVRetraceDur  
  pwACV[15]     = -1
  pwACV[16]     = -1
  
//   (Read the next 47 32-bit values [15+2+47 = 64) in a temporary wave and copy 
//    at the end of the ACV wave)
//
  Make/O/I/U/N=47 wTempACV  
  FBinRead/B=3/F=3/U refNum, wTempACV    
  pwACV[17,63]  = wTempACV[p-17]  
  KillWaves wTempACV
  
//    long	ZStepSize;					/* 18 Z axis increment in nm */
  ACVzInc       = pwACV[18-1]     
  
//    unsigned long DwellTime;		/* 19 Time in ms to wait during Z/T series scan */


//    unsigned long cflags;			/* 20 config flag copies */
//      typedef struct ConfigFlags{
//        unsigned		cfgautoload:1;	// autoload flag
//        unsigned		cfgchanged:1;
//        unsigned		Cancel:1;
//        unsigned		StrtResp:1;
//        unsigned		RdyForLoad:1;
//        unsigned		fTopmost:1;		// Stay on top or not
//        unsigned		fTraceOn:1;		// Set trace mode
//        unsigned		fMotCtl:1;		// Stepper Control flag
//        unsigned		fZseries:1;
//        unsigned		fZRetHome:1;
//        unsigned		fWrtEachImg:1;	// write each image
//        unsigned		FNAutoInc:1;	// increment filename after write
//        unsigned		FNAutoSave:1;	// autosave file after acquisition
//        unsigned		FNOverWrite:1;	// over write existing files
//        unsigned		cfgrecall:1;	// bit to service old cfg recall after file read
//        unsigned		fMegaWrite:1;	// bit to indicate megawrites
//        unsigned		fUserMode:1;
//  } CFGFLAGS;
  pwInfo[16][0] = "ACVCFlags"        
  ACVCFlags     = pwACV[20-1]
  sprintf TempStr, "%b", ACVCFlags
  pwInfo[16][1] = TempStr

// BEFORE VERSION 1.533 -->
// #- struct {							/* 21 */
//      unsigned	num:16;				/* Number of images averaged/step */
//      unsigned	toss:16;			/* Number of images to toss before average */
//    } avg;
// <---
// FROM VERSION 1.533 -->
// #+ DWORD	 unused;					// 21 - avg has been put to byte 14, because it is needed on the dt board - MUM 030721
// <--
//
//    long AcqTimeInt;					/* 22 Time between acquisitions */
//    long	TacqCounter;				/* 23 number of sets of movies in file, valid Version 3.7.010 */
//    long	XStepSize;					/* 24 X axis increment in nm if Sutter stage used */
//    long	YStepSize;					/* 25 Y axis increment in nm if Sutter stage used */
//    long	rsvd[39];					/* 26 buffer to 64 longs (256) */
//  };

// Calculate some values and fill into info table
//
  LS_DurPerLn_s = (ACVScanDur +ACVRetraceDur)/1000
  pwInfo[20][0] = "ACVScanDur"                
  pwInfo[20][1] = Num2Str(ACVScanDur)
  pwInfo[21][0] = "ACVRetraceDur"                
  pwInfo[21][1] = Num2Str(ACVRetraceDur)
  pwInfo[22][0] = "Scan +Retrace (s per line)"                
  pwInfo[22][1] = Num2Str(LS_DurPerLn_s)

// -----------------------------------------------------------------------------------------  
// More scanner parameters - 256 (64 longs)
// -----------------------------------------------------------------------------------------  
//	struct Asv {
//    (reads in 8 16-bit values)
  FBinRead/B=3/F=2/U refNum, pwASV1

//    struct {						/*  1 Ranges for scan */
//      unsigned	x:16;
//      unsigned	y:16;
//    } range;
//
//    struct {						/*  2 Offsets for scan */
//      unsigned	x:16;
//      unsigned	y:16;
//    } offset;
//    struct {				  		/*  3 Parking position and orientation */
//      unsigned	park:16;
//      unsigned	orient:16;  	// degrees *100
//    } scan;
//    struct {						/*  4 Flags */
// #-   int	 	discrete:1;			/* Slow scan value flag */
// #-   int 	ScanAvgMode:1;
//      int		rsvd:32;			// all flags unused - MUM 030724
//    } flags;
  
//    float	 zoom_fac;				/*  5 Zoom factor (factor *10^6) */
  FBinRead/B=3/F=4   refNum, ASVZoom_fac
  
  ASVScanRangeX = (20/(2^16-1) *pwASV1[0]) /ASVZoom_fac
  ASVScanRangeX = Round(ASVScanRangeX *1000)/1000 	// [V]
  ASVScanRangeY = (20/(2^16-1) *pwASV1[1]) /ASVZoom_fac
  ASVScanRangeY = Round(ASVScanRangeY *1000)/1000 	// [V]  

  ASVScanOffsX  = (20/(2^16-1) *(pwASV1[2] +pwASV1[0] /2) -10) ///ASVZoom_fac 
  ASVScanOffsX  = Round(ASVScanOffsX *1000)/1000 
  ASVScanOffsY  = (20/(2^16-1) *(pwASV1[3] +pwASV1[1] /2) -10) ///ASVZoom_fac   
  ASVScanOffsY  = Round(ASVScanOffsY *1000)/1000
  

//    (reads in 118 16-bit values)
  FBinRead/B=3/F=2/U refNum, pwASV2  

//    long	reserv[9];				/*  6 reserved */
//    struct {
//      unsigned	Gain:16;		/* 15 Analog module 0 gain, XPG*/
//      unsigned	Offset:16;		/* Analog module 0 offset, XPG */
//    } Acm0;
//    struct {
//      unsigned	Gain:16;		/* 16 Analog module 1 gain, XPG */
//      unsigned	Offset:16;		/* Analog module 1 offset, XPG */
//    } Acm1;
//    long	rsvd[48];   			/*	17 */
//  };
//

// Calculate some values and fill into info table
//
  pwInfo[23][0] = "Scan orientation"                
  pwInfo[23][1] = Num2Str(pwASV1[5]/100)
  pwInfo[24][0] = "Zoom factor (phys.)"                
  pwInfo[24][1] = Num2Str(ASVZoom_fac)
  pwInfo[33][0] = "ASVScanOffsX"
  pwInfo[33][1] = Num2Str(ASVScanOffsX)
  pwInfo[34][0] = "ASVScanOffsY"
  pwInfo[34][1] = Num2Str(ASVScanOffsY)

// -----------------------------------------------------------------------------------------  
// Determine image type
//
  if(ACVFlagSet_LS > 0)
    CFDImgType   = CFDIsLineScan
  elseif((ACVCFlags & 0x0100) >0)
    CFDImgType   = CFDIsZStack
  else
    CFDImgType   = CFDIsXYSeries
  endif    
  
// Check image data
//
  FStatus refNum
  if(V_filePos != CFHHdrSize)
    TempStr = "WARNING: Different sizes for inquired header (%d) and loaded header (%d)\r"
    printf TempStr, CFHHdrSize, V_filePos
  endif

// Correct number of channels if necessary
//  
  ACVChansCorr = 0
  if(ACVChans & 0x01) 
    ACVChansCorr += 1
  endif
  if(ACVChans & 0x02) 
    ACVChansCorr += 1
  endif  
  pwInfo[19][0] = "ACVChansCorr"                    
  pwInfo[19][1] = Num2iStr(ACVChansCorr)
  
// Check whether frame size, image and channel number make sense ...
//
  PDataSize = ACVPixelsX *ACVChansCorr *ACVPixelsY *ACVImages
  FDataSize = V_logEOF -V_filePos
  if(FDataSize != PDataSize)
    TempStr = "WARNING: Sizes for predicted (%d) and existing (%d) data differ\r"    
    printf TempStr, PDataSize, FDataSize
  endif  

// Print info into history window
//  
  if(DoLog)
    printf "\tFile info:\r"
    printf "\t\tVersion\user\t\t= %s (%d)", pwInfo[2][1], CfNTVersion
    printf ", name;user = %s;%s\r", pwInfo[3][1], pwInfo[4][1]    
    printf "\t\tTime of recording\t= %s %s\r", pwInfo[5][1], pwInfo[6][1]
    printf "\t\tTiming\t\t\t= %.1f ms retrace + %.1f ms scan ", ACVRetraceDur, ACVScanDur
    printf "/1000 = %.3f sec /scan line\r", LS_DurPerLn_s
    printf "\t\tTime of grab\t\t= from %s until %s\r", pwInfo[7][1], pwInfo[8][1]
    printf "\t\tSutter x, y, z\t\t= %.2f, %.2f, %.2f um\r", Str2Num(pwInfo[10][1])/1000, Str2Num(pwInfo[11][1])/1000, Str2Num(pwInfo[9][1])/1000 
    printf "\t\tScan range x,y\t= %.3f, %.3f V\r", ASVScanRangeX, ASVScanRangeY    
    printf "\t\tScan offset x,y\t= %.3f, %.3f V\r", ASVScanOffsX, ASVScanOffsY    
    printf "\t\tOrientation\t\t= %s degree\r", pwInfo[23][1]
    printf "\t\tZoom factor\t\t= %s\r", pwInfo[24][1]    
    switch (CFDImgType)
      case CFDIsUndefined:
        TempStr = "unknown"
        break
      case CFDIsLineScan :
        TempStr = "line scan"
        break
      case CFDIsXYSeries :
        TempStr = "xy time series"
        break
      case CFDIsZStack   :
        TempStr = "z stack"
        break
    endswitch    
    printf "\t\tScan type\t\t= %s: ", TempStr
    printf "%d image(s) (%d averaged; each split into %d)", ACVImages, ACVImagesAvrg, ACVSplitParts
    printf ", %dx%d, ", ACVPixelsX, ACVPixelsY
    printf "with %d (0x%0.2X) channels\r", ACVChansCorr, ACVChans
    printf "\t\tFlags\t\t\t= 0x%.4X \t-> ", ACVFlagSet
    if((ACVFlagSet & 0x0001) >0)
      printf "pol "      
    endif  
    if((ACVFlagSet & 0x0100) >0)
      printf "LineScan "      
    endif  
    printf "\r"    
    printf "\t\tcFlags\t\t\t= 0x%.4X \t-> ", ACVCFlags
    if((ACVCFlags & 0x0100) >0)
      printf "fZSeries "      
    endif  
    if((ACVCFlags & 0x0400) >0)
      printf "fWrtEachImg "      
    endif  
    printf "\r"  
  endif  

// -----------------------------------------------------------------------------------------  
// Read in image data
//
  if(CFDImgType == CFDIsLineScan) 
  // Line scan data ...
  //
    if(DoLog)
      printf "\tReading line scan data ...\r"    
    endif  
    
    if(ACVChansCorr == 1)
    // ___ Line scan, 1 channel __________________________________________________
    //
      wChName = "Ch0"
      Make/O/N=(ACVPixelsY*ACVImages,ACVPixelsX)/B/U $wChName  
      wave/B/U pwData = $wChName    
      pwData = 0

    // Create read-in buffer and read data (in one piece)
    //
      Make/O/N=(ACVPixelsY,ACVPixelsX*ACVImages)/B/U wTempData
      FBinRead/B=3/F=1/U refNum, wTempData

    // Copy data into waves while transposing it
    //
      pwData[][] = wTempData[q][p]
      
    else
    // ___ Line scan, 2 or more channels _________________________________________
    //
      Make/O/N=(ACVPixelsY*ACVImages,ACVPixelsX)/B/U Ch0
      wave/B/U pwDataCh0 = $("Ch0");
      Make/O/N=(ACVPixelsY*ACVImages,ACVPixelsX)/B/U Ch1
      wave/B/U pwDataCh1 = $("Ch1");
    
    // Create read-in buffer and read data (in one piece)
    //
      Make/O/N=(ACVPixelsY*ACVChansCorr, ACVPixelsX*ACVImages)/B/U wTempData    
      FBinRead/B=3/F=1/U refNum, wTempData

    // Sort channels
    //      
      for(ii=0; ii<ACVPixelsY; ii+=1)
        pwDataCh0[][ii] = wTempData[ii*2][p]
        pwDataCh1[][ii] = wTempData[1+ ii*2][p]      
      endfor  
    endif
    
  else  
  // Z-stack or XY-series data ...
  //
    if(DoLog)
      printf "\tReading z stack or xy time series ...\r"
    endif  
  
    if(ACVChansCorr == 1)
    // ___ Z-series, 1 channel ___________________________________________________
    //
      wChName = "Ch0"
      Make/O/N=(ACVPixelsX,ACVPixelsY,ACVImages)/B/U $wChName  
      wave/B/U pwData = $wChName    
      pwData = 0
    
      FBinRead/B=3/F=1/U refNum, pwData    
         
    elseif(ACVChansCorr == 2)
    // ___ Z-series, 2 channels __________________________________________________
    //
      Make/O/N=(ACVPixelsX,ACVPixelsY,ACVImages)/B/U Ch0
      wave/B/U pwDataCh0 = $("Ch0");
      Make/O/N=(ACVPixelsX,ACVPixelsY,ACVImages)/B/U Ch1
      wave/B/U pwDataCh1 = $("Ch1");
    
    // Create read-in buffer
    //
      Make/O/N=(ACVPixelsX*ACVChansCorr,ACVPixelsY)/B/U wTempData

    // Read in image data
    //  
      ii = 0
      do 
        FBinRead/B=3/F=1/U refNum, wTempData
        ix = 0
        do 
          pwDataCh0[ix][][ii] = wTempData[ix*2  ][q]
          pwDataCh1[ix][][ii] = wTempData[ix*2+1][q]          
          ix += 1
        while (ix < ACVPixelsX)
        ii += 1   
      while (ii < ACVImages)
    
    else
      printf "WARNING: z stacks with more than 2 channels are not supported\r"
    endif
  endif
  
// Swapping channels if requested
//  
  if ((IsSwapChs) && (ACVChansCorr == 2))
    printf "* Swapping channels (Ch0 <-> Ch1)\r"
    
    Duplicate/O Ch0, Ch0Copy
    Ch0          = Ch1
    Ch1          = Ch0Copy
    Ch0[0,3][][] = Ch0Copy[p][q][r]
    KillWaves/Z Ch0Copy
  endif
  
// Close file
//
  Close refNum
  if(DoLog)
    printf "\tFile closed.\r"
  endif  

// Clean up  
//
  KillWaves/Z wTempData
  SetDataFolder sSavDF
  if(DoLog)
    printf "\t... done.\r"
  endif  
  
  return 0
end  

// ----------------------------------------------------------------------------------------- 
// ----------------------------------------------------------------------------------------- 
// ----------------------------------------------------------------------------------------- 
function CFDFolder2WaveAndInfo (sDFName, sTargetDF, DoLog)
  string   sDFName, sTargetDF
  variable DoLog
  
// Temporary variables
//
  string   sSavDF, sDF, sTemp, sTemp2
  variable j
  
// Initialize
//  
  sSavDF  = GetDataFolder(1)
  SetDataFolder root:
  if(DoLog)
    printf "*** Convert CFD folder to wave with info ...\r"
  endif  
  
  if(!DataFolderExists(sDFName))
    printf "ERROR: data folder does not exist\r"
    SetDataFolder sSavDF
    return -1  
  endif
  SetDataFolder sDFName
  
// Get access
//
  NVAR CfNTVersion   = :Header:CfNTVersion
  SVAR CFDFName      = :Header:CFDFName
  SVAR CFDPath       = :Header:CFDPath
  NVAR CFHHdrSize    = :Header:CFHHdrSize
  NVAR CFDImgType    = :Header:CFDImgType
  NVAR ACVSplitParts = :Header:ACVSplitParts
  NVAR ACVImages     = :Header:ACVImages
  NVAR ACVImagesAvrg = :Header:ACVImagesAvrg  
  NVAR ACVChans      = :Header:ACVChans
  NVAR ACVChansCorr  = :Header:ACVChansCorr  
  NVAR ACVFlagSet    = :Header:ACVFlagSet
  NVAR ACVFlagSet_LS = :Header:ACVFlagSet_LS
  NVAR ACVCFlags     = :Header:ACVCFlags
  NVAR ACVPixelsX    = :Header:ACVPixelsX
  NVAR ACVPixelsY    = :Header:ACVPixelsY
  NVAR ACVScanDur    = :Header:ACVScanDur
  NVAR ACVRetraceDur = :Header:ACVRetraceDur
  NVAR LS_DurPerLn_s = :Header:LS_DurPerLn_s
  NVAR LS_nResCols   = :Header:LS_nResCols
  NVAR ASVScanOffsX  = :Header:ASVScanOffsX    
  NVAR ASVScanOffsY  = :Header:ASVScanOffsY        
  NVAR ASVScanRangeX = :Header:ASVScanRangeX    
  NVAR ASVScanRangeY = :Header:ASVScanRangeY     
  wave/T pwInfo      = :Header:CFH
  NVAR ACVzInc       = :Header:ACVzInc              
//wave pwACVFlagSet  = :Header:ACVFlagSet
//wave pwACVCFlags   = :Header:ACVCFlags  

// Check target folder
//  
  SetDataFolder root:
  if((!DataFolderExists(sTargetDF)) || (StringMatch(sTargetDF, "")))
    sDF = "root:"
  else
    sDF = "root:" +sTargetDF +":" 
  endif
  
// Get access to waves, rename and copy to target data folder (or to root)
//  
  SetDataFolder sDFName
  wave pwCh0         = $("Ch0")	
  Rename pwCh0, $(CFDFName +"_Ch0")  
  MoveWave pwCh0, $(sDF)
  if(ACVChansCorr == 2)  
    wave pwCh1       = $("Ch1")
    Rename pwCh1, $(CFDFName +"_Ch1")
    MoveWave pwCh1, $(sDF)    
  endif  
  
// Write important parameters to wave note
//  
  Note/K pwCh0
  sTemp  = "CFD_Version="  +Num2Str(CfNTVersion) +";"
  sTemp += "CFD_FName="    +CFDFName +";"
  sTemp2 = StrRemoveTrailingChars(pwInfo[4][1], "\00")  
  sTemp += "CFD_User="     +sTemp2 +";"  
    
  sTemp2 = StrRemoveTrailingChars(pwInfo[5][1], "\00")      
  sTemp += "CFD_RecTime="  +sTemp2 +";"  
  sTemp2 = StrRemoveTrailingChars(pwInfo[6][1], "\00")  
  sTemp += "CFD_RecDate="  +sTemp2 +";"  
  sTemp2 = StrRemoveTrailingChars(pwInfo[7][1], "\00")    
  sTemp += "CFD_GrbStart=" +sTemp2 +";"  
  sTemp2 = StrRemoveTrailingChars(pwInfo[8][1], "\00")    
  sTemp += "CFD_GrbStop="  +sTemp2 +";"  
  
  sTemp += "CFD_ImgType="  +Num2Str(CFDImgType) +";"  
  sTemp += "CFD_nChan="    +Num2Str(ACVChansCorr) +";"    
  sTemp += "CFD_dx="       +Num2Str(ACVPixelsX) +";"        
  sTemp += "CFD_dy="       +Num2Str(ACVPixelsY) +";"        
  sTemp += "CFD_nFr="      +Num2Str(ACVImages) +";"  
  sTemp += "CFD_nFrAvg="   +Num2Str(ACVImagesAvrg) +";" 
  sTemp += "CFD_SplitFr="  +Num2Str(ACVSplitParts) +";"            
  
  sTemp += "CFD_msPerLn="  +Num2Str(LS_DurPerLn_s*1000) +";"  
  sTemp += "CFD_msPerRt="  +Num2Str(ACVRetraceDur) +";"    

  sTemp += "CFD_ScnOffX="  +Num2Str(ASVScanOffsX) +";"          
  sTemp += "CFD_ScnOffY="  +Num2Str(ASVScanOffsY) +";"          
  sTemp += "CFD_ScnRgeX="  +Num2Str(ASVScanRangeX) +";"          
  sTemp += "CFD_ScnRgeY="  +Num2Str(ASVScanRangeY) +";"       
  
  sTemp2 = Num2Str(Str2Num(pwInfo[10][1])/1000)
  sTemp += "CFD_SutX0_um=" +sTemp2 +";"  
  sTemp2 = Num2Str(Str2Num(pwInfo[11][1])/1000)
  sTemp += "CFD_SutY0_um=" +sTemp2 +";"  
  sTemp2 = Num2Str(Str2Num(pwInfo[ 9][1])/1000)
  sTemp += "CFD_SutZ0_um=" +sTemp2 +";"  
  sTemp2 = Num2Str(Str2Num(pwInfo[25][1])/1000)
  sTemp += "CFD_SutX1_um=" +sTemp2 +";"  
  sTemp2 = Num2Str(Str2Num(pwInfo[26][1])/1000)
  sTemp += "CFD_SutY1_um=" +sTemp2 +";"  
  sTemp2 = Num2Str(Str2Num(pwInfo[27][1])/1000)
  sTemp += "CFD_SutZ1_um=" +sTemp2 +";"     
  
  sTemp2 = StrRemoveTrailingChars(pwInfo[23][1], "\00")        
  sTemp += "CFD_Orient="   +sTemp2 +";"  
  sTemp2 = StrRemoveTrailingChars(pwInfo[24][1], "\00")          
  sTemp += "CFD_ZoomFac="  +sTemp2 +";"  
  
  sTemp += "CFD_zIncr_nm="  +Num2Str(ACVzInc)  

//if((pwACVFlagSet & 0x0001) >0)
//  sTemp += "CFD_F_Pol=1;"
//else
//  sTemp += "CFD_F_Pol=0;"    
//endif  
//if((pwACVFlagSet & 0x0100) >0)
//  sTemp += "CFD_F_LnScn=1;"
//else
//  sTemp += "CFD_F_LnScn=0;"    
//endif  
//if((pwACVCFlags & 0x0100) >0)
//  sTemp += "CFD_F_ZStack=1;"
//else
//  sTemp += "CFD_F_ZStack=0;"    
//endif  
  Note pwCh0, CFDNoteStart +";CFD_Chn=0;" +sTemp +";" +CFDNoteEnd
  if(ACVChansCorr == 2)    
    Note pwCh1, CFDNoteStart +";CFD_Chn=1;" +sTemp +";" +CFDNoteEnd
  endif  
      
// Delete former CFD data folder
//
  SetDataFolder root:
  KillDataFolder sDFName
    
// Clean up  
//
  SetDataFolder sSavDF
  if(DoLog)
    printf "\t... done.\r"
  endif  
  return 0
end  

// ----------------------------------------------------------------------------------------- 
function RetrieveCFDWaveParams (sWaveName, ps, DoLog)
  string   sWaveName
  struct   TStruct_CFDParams &ps
  variable DoLog
  
// Temporary variables
//
  string   sTemp
  
// Initialize
//  
  if(DoLog)
    printf "*** Retrieve parameters from CFD wave ...\r"
  endif  
  
// Check wave
//
  wave pw  = $(sWaveName)
  if(!WaveExists(pw))
    printf "ERROR: Wave does not exist.\r"
    return -1
  endif   

// Fill structure
//
  sTemp = Note(pw)
  if(StrLen(sTemp) == 0)
    printf "ERROR: Wave does not a note.\r"
    return -2
  endif   
  ps.CFD_Version = Str2Num(StringByKey("CFD_Version", sTemp, "=", ";"))
  ps.CFD_FName   = StringByKey("CFD_FName", sTemp, "=", ";")
  ps.CFD_Chn     = Str2Num(StringByKey("CFD_Chn", sTemp, "=", ";"))
  ps.CFD_User    = StringByKey("CFD_User", sTemp, "=", ";")
  ps.CFD_RecTime = StringByKey("CFD_RecTime", sTemp, "=", ";")
  ps.CFD_RecDate = StringByKey("CFD_RecDate", sTemp, "=", ";")
  ps.CFD_GrbStart= Str2Num(StringByKey("CFD_GrbStart", sTemp, "=", ";"))
  ps.CFD_GrbStop = Str2Num(StringByKey("CFD_GrbStop", sTemp, "=", ";"))
  ps.CFD_ImgType = Str2Num(StringByKey("CFD_ImgType", sTemp, "=", ";"))
  ps.CFD_nChan   = Str2Num(StringByKey("CFD_nChan", sTemp, "=", ";"))
  ps.CFD_dx      = Str2Num(StringByKey("CFD_dx", sTemp, "=", ";"))
  ps.CFD_dy      = Str2Num(StringByKey("CFD_dy", sTemp, "=", ";"))
  ps.CFD_nFr     = Str2Num(StringByKey("CFD_nFr", sTemp, "=", ";"))
  ps.CFD_nFrAvg  = Str2Num(StringByKey("CFD_nFrAvg", sTemp, "=", ";"))
  ps.CFD_SplitFr = Str2Num(StringByKey("CFD_SplitFr", sTemp, "=", ";"))
  ps.CFD_msPerLn = Str2Num(StringByKey("CFD_msPerLn", sTemp, "=", ";"))
  ps.CFD_msPerRt = Str2Num(StringByKey("CFD_msPerRt", sTemp, "=", ";"))
  ps.CFD_ScnOffX = Str2Num(StringByKey("CFD_ScnOffX", sTemp, "=", ";"))
  ps.CFD_ScnOffY = Str2Num(StringByKey("CFD_ScnOffY", sTemp, "=", ";"))
  ps.CFD_ScnRgeX = Str2Num(StringByKey("CFD_ScnRgeX", sTemp, "=", ";"))
  ps.CFD_ScnRgeY = Str2Num(StringByKey("CFD_ScnRgeY", sTemp, "=", ";"))
  ps.CFD_SutX0_um= Str2Num(StringByKey("CFD_SutX0_um", sTemp, "=", ";"))
  ps.CFD_SutY0_um= Str2Num(StringByKey("CFD_SutY0_um", sTemp, "=", ";"))
  ps.CFD_SutZ0_um= Str2Num(StringByKey("CFD_SutZ0_um", sTemp, "=", ";"))
  ps.CFD_SutX1_um= Str2Num(StringByKey("CFD_SutX1_um", sTemp, "=", ";"))
  ps.CFD_SutY1_um= Str2Num(StringByKey("CFD_SutY1_um", sTemp, "=", ";"))
  ps.CFD_SutZ1_um= Str2Num(StringByKey("CFD_SutZ1_um", sTemp, "=", ";"))
  ps.CFD_Orient  = Str2Num(StringByKey("CFD_Orient", sTemp, "=", ";"))
  ps.CFD_ZoomFac = Str2Num(StringByKey("CFD_ZoomFac", sTemp, "=", ";"))
  ps.CFD_zIncr_nm= Str2Num(StringByKey("CFD_zIncr_nm", sTemp, "=", ";"))  
  
// Clean up  
//
  if(DoLog)
    printf "\t... done.\r"
  endif  
  return 0
end  

// ------------------------------------------------------------------------------- 
function/S CFDInfoStr (ps)
  struct   TStruct_CFDParams &ps

  string   s, s1
  
  sprintf s1 "file '%s'\r", ps.CFD_FName
  s    = s1  
  sprintf s1 "recorded %s at %s\r", ps.CFD_RecDate, ps.CFD_RecTime
  s   += s1
  sprintf s1 "with CfNT version %d (user '%s')\r", ps.CFD_Version, ps.CFD_User
  s   += s1
//sprintf s1 "[grab started %d, ended %d]\r", ps.CFD_GrbStart, ps.CFD_GrbStop
//s   += s1
  sprintf s1 "%dx%d pixels, %d channel(s),\r", ps.CFD_dx, ps.CFD_dy, ps.CFD_nChan 
  s   += s1
  sprintf s1 "@ %.1f ms/line with %.1f ms retrace\r", ps.CFD_msPerLn, ps.CFD_msPerRt
  s   += s1
  if(ps.CFD_nFrAvg > 1)
    sprintf s1 "%d frame(s), averaged %dx", ps.CFD_nFr, ps.CFD_nFrAvg
    s += s1  
  else  
    sprintf s1 "%d frame(s)", ps.CFD_nFr 
    s += s1
  endif  
  if(ps.CFD_SplitFr > 1)
    sprintf s1 ", split %dx\r", ps.CFD_SplitFr 
    s += s1
  else
    s += "\r"
  endif
  sprintf s1 "scan range x=%.3f y=%.3f V\r", ps.CFD_ScnRgeX, ps.CFD_ScnRgeY
  s   += s1
  sprintf s1 "scan offset x=%.3f y=%.3f V\r", ps.CFD_ScnOffX, ps.CFD_ScnOffY
  s   += s1
  sprintf s1 "scan orientation %.1f°\rzoom factor %.2f", ps.CFD_Orient, ps.CFD_ZoomFac
  s   += s1
 
//ps.CFD_ImgType 
//ps.CFD_SutX0_um
//ps.CFD_SutY0_um
//ps.CFD_SutZ0_um
//ps.CFD_SutX1_um
//ps.CFD_SutY1_um
//ps.CFD_SutZ1_um
  return s
end

// ------------------------------------------------------------------------------- 
function/S CFDTypeStr (CFDImgType)
  variable CFDImgType

  switch (CFDImgType)
    case CFDIsLineScan:
  	  return "Line scan" 
    case CFDIsZStack:
  	  return "Z-stack"
    case CFDIsXYSeries:
  	  return "XY-series"
    default:	
 	  return "***Unidentified***"
  endswitch
end  

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
// GUI
//--------------------------------------------------------------------------------
#ifndef xCFDReaderAlone
function   xInitCFDReaderGUI ()

// Create panel, if not yet existent
//
  DoWindow/F $(xCFDRead_Win)
  if(V_flag == 0)
    DoWindow/K $(xCFDRead_Win)
    Execute "xCFDReader()"
  endif
  
// Create global folder, if not yet existent
//
  if(!DataFolderExists(xGlobalPath))
    NewDataFolder/S $(xGlobalPath)
    Make/T/N=1  $(xGlobalCFDList)
    String/G $("s" +xGlobalCFDList)
    String/G $(xGlobalCurrCFDName) 
    String/G $(xGlobalCurrROIWavePath)     
    Variable/G $(xGlobalPlayStatus)
    String/G $(xGlobalParamStr1)
    String/G $(xGlobalParamStr2)    
    variable/G $(xGlobalParamVal1)        
    variable/G $(xGlobalParamVal2)            
    variable/G $(xGlobalParamVal3)        
    variable/G $(xGlobalParamVal4)            
    variable/G $(xGlobalIsSwapChs)                
        
    SetDataFolder root:
  endif

// Update ...
//  
  xCFDR_UpdateCFDList()
end
#endif

macro InitCFDReaderGUI ()
	xInitCFDReaderGUI()
endmacro

//--------------------------------------------------------------------------------
#ifndef xCFDReaderAlone
static function xCFDR_UpdateCFDList ()

  // ...
  string   sTemp, oName 
  variable j, nCFDs
  
  sTemp = ""
  j     = 0
  do
    oName = GetIndexedObjName("root:", 4, j)
    if(strlen(oName) == 0)
      break
    endif
    if(stringmatch(oName, xCFDFolderID +"*"))
      sTemp = sTemp +oName + ";"
    endif  
    j += 1
  while(1)
  
  SVAR s     = $(xGlobalPath +":s" +xGlobalCFDList)
  s          = sTemp  
  StrList2Textwave(xGlobalPath, "s" +xGlobalCFDList, xGlobalCFDList)  
  wave/T pw  = $(xGlobalPath +":" +xGlobalCFDList)  
  SVAR CFDDF = $(xGlobalPath +":" +xGlobalCurrCFDName)  
  
// Update GUI
//  
  ListBox lstCFDs win=$(xCFDRead_Win), listWave=pw
  ControlInfo/W=xCFDReader lstCFDs
  wave/T pw = $(S_DataFolder +S_Value)
  nCFDs     = DimSize(pw, 0)
  if(nCFDs > 0)
    if((V_Value+1) >= nCFDs)
      ListBox lstCFDs win=$(xCFDRead_Win), selRow=(nCFDs-1)
    endif
    Execute "TitleBox ttlCurrCFD, win=" +xCFDRead_Win +", title=\"" +pw[V_Value] +"\""
    CFDDF = pw[V_Value]
  else  
    TitleBox ttlCurrCFD, win=$(xCFDRead_Win), title=""
    CFDDF = ""    
  endif  
end  
#endif

//--------------------------------------------------------------------------------
#ifndef xCFDReaderAlone
function/S xCFDR_GetSelCFDFolderName ()

  string sPath = xGlobalPath +":" +xGlobalCurrCFDName
  SVAR   sDF   = $(sPath)
  if(SVAR_Exists(sDF))
    return sDF
  else  
    ControlInfo/W=xCFDReader lstCFDs
    wave/T pw = $(S_DataFolder +S_Value)
    if(DimSize(pw, 0) > 0)
      string/G $(sPath) = pw[V_Value]
      return pw[V_Value]  
    else
      return ""  
    endif  
  endif
end  
#endif

//--------------------------------------------------------------------------------
function/S xCFDR_GetCFDBaseName (sCFDDF, fChs)
  string   sCFDDF
  variable &fChs

  string   sCFDName
  fChs     = 0   
  sCFDName = sCFDDF[p+3,strlen(sCFDDF)-1] +"_Ch"
  if(WaveExists($("root:" +sCFDDF +":" +sCFDName +"0")))
    fChs   = fChs | 1
  endif  
  if(WaveExists($("root:" +sCFDDF +":" +sCFDName +"1"))) 
    fChs   = fChs| 2
  endif  
  return sCFDName
end      


//--------------------------------------------------------------------------------
#ifndef xCFDReaderAlone
function   xCFDR_ButtonProc(ctrlName) : ButtonControl
  string   ctrlName

  string   sSavDF, sTemp, sPath, sFName, sWavName, sDF
  variable refNum

  sSavDF  = GetDataFolder(1)
  
  strswitch (ctrlName) 
    case "btnCFDLoad": // --------------------------------------------------------
      if(xIsDebugMode > 0) 
        printf "[xCFDR_ButtonProc(btnCFDLoad)]\r"
      endif
    
    // Open dialog ...
    //
      sSavDF  = GetDataFolder(1)
      SetDataFolder root:
      Open/D/R/T=".cfd" refNum  
      if(strlen(S_fileName) == 0)
        return xErr_Canceled
      endif  
      sTemp     = S_fileName
      sPath     = PathName(sTemp)
      sFName    = BaseName(sTemp, ".cfd")
      
      if(DataFolderExists(sFName) || DataFolderExists(xCFDFolderID +sFName))
      // ERROR: Data folder with the name of the CFD already exists
      //
        xErrorMsg(xErr_DFDoesExist, sFName +"' or '" +xCFDFolderID +sFName)
        return xErr_DFDoesExist
      endif

      sWavName  = sFName +"_Ch"
      if(WaveExists($(sWavName +"0")))
      // ERROR: Wave(s) already exists
      //
        xErrorMsg(xErr_WaveAlreadyExists, sWavName +"0")      
        return xErr_WaveAlreadyExists
      endif
      
    // Load CFD, convert directly into compressed form and move into a datafolder
    // with the CFD's name
    //  
      NVAR IsSwapChs = $(xGlobalPath +":" +xGlobalIsSwapChs)
      LoadCFD(sPath, sFName, IsSwapChs, xDoLog)
      SetDataFolder root:
      NewDataFolder $(xCFDFolderID +sFName)
      CFDFolder2WaveAndInfo(sFName, xCFDFolderID +sFName, xDoLog)
      
      // ...
      xCFDR_UpdateCFDList()
      break
      
      
    case "btnUpdateCFDList": // --------------------------------------------------
      if(xIsDebugMode > 0) 
        printf "[xCFDR_ButtonProc(btnUpdateCFDList)]\r"
      endif
      xCFDR_UpdateCFDList()      
      break
      

    case "btnCFDClose": // -------------------------------------------------------
      if(xIsDebugMode > 0) 
        printf "[xCFDR_ButtonProc(btnCFDClose)]\r"
      endif
      
      ControlInfo/W=xCFDReader lstCFDs
      wave/T pw = $(S_DataFolder +S_Value)
      if(DimSize(pw, 0) == 0)
        return xErr_NothingToDo
      endif  
      sDF       = "root:" +pw[V_Value]
      TryKillAllWavesInDF("*", sDF)
      TryKillAllDFsInDF(sDF)
      KillDataFolder/Z $(sDF)
      if(DataFolderExists(sDF))
      // ERROR: Could not complete get rid of data folder
      //
        xErrorMsg(xErr_DFCouldNotBeDeleted, sDF)      
        return xErr_DFCouldNotBeDeleted
      endif
      
      xCFDR_UpdateCFDList()      
      break
      
    case "btnShowViewer": // -----------------------------------------------------
      xCFDV_UpdateViewerWins()
      break
     
  endswitch
  
  SetDataFolder $(sSavDF)
  return xErr_Ok
end      
#endif

//--------------------------------------------------------------------------------
#ifndef xCFDReaderAlone
function   xCFDR_ListBoxProc(ctrlName,row,col,event) : ListBoxControl
  string   ctrlName
  variable row
  variable col
  variable event	//1=mouse down, 2=up, 3=dbl click, 4=cell select with mouse or keys
					//5=cell select with shift key, 6=begin edit, 7=end

// Update CFD list
//
  xCFDR_UpdateCFDList()
    
  switch (event)  
    case 4:
    // Update viewer window, if it exists
    //  
#ifdef xCFDViewerPresent
      DoWindow/F $(xCFDView_ViewerPanel)
      if(!V_flag == 0)
        xCFDV_UpdateViewerWins()
      endif
#endif
      break
  endswitch    
  return xErr_Ok
end
#endif

//--------------------------------------------------------------------------------
#ifndef xCFDReaderAlone
Window xCFDReader() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=2 /W=(642,55,802,321)
	SetDrawLayer UserBack
	SetDrawEnv fname= "Tahoma",fsize= 11
	DrawText 7,35,"Current CFD:"
	SetDrawEnv fname= "Tahoma",fsize= 11
	DrawText 7,71,"Loaded CFDs:"
	Button btnCFDLoad,pos={4,3},size={153,17},proc=xCFDR_ButtonProc,title="Open CFD ..."
	Button btnCFDLoad,fColor=(32768,40704,65280)
	Button btnCFDClose,pos={4,225},size={153,17},proc=xCFDR_ButtonProc,title="Delete current CFD"
	Button btnCFDClose,fColor=(65280,32768,32768)
	Button btnShowViewer,pos={4,248},size={153,17},proc=xCFDR_ButtonProc,title="Show viewer"
	Button btnShowViewer,fColor=(65280,54528,32768)
	
	ListBox lstCFDs,pos={4,73},size={154,148},proc=xCFDR_ListBoxProc,font="Tahoma"
	ListBox lstCFDs,fSize=11,frame=2,mode= 2,selRow= 0
	Button btnUpdateCFDList,pos={115,55},size={41,16},proc=xCFDR_ButtonProc,title="Update"
	Button btnUpdateCFDList,fColor=(52224,52224,52224)
	
	TitleBox ttlCurrCFD,pos={7,36},size={56,13},title="",font="Tahoma"
	TitleBox ttlCurrCFD,fSize=11,frame=0,fColor=(0,0,39168)
EndMacro
#endif

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
function ConcatCFDs (sFPath, sF1, sF2)
  string   sFPath, sF1, sF2
  
  struct   TCFDHeaderRaw rh1
  struct   TCFDHeaderRaw rh2  
  variable refNum1, refNum2, nBytes, nChans1, nChans2
  variable  f1a, f1b, f2a, f2b, dummy, nf1, nf2, nBPerFr
  string    s1, s2, sFDest

  printf "Concatenating CFDs ...\r"
  
  
// Read 1st file
//
  Open/Z/R refNum1 as sFPath +sF1 +".cfd"
  if(V_flag != 0)
    printf "ERROR: File '%s.cfd' not found\r", sF1
    return -1
  endif  
  FBinRead/B=3/F=0 refNum1, rh1
  nChans1 = (rh1.num_chans & 1) +((rh1.num_chans & 2)/2^1)
  nBytes  = rh1.num_images *nChans1 *rh1.pixels_x *rh1.pixels_y
  
  printf "CFD#1: %s ", sF1
  printf "[%d frame(s), %d channels, %dx%d pixels]\r", rh1.num_images, nChans1, rh1.pixels_x, rh1.pixels_y

  Make/O/N=(nBytes)/B/U concattemp_Data1
  wave/B/U pwData1 = $("concattemp_Data1");
  FBinRead/B=3/F=1/U refNum1, pwData1
  Close refNum1

// Read 2nd file
//
  Open/Z/R refNum2 as sFPath +sF2 +".cfd"
  if(V_flag != 0)
    printf "ERROR: File '%s.cfd' not found\r", sF1
    return -1
  endif  
  FBinRead/B=3/F=0 refNum2, rh2
  nChans2 = (rh2.num_chans & 1) +((rh2.num_chans & 2)/2^1)
  nBytes  = rh2.num_images *nChans2 *rh2.pixels_x *rh2.pixels_y
  
  printf "CFD#2: %s ", sF2
  printf "[%d frame(s), %d channels, %dx%d pixels]\r", rh2.num_images, nChans2, rh2.pixels_x, rh2.pixels_y

  Make/O/N=(nBytes)/B/U concattemp_Data2
  wave/B/U pwData2 = $("concattemp_Data2");
  FBinRead/B=3/F=1/U refNum2, pwData2
  Close refNum2
  
// Check ...
//
  if((rh1.pixels_x != rh2.pixels_x) || (rh1.pixels_y != rh2.pixels_y) || (nChans1 != nChans2))
    printf "ERROR: CFDs have different frame size or channel numbers\r"
    
  else
  // Ask user ...
  //
    sprintf s1, "#1 (%d frames) from:", rh1.num_images
    sprintf s2, "#2 (%d frames) from:", rh2.num_images   
    f1a    = 0
    f1b    = rh1.num_images-1
    f2a    = 0
    f2b    = rh2.num_images-1
    sFDest = sFPath +sF1 +"CONCAT.cfd"
  	Prompt f1a,    s1
  	Prompt f1b,    "to:"  	
  	Prompt f2a,    s2
  	Prompt f2b,    "to:"
  	Prompt sFDest, "destination path/filename:"
  	Prompt dummy,  "mode (ignore for now):"  
	DoPrompt "ConcatCFDs", f1a, f1b, f2a, f2b, sFDest, dummy
	if(V_Flag)
	  printf "Aborted by user\r"
	  return -1		
	endif
	 
  // Check ranges ...
  //
    if((f1a < 0) || (f1b >= rh1.num_images) || (f2a < 0)  || (f2b >= rh2.num_images) || (f1a > f1b) || (f2a > f2b))
      printf "ERROR: Invalid range(s)\r"
      
    else  
    // Make wave for combined wave
    //
      nf1     = f1b -f1a +1
      nf2     = f2b -f2a +1      
      nBPerFr = nChans1 *rh1.pixels_x *rh1.pixels_y            
      nBytes  = (nf1 +nf2) *nBPerFr
      Make/O/N=(nBytes)/B/U concattemp_DataDest
      wave/B/U pwDataDest = $("concattemp_DataDest");
      
    // Copy data to destination wave
    //
      pwDataDest[0, nf1*nBPerFr-1]                        = pwData1[p +f1a*nBPerFr]
      pwDataDest[nf1*nBPerFr, nf1*nBPerFr +nf2*nBPerFr-1] = pwData2[p +f2a*nBPerFr -nf1*nBPerFr]      
    
    // Change header ...
    //
      rh1.num_images = nf1 +nf2;
      
    // Write destination file ...
    //
      Open/Z refNum1 as sFDest
      FBinWrite/B=3/F=0 refNum1, rh1
      FBinWrite/B=3/F=1/U refNum1, pwDataDest      
      Close refNum1
      
      printf "Done.\r"
    endif
  endif

// Kill temporary waves
//
  KillWaves/Z pwData1, pwData2, pwDataDest 
end

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
function xCFDStackViewer (sCFDWave)
  string sCFDWave 

  struct TStruct_CFDParams ps  

  wave pw = $(sCFDWave)
  if(!WaveExists(pw))
    return -1
  endif
  RetrieveCFDWaveParams(sCFDWave, ps, 0)
  
  DoWindow/F $("w_" +sCFDWave)
  if(V_flag == 0)
	Display /W=(499.5,125,813,479)
	AppendImage/T $(sCFDWave)
	ModifyImage $(sCFDWave) ctab= {*,*,Grays,0}
	ModifyGraph margin(left)=14,margin(bottom)=14,margin(top)=14,margin(right)=14,width={Aspect,1}
	ModifyGraph mirror=2, nticks=6, minor=1, fSize=8, standoff=0
	ModifyGraph tkLblRot(left)=90, btLen=3, tlOffset=-2
	SetAxis/A/R left
	ControlBar 45
	Slider sliStack,pos={18,0},size={260,49},proc=xCFDStack_SliderProc,fSize=9
	Slider sliStack,limits={0,(ps.CFD_nFr-1),1},value= 0,vert= 0
	Button btnLeft,pos={1,0},size={14,38},proc=xCFDStack_ButtonProc,title="<",fSize=9
	Button btnRight,pos={283,0},size={14,38},proc=xCFDStack_ButtonProc,title=">",fSize=9
	
	// ...
  endif
end

//--------------------------------------------------------------------------------
function xCFDStack_SliderProc(sa) :SliderControl
  STRUCT WMSliderAction &sa

  string sCFD

  switch(sa.eventCode)
    case -1: // kill
      break
    default:
      if(sa.eventCode & 1)
        sCFD = StringFromList(0, ImageNameList("", ";"))
        ModifyImage $(sCFD), plane=(sa.curval)
      endif
      break
  endswitch
  
  return 0
End

//--------------------------------------------------------------------------------
function xCFDStack_ButtonProc(ba) : ButtonControl
  STRUCT   WMButtonAction &ba
  
  string   sCFD 
  variable j 

  switch(ba.eventCode)
    case 2: // mouse up
      ControlInfo sliStack
      j = V_Value
      
      strswitch (ba.ctrlName)
        case "btnLeft": 
          if(j > 0)
            j -= 1
          endif  
          break

        case "btnRight": 
          j += 1
          break
      endswitch    
      sCFD = StringFromList(0, ImageNameList("", ";"))
      ModifyImage $(sCFD), plane=(j)
      Slider sliStack, value=(j)
      break
  endswitch
  return 0
end

//--------------------------------------------------------------------------------

