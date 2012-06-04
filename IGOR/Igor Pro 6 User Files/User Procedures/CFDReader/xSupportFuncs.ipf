// ------------------------------------------------------------------------------- 
// Module	:	xSupportFuncs
// Comment	:	General support functions
// Author	:	Thomas Euler
// History	:	07-26-07	Recreated
//
// ------------------------------------------------------------------------------- 
// FUNCTIONS
//
// Data folder and path functions
//
//		function/S PathMinusTrailingSep (sPath)
//		function/S PathPlusTrailingSep (sPath)
//		function/S CompletePath (sPath)
//
//		function/S StrRemoveTrailingChars (s1, sCh)
//
//   	function/S CombineFolderNames(Folder1, Folder2)
//	 	- Eventually erases ":" at end of Folder1 if there's one at the 
//		  beginning of Folder2
//
//		function/S StripPathFromList(sPathList, iP)
//
// Wave organization functions
//
//		function   CopyWavesFromDFToDF(sMask, sSrcDF, sDestDF) 
//   	function   TryKillAllWavesInDF (sMask, sDF)
//   	function   TryKillAllDFsInDF (sDF)
//   	function   FillAllWavesInDF(sMask, sDF, v)  
//
//   	function/S ListAll(matchstr, folder_str, start_str, options, index) 	
//		- e.g. print ListAll("AvSignal*", "root:", "", "", 1)
//     	=> all waves starting with "AvSignal"
//
//		function/S GetWaveNameFromPath(sWPath)
//		function/S GetPathNameFromPath(sWPath)
//
//		function/S StrList2Textwave (sPath, sListName, sTextWaveName)
//		function/S Textwave2StrList (sPath, sTextWaveName, sListName)
//
// File system functions
//
// 	 	function/S BaseName(FileName,Extension)
//		- Returns the 'basename' of a file, additionally removes any extension if
//		  Extension is "." or a specified extension
//	  	  e.g.	BaseName("D:/Path/File.ext","") -> "File.ext"
//	           	BaseName("D:/Path/File.ext",".") -> "File"
//	       		BaseName("D:/Path/File.txt",".") -> "File"
//	       		BaseName("D:/Path/File.ext",".xxx") -> "File.ext"
//	 	- Mac or Windows path
//
//   	function/S ConvMacPath2WinPath (FPath)
//   	- Converts a Mac path (with ':' separating the folders) 
//	   	  into a windows compatible path.  Needs a complete path 
//	   	  starting with the drive letter (e.g. D:Folder1:Folder2)
//
//	 	function/S FileExt(FileName)
//	 	- Returns the extension of a file (w/ or w/o path)
//	 	- Mac or Windows path
//
//	 	function/S PathName(FileName)
//	 	- Returns the path name of FileName
//
//   	function/S SelectDir ()
//   	- Open dialog to select directory; returns Windows path
//
//      function/S SelectFile (sExt, sPath)
//      - Open dialog to select a file with extension "sExt" (e.g. ".cfd"); a
//        path can be given (complete path including training "\\")
//
//      function/S ListFiles (sExt, sPath)
//   	- Returns a string list with all file names found in a directory fitting
//       the mask (see also "SelectFile(...)")
//
// Window functions
//  
//		function RemoveAllTracesFromWin (sWinName)
//		- Remove all traces from a window
//
// Other functions
//
//		function   ResetEditor()
//  	- Redefine syntax coloring
//  
//--------------------------------------------------------------------------------
// HISTORY
//  07-26-2007 (TE) Recreated
// 	11-14-2000	(TE)
//		Adapted for Igor v4.x 
//	07-24-2000	(TE)
//	-	Added BaseName, FileExt and PathName (jsaw) 
//	- 	CombineFolderNames added
//	07-19-2000	(TE)
//		File created
//
// ===============================================================================
#pragma  rtGlobals= 2	

//--------------------------------------------------------------------------------
function/S PathMinusTrailingSep (sPath)
  string   sPath
  
  if(stringmatch(sPath[StrLen(sPath)-1], ":"))
    return sPath[0, StrLen(sPath)-2]
  else
    return sPath
  endif    
end

function/S PathPlusTrailingSep (sPath)
  string   sPath
  
  if(stringmatch(sPath[StrLen(sPath)-1], ":"))
    return sPath
  else
    return sPath +":"
  endif    
end

function/S CompletePath (sPath)
  string   sPath
  
  if(!stringmatch(sPath[StrLen(sPath)-1], ":"))
    sPath += ":"
  endif
  if((!stringmatch(sPath, "root*")) && (!stringmatch(sPath[0], ":")))
    sPath  = ":" +sPath
  endif    
  if(stringmatch(sPath, ":root*"))
    sPath  = sPath[1, StrLen(sPath)-1]
  endif  
  return sPath
