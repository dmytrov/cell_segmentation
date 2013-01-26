copy /Y "Igor Pro 6 User Files\User Procedures\CellLab\CellLabRoutines.ipf" "CellLabRelease\CellLab\CellLabRoutines.ipf"
copy /Y "Igor Pro 6 User Files\User Procedures\CellLab\CellLabUI.ipf" "CellLabRelease\CellLab\CellLabUI.ipf"
copy /Y "Igor Pro 6 User Files\User Procedures\SARFIA\User Procedures\ImgAnalCP.ipf" "CellLabRelease\SARFIA\User Procedures\ImgAnalCP.ipf"
del CellLabRelease.zip
"c:\Program Files\WinRAR\winrar" a -afzip CellLabRelease.zip "CellLabRelease" 
