#pragma rtGlobals=1		// Use modern global access method.
#include <ImageSlider>

function ImageGamma(image, gammavalue)
wave image
variable gammavalue

variable xdim, ydim, zdim, minval, maxval, xcount, ycount, zcount, range, stepsize, counter, gammastep
string LUT = nameofwave(image)+"_LUT"

xdim = dimsize(image, 0)
ydim = dimsize(image, 1)
zdim = dimsize(image, 2)

minval = image[0][0]
maxval = image[0][0]

zcount = 0
do
	ycount = 0
	do
		xcount = 0
		do
			if (image[xcount][ycount][zcount] < minval)
				minval = image[xcount][ycount][zcount]
			elseif (image[xcount][ycount][zcount] > maxval)
				maxval = image[xcount][ycount][zcount]
			endif
		
		xcount +=1
		while (xcount < xdim)
	ycount +=1
	while(ycount < ydim)

zcount +=1
while (zcount < zdim)

range = maxval - minval
stepsize = 65535 / range
gammastep = 1 / range

make /o/n=(ceil(range),3) IG_tempwave

for (counter=0;counter<(ceil(range));counter+=1)

	IG_tempwave[counter][0] =  65535*(gammastep*counter)^gammavalue	//--> max = 65535!
	IG_tempwave[counter][1] = 65535*(gammastep*counter)^gammavalue
	IG_tempwave[counter][2] = 65535*(gammastep*counter)^gammavalue

endfor

	IG_tempwave[(ceil(range))][0] =  65535
	IG_tempwave[(ceil(range))][1] = 65535
	IG_tempwave[(ceil(range))][2] = 65535

duplicate /o IG_tempwave $LUT
killwaves /z IG_tempwave
end