end

// ----------------------------------------------------------------------------------------- 
function/S StrRemoveTrailingChars (s1, sCh)
  string   s1, sCh
  
  string   sTemp2
  variable j
  
  sTemp2   = s1
  j        = StrLen(sTemp2)-1
  do
    if(StringMatch(sTemp2[j], sCh))
      j -= 1
    else
      break  
    endif  
  while(1)  
  return sTemp2[0,j]
end

//--------------------------------------------------------------------------------
function/S SelectDir ()
  string   sTemp
  
  sTemp = ""
  NewPath/O/Q $("TETEMP")
  PathInfo $("TETEMP")
  sTemp = ConvMacPath2WinPath(S_path)
  KillPath/Z $("TETEMP")  
  return sTemp  
end  

//--------------------------------------------------------------------------------
function/S SelectFile (sExt, sPath)
  string   sExt, sPath
  
  variable dummy
  
  if(strlen(sPath) > 0)
    NewPath/O/Q $("TETEMP"), sPath
    Open/D/R/P=$("TETEMP")/T=sExt dummy
    KillPath/Z $("TETEMP")        
  else  
    Open/D/R/T=sExt dummy  
  endif
  return ConvMacPath2WinPath(S_fileName)
end  

//--------------------------------------------------------------------------------
function/S ListFiles (sExt, sPath)
  string   sExt, sPath
  
  string   sTemp, sList
  variable j
  
  NewPath/Q/O $("TETEMP"), sPath
//j     = 0
//sList = ""
//do 
//  sTemp = IndexedFile($("TETEMP"), j, sExt)
//  if(strlen(sTemp) == 0)
//    break
//  else
//    sList += sTemp +";"  
//    j     += 1
//  endif
//while (1)    
    
  sList = IndexedFile($("TETEMP"), -1, sExt)    
  KillPath/Z $("TETEMP")        
  return sList
end  

//--------------------------------------------------------------------------------  
function   FillAllWavesInDF(sMask, sDF, v)  
  string   sMask, sDF
  variable v

  string   sSavDF, sTemp, sW
  variable i

  sSavDF   = GetDataFolder(1)
  if(!DataFolderExists(PathMinusTrailingSep(sDF)))
    return -1
  endif  
  SetDataFolder $(PathMinusTrailingSep(sDF))
  sTemp    = WaveList(sMask, ";", "")
  
  for(i=0; i<ItemsInList(sTemp); i+=1)
    sW         = StringFromList(i, sTemp)
    wave pw    = $(sw)
    pw         = v
  endfor  
  SetDataFolder sSavDF
  return 0
end
  
//--------------------------------------------------------------------------------  
function   CopyAllWavesFromDFToDF(sMask, sSrcDF, sDstDF) 
  string   sMask, sSrcDF, sDstDF
  
  string   sSavDF, sTemp, sW
  variable i

  sSavDF   = GetDataFolder(1)
  sSrcDF   = PathMinusTrailingSep(sSrcDF)
  sDstDF   = PathMinusTrailingSep(sDstDF)
  if(!DataFolderExists(sDstDF))
    return -1
  endif  
  if((StrLen(sSrcDF) > 0) && (DataFolderExists(sSrcDF)))
    SetDataFolder sSrcDF
  endif  
  sTemp    = WaveList(sMask, ";", "")
  SetDataFolder sSavDF
  
  for(i=0; i<ItemsInList(sTemp); i+=1)
    sW         = StringFromList(i, sTemp)
    wave pwDst = $(CompletePath(sDstDF) +sw)
    wave pwSrc = $(CompletePath(sSrcDF) +sw)
    if(WaveExists(pwDst))
    // Destination wave does already exist ...
    //
      if(DimSize(pwDst, 0) != DimSize(pwSrc, 0))
      // Destination wave differs in size, so redimension the target
      //
        Redimension/N=(DimSize(pwSrc, 0)) pwDst
      endif
      pwDst    = pwSrc
    else
    // Destimation wave does not yet exist, so duplicate
    //
      Duplicate/O  $(CompletePath(sSrcDF) +sw), $(CompletePath(sDstDF) +sw)
    endif
  endfor  
  return 0
end  

// ------------------------------------------------------------------------------- 
function   TryKillAllWavesInDF (sMask, sDF)
  string   sMask, sDF
  
  string   sSavDF, sTemp
  variable i, nwLeft
  sSavDF   = GetDataFolder(1)
  if((StrLen(sDF) > 0) && (DataFolderExists(sDF)))
    SetDataFolder sDF
  endif  
  
  sTemp    = WaveList(sMask, ";", "")
  for(i=0; i<ItemsInList(sTemp); i+=1)
    wave pw    = $(StringFromList(i, sTemp))
    KillWaves/Z pw
  endfor  
  nwLeft   = ItemsInList(WaveList(sMask, ";", ""))  
  SetDataFolder sSavDF
  return nwLeft
