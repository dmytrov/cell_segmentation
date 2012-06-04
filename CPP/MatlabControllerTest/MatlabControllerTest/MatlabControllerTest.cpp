// MatlabControllerTest.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <windows.h>
#include "engine.h"

#define BUFSIZE 500

static double Areal[6] = { 1, 2, 3, 4, 5, 6 };

void MessageBoxCSTR(HWND hWnd, LPSTR text, LPSTR caption, int mode);
BOOL UnicodeToAnsi(
	LPWSTR pszwUniString, 
	LPSTR  pszAnsiBuff,
	DWORD  dwAnsiBuffSize
	);
BOOL AnsiToUnicode(
    LPSTR  pszAnsiString, 
    LPWSTR pszwUniBuff, 
    DWORD dwUniBuffSize
    );



int _tmain(int argc, _TCHAR* argv[])
{
	Engine *ep;
	mxArray *T = NULL, *a = NULL, *d = NULL;
	char buffer[BUFSIZE+1];
	double *Dreal, *Dimag;
	double time[10] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

	/*
	 * Start the MATLAB engine 
	 */
	if (!(ep = engOpen(NULL))) {
		MessageBox ((HWND)NULL, (LPCWSTR)"Can't start MATLAB engine", 
			(LPCWSTR) "Engwindemo.c", MB_OK);
		exit(-1);
	}

	/*
	 * PART I
	 *
	 * For the first half of this demonstration, we will send data
	 * to MATLAB, analyze the data, and plot the result.
	 */

	/* 
	 * Create a variable from our data
	 */
	T = mxCreateDoubleMatrix(1, 10, mxREAL);
	memcpy((char *) mxGetPr(T), (char *) time, 10*sizeof(double));

	/*
	 * Place the variable T into the MATLAB workspace
	 */
	engPutVariable(ep, "T", T);

	/*
	 * Evaluate a function of time, distance = (1/2)g.*t.^2
	 * (g is the acceleration due to gravity)
	 */
	engEvalString(ep, "D = .5.*(-9.8).*T.^2;");

	/*
	 * Plot the result
	 */
	/*
	engEvalString(ep, "plot(T,D);");
	engEvalString(ep, "title('Position vs. Time for a falling object');");
	engEvalString(ep, "xlabel('Time (seconds)');");
	engEvalString(ep, "ylabel('Position (meters)');");
	*/

	/*
	 * PART II
	 *
	 * For the second half of this demonstration, we will create another mxArray
	 * put it into MATLAB and calculate its eigen values 
	 * 
	 */
	  
	 a = mxCreateDoubleMatrix(3, 2, mxREAL);         
	 memcpy((char *) mxGetPr(a), (char *) Areal, 6*sizeof(double));
	 engPutVariable(ep, "A", a); 

	 /*
	 * Calculate the eigen value
	 */
	 engEvalString(ep, "d = eig(A*A')");

	 /*
	 * Use engOutputBuffer to capture MATLAB output. Ensure first that
	 * the buffer is always NULL terminated.
	 */
	 buffer[BUFSIZE] = '\0';
	 engOutputBuffer(ep, buffer, BUFSIZE);

	 /*
	 * the evaluate string returns the result into the
	 * output buffer.
	 */
	 engEvalString(ep, "whos");
	 MessageBoxCSTR ((HWND)NULL, buffer, "MATLAB - whos", MB_OK);
	
	 /*
	 * Get the eigen value mxArray
	 */
	 d = engGetVariable(ep, "d");
	 engClose(ep);

	 if (d == NULL) {
			MessageBoxCSTR ((HWND)NULL, "Get Array Failed", "Engwindemo.c", MB_OK);
		}
	else {		
		Dreal = mxGetPr(d);
		Dimag = mxGetPi(d);      		
		if (Dimag)
			sprintf(buffer,"Eigenval 2: %g+%gi",Dreal[1],Dimag[1]);
		else
			sprintf(buffer,"Eigenval 2: %g",Dreal[1]);
		MessageBoxCSTR ((HWND)NULL, buffer, "Engwindemo.c", MB_OK);
	    mxDestroyArray(d);
	} 

	/*
	 * We're done! Free memory, close MATLAB engine and exit.
	 */
	mxDestroyArray(T);
	mxDestroyArray(a);
	
	return 0;
}


LPWSTR AnsiToUnicodeAllocate(LPSTR text)
{
	int textLen = strlen(text);
	LPWSTR uniText = (LPWSTR) new WCHAR[strlen(text) + 1];
	int n = sizeof(WCHAR) * (strlen(text) + 1);
	AnsiToUnicode(text, uniText, n);
	return uniText;
}

void MessageBoxCSTR(HWND hWnd, LPSTR text, LPSTR caption, int mode)
{
	LPWSTR uniText = AnsiToUnicodeAllocate(text);
	LPWSTR uniCaption = AnsiToUnicodeAllocate(caption);

	MessageBox(hWnd, uniText, uniCaption, mode);
	
	delete [] uniText;
	delete [] uniCaption;
}

// ----------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------
BOOL UnicodeToAnsi(
	LPWSTR pszwUniString, 
	LPSTR  pszAnsiBuff,
	DWORD  dwAnsiBuffSize
	)
{
	int iRet = 0;
    iRet = WideCharToMultiByte(
		CP_ACP,
		0,
		pszwUniString,
		-1,
		pszAnsiBuff,
		dwAnsiBuffSize,
		NULL,
		NULL
		);
	return ( 0 != iRet );
}

// ----------------------------------------------------------------------------
//
// ----------------------------------------------------------------------------
BOOL AnsiToUnicode(
    LPSTR  pszAnsiString, 
    LPWSTR pszwUniBuff, 
    DWORD dwUniBuffSize
    )
{

	int iRet = 0;
    iRet = MultiByteToWideChar(
		CP_ACP,
		0,
		pszAnsiString,
		-1,
		pszwUniBuff,
		dwUniBuffSize
		);

	return ( 0 != iRet );
}