end

// ------------------------------------------------------------------------------- 
function   TryKillAllDFsInDF (sDF)
  string   sDF
  
  string   sSavDF, sTemp
  variable i

  if((StrLen(sDF) == 0) || (!DataFolderExists(sDF)))
    return -1
  else  
    sSavDF = GetDataFolder(1)  
    SetDataFolder sDF

    i = 0
    do
      sTemp = GetIndexedObjName(":", 4, 0)
      if (strlen(sTemp) == 0)
        break
      endif
      KillDataFolder $(sTemp)
      i += 1
    while(1)
    SetDataFolder sSavDF
  endif  
end

//--------------------------------------------------------------------------------
function RemoveAllTracesFromWin (sWinName)
  string   sWinName
  
  string   sTemp = TraceNameList(sWinName,";",1)
  variable i, r  = ItemsInList(sTemp, ";")
#ifndef xCFDReaderAlone  
  if (xIsDebugMode > 2)
    printf "[RemoveAllTracesFromWin(sWinName=%s)]\r", sWinName
    printf "  nTraces=%d, traces=%s\r", r, sTemp
  endif  
#endif  
// Remove in reverse order because the trace numbering (xxx#1) is dynamical;
// trace xxx#2 becomes xxx#1 after removing previous xxx#1 ...
//
  for(i=r-1; i>=0; i-=1)
    RemoveFromGraph/W=$sWinName $(StringFromList(i, sTemp, ";"))
  endfor
end  

//--------------------------------------------------------------------------------
function ResetEditorColoring()
  Execute "SetIgorOption colorize,doColorize=1"
  Execute "SetIgorOption colorize,keywordColor=(0,0,60000)"
  Execute "SetIgorOption colorize,commentColor=(0,30000,0)"
  Execute "SetIgorOption colorize,stringColor=(0,30000,30000)"
  Execute "SetIgorOption colorize,operationColor=(40000,10000,10000)"
  Execute "SetIgorOption colorize,functionColor=(40000,0,40000)"
end


function ResetEditor()
#ifndef xCFDReaderAlone
  if (xIsDebugMode == 1)
    print "[ResetEditor()]"
  endif  
#endif  
  ResetEditorColoring()
end

// ------------------------------------------------------------------------------- 
function/S  ConvMacPath2WinPath (FPath)
  string  FPath
  
  variable i, p, l
  
  p = 0
  do
    i = strsearch (FPath, ":", p)
    l = strlen (FPath)
    if (i == 1)
      FPath = FPath[0] +":\\" + FPath[2,l]
      p     = 2
    endif
    if (i > 1) 
      FPath = FPath[0,i-1] +"\\" + FPath[i+1,l]
    endif  
  while (i > 0)
  
  return FPath
end  
  
// ------------------------------------------------------------------------------- 
Function/s FileExt(FName)
	String FName
	
	Variable len = strlen(FName)
	Variable i = len - 1
	Do
		If (cmpstr(FName[i], ".") == 0)
			Break
		Endif
		
		i += -1
	While (i>=0)
	
	If (i>0)
		Return FName[i+1,len]
	Endif
	
	Return ""
End

// ------------------------------------------------------------------------------- 
Function/s BaseName(FName, Ext)
	String FName, Ext
	
	String tmp

	Variable len = strlen(FName)
	Variable i = len - 1
	Do
		If ((cmpstr(FName[i], "\\") == 0) || (cmpstr(FName[i], ":") == 0))
			Break
		Endif
		
		i += -1
	While (i>=0)
	
	If (i>0)
		tmp = FName[i+1, len]
	Else
		tmp = FName
	Endif
	
	Variable extlen = strlen(Ext)
	If (extlen > 0)
		len = strlen(tmp)
		i = len - 1
		Do
			If (cmpstr(tmp[i], ".") == 0)
				Break
			Endif
		
			i += -1
		While (i>=0)
	
		If (i>0)
			If (cmpstr(ext, ".") == 0)
				Return tmp[0, i-1]
			Else
				If (cmpstr(tmp[i,len], ext) == 0)
					Return tmp[0, i-1]
				Endif
			Endif
		Endif
	Else
		Return tmp
	Endif
	Return tmp
End

// ------------------------------------------------------------------------------- 
Function/s PathName(FName)
	String FName

	Variable len = strlen(FName)
	Variable i = len - 1
	Do
		If ((cmpstr(FName[i], "\\") == 0) || (cmpstr(FName[i], ":") == 0))
			Break
		Endif
		
		i += -1
	While (i>=0)
	
	If (i>0)
		Return FName[0, i]
	Endif
	
	Return ""
End

// ------------------------------------------------------------------------------- 
Function/s CombineFolderNames(Folder1, Folder2)
	String Folder1, Folder2

	Variable len = strlen(Folder1)
	Variable dp = 0
	
	If (cmpstr(Folder1[len-1, len], ":") == 0)
		dp += 1
	Endif

	If (cmpstr(Folder2[0,0], ":") == 0)
		dp += 1
	Endif
	
	If (dp == 2)
		Return Folder1[0, len-2] + Folder2
	Endif
	If (dp == 0)
		Return Folder1 + ":" + Folder2
	Endif
	Return Folder1 + Folder2
End

//--------------------------------------------------------------------------------
Function/S ListAll(matchstr,folder_str,start_str,options,index) 	
	String matchstr,folder_str,start_str,options
	Variable index
		
	Variable i
	
	String new_str="",ndf,cdf=GetDataFolder(1)
	SetDataFolder $folder_str

	If(mod(index,2)>=1)
		new_str+=WaveList(matchstr, ";",options)
	EndIf
	If(mod(index,4)>=2)
		new_str+=StringList(matchstr, ";")
	EndIf
	If(index>=4)
		new_str+=VariableList(matchstr, ";", 4)
	EndIf

	For(i=0;i<ItemsInList(new_str);i+=1)
		start_str+=folder_str+StringFromList(i, new_str)+";"
	EndFor

	For(i=0;i<CountObjects("", 4);i+=1)
		ndf=folder_str+GetIndexedObjName("", 4, i)+":"
		start_str=ListAll(matchstr,ndf,start_str,options,index)
	EndFor
	
	SetDataFolder $cdf
	Return start_str
End

// ------------------------------------------------------------------------------- 
function/S StripPathFromList(sPathList, iP)
  string   sPathList 				// paths as string list
  variable iP						// index of path to strip
  
  string   sPath, sRes
  variable i, n
  
  sPath = StringFromList(iP, sPathList)
  n     = ItemsInList(sPath, ":")
  sRes  = ""
  
  for(i=1; i<(n-1); i+=1) 
    sRes   += StringFromList(i, sPath, ":")
    if (i < (n-2))
      sRes += ":"
    endif  
  endfor
  Return sRes
end

// ------------------------------------------------------------------------------- 
function/S GetWaveNameFromPath(sWPath)
  string   sWPath
  
  return StringFromList(ItemsInList(sWPath, ":")-1, sWPath, ":")
end  

// ------------------------------------------------------------------------------- 
function/S GetPathNameFromPath(sWPath)
  string   sWPath
  
  wave pw = $(sWPath)
  if(WaveExists(pw))
    return GetWavesDataFolder(pw, 3)
  else
    return ""
  endif    
end  

// ------------------------------------------------------------------------------- 
function/S StrList2Textwave (sPath, sListName, sTextWaveName)
  string   sPath, sListName, sTextWaveName
  
  string   sSavDF
  variable i, n
  
  if(!Exists(sPath +":" +sListName)) 
    return ""
  endif
  SVAR sList    = $(sPath +":" +sListName)
  n             = ItemsInList(sList)
  sSavDF        = GetDataFolder(1)
  SetDataFolder $(sPath)
  wave/T ptw    = $(sTextWaveName) 
  if(!WaveExists(ptw))
    Make/T/O/N=(n) $(sTextWaveName)
    wave/T ptw  = $(sTextWaveName) 
  else
    Redimension/N=(n) ptw
  endif   
  for(i=0; i<n; i+=1)
    ptw[i]      = StringFromList(i, sList)
  endfor
  SetDataFolder $(sSavDF)
  return sTextWaveName
end  

// ------------------------------------------------------------------------------- 
function/S Textwave2StrList (sPath, sTextWaveName, sListName)
  string   sPath, sTextWaveName, sListName
  
  string   sSavDF
  variable i, n
  
  wave/T pwt    = $(sPath +":" +sTextWaveName) 
  if(!WaveExists(pwt)) 
    return ""
  endif
  sSavDF        = GetDataFolder(1)  
  SetDataFolder $(sPath)
  n             = DimSize(pwt, 0)
  if(!Exists(sListName))
    string/G $(sListName)
  endif    
  SVAR sList    = $(sListName)
  sList         = ""
  for(i=0; i<n; i+=1)
    if(i == 0)
      sList     = pwt[i]
    else
      sList     = sList +";" +pwt[i]  
    endif  
  endfor
  SetDataFolder $(sSavDF)
  return sListName
end  

// ------------------------------------------------------------------------------- 