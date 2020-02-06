
#if !defined(AFX_ASM_H__BE65BAB0_3DD3_459C_83BA_7BE6DBB52A7E__INCLUDED_)
#define AFX_ASM_H__BE65BAB0_3DD3_459C_83BA_7BE6DBB52A7E__INCLUDED_


//extern "C" void HPTMemCpyFastSARM(unsigned char *dest,unsigned char *src,int numbytes);
//extern "C" void HPTMemCpyFastXSCALE(unsigned char *dest,unsigned char *src,int extra_y);

/*#if defined XSCALE || defined SARM
extern "C" void MemCpyFastLandscape(unsigned short *dest,unsigned short *src,int extra_y);
#endif
*/




/*#if defined XSCALE
inline void MemCpyFast(unsigned char *dest,unsigned char *src,int numbytes)
{
//register int t1,t2,t3,t4,t5,t6,t7,t8;
//set up
//	unsigned long temp;
	unsigned char* tsrc = dest;
	
	int firstbytes,middlelines,lastbytes;
	firstbytes = 64-(((unsigned int)src)%64);
	if(firstbytes == 64) firstbytes = 0;
	middlelines = (numbytes-firstbytes)>>6;
	lastbytes = numbytes - (middlelines<<6) - firstbytes;

//first bytes
	for(int count = 0;count < firstbytes;count++)
	{
		(*dest) = (*src);
		dest++;
		src++;
	}

//middle lines

	HPTMemCpyFastXSCALE(dest,src,middlelines);
	dest += middlelines<<6;
	src += middlelines<<6;

//last bytes
	for(count = 0;count < lastbytes;count++)
	{
		(*dest) = (*src);
		dest++;
		src++;
	}


}

extern "C" void HPTPartialBlt(unsigned short *dest,unsigned short *src,int xsize,int ysize,unsigned int color_key,int ystep);
extern "C" void HPTPartialBltH(unsigned short *dest,unsigned short *src,int xsize,int ysize,unsigned int color_key,int ystep);
extern "C" void HPTPartialBltV(unsigned short *dest,unsigned short *src,int xsize,int ysize,unsigned int color_key,int ystep);
extern "C" void HPTPartialBltHV(unsigned short *dest,unsigned short *src,int xsize,int ysize,unsigned int color_key,int ystep);
extern "C" void HPTPartialBltO(unsigned short *dest,unsigned short *src,int xsize,int ysize,int ystep);
extern "C" void HPTPartialBltHO(unsigned short *dest,unsigned short *src,int xsize,int ysize,int ystep);
extern "C" void HPTPartialBltVO(unsigned short *dest,unsigned short *src,int xsize,int ysize,int ystep);
extern "C" void HPTPartialBltHVO(unsigned short *dest,unsigned short *src,int xsize,int ysize,int ystep);
extern "C" void HPTBlt16x16O(unsigned short* dest,unsigned short* source,int ystep);

#endif

#if defined SARM

extern "C" void PageFlip(unsigned char *dest,unsigned char *src,int extra_y);



inline void MemCpyFast(unsigned char *dest,unsigned char *src)
{
//set up
	HPTMemCpyFastXSCALE(dest,src,2400);


}
#endif

*/
//#if defined MIPS || defined X86

inline void MemCpyFast(unsigned char *dest,unsigned char *src)
{
	unsigned int *tempdest = (unsigned int*)dest;
	unsigned int *tempsrc = (unsigned int*)src;
	unsigned int temp1,temp2,temp3,temp4;
	for(int y = 0;y < 320*60;y++)
	{
		//tempdest = dest + y;
		//for(int x = 0;x < 30;x++)
		//{
			temp1 = (*tempsrc);
			temp2 = (*(tempsrc+1));
			temp3 = (*(tempsrc+2));
			temp4 = (*(tempsrc+3));
		
			(*tempdest) = temp1;
			(*(tempdest+1)) = temp2;
			(*(tempdest+2)) = temp3;
			(*(tempdest+3)) = temp4;
			tempsrc += 4;
			tempdest += 4;
		//}
		//dest = (unsigned char*)tempdest;
		//dest += extra_y;
		//tempdest += (extra_y>>2);
	}
}


/*inline void PageFlip(unsigned char *dest,unsigned char *src,int extra_y)
{
	unsigned int *tempdest = (unsigned int*)dest;
	unsigned int *tempsrc = (unsigned int*)src;
	unsigned int temp1,temp2,temp3,temp4;
	for(int y = 0;y < 320;y++)
	{
		//tempdest = dest + y;
		for(int x = 0;x < 30;x++)
		{
			temp1 = (*tempsrc);
			temp2 = (*(tempsrc+1));
			temp3 = (*(tempsrc+2));
			temp4 = (*(tempsrc+3));
		
			(*tempdest) = temp1;
			(*(tempdest+1)) = temp2;
			(*(tempdest+2)) = temp3;
			(*(tempdest+3)) = temp4;
			tempsrc += 4;
			tempdest += 4;
		}
		//dest = (unsigned char*)tempdest;
		//dest += extra_y;
		tempdest += (extra_y>>2);
	}
}

*/
/*inline void MemCpyFastLandscape(unsigned short *dest,unsigned short *src,int extra_y)
{
	unsigned short *tempdest = dest;
	for(int y = 0;y < 320;y++)
	{
		tempdest = dest - y;
		for(int x = 0;x < 240;x++)
		{
			(*tempdest) = (*src);
			src++;
			tempdest += 320 + (extra_y>>1);
		}
	}

}
*/
//#endif

//#if defined SARM || defined MIPS || defined X86

inline void HPTPartialBlt(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int color_key,int ystep)
{	
	unsigned short tempus;
	//tempd1 += x_size_full - 1;
	//bool extrapixel = (x_size & 1);
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 + (xcount_temp));
			if(tempus != color_key) *(tempf1 + (xcount_temp)) = tempus;
		}
		//if(extrapixel) *(tempf1) = *(tempd1);
		tempd1 += ystep;
		tempf1 += 480;
	
	}
}


inline void HPTPartialBltH(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int color_key,int ystep)
{	
	unsigned short tempus;
	//x_size_full--;
	//tempd1 += x_size_full;
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 - xcount_temp);
			if(tempus != color_key) *(tempf1 + xcount_temp) = tempus;
		}
		tempd1 += ystep;
		tempf1 += 480;
	
	}
}

inline void HPTPartialBltV(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int color_key,int ystep)
{	
	unsigned short tempus;
	//tempd1 += ystep*y_size;
	//tempd1 += (y_size_full*ystep) - ystep;
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 + xcount_temp);
			if(tempus != color_key) *(tempf1 + xcount_temp) = tempus;
		}
		tempd1 -= ystep;
		tempf1 += 480;
	
	}
}

inline void HPTPartialBltHV(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int color_key,int ystep)
{	
	unsigned short tempus;
	//temppd1 += (y_size_full*ystep) - (ystep) + x_size_full - 1;
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 - xcount_temp);
			if(tempus != color_key) *(tempf1 + xcount_temp) = tempus;
		}
		tempd1 -= ystep;
		tempf1 += 480;
	
	}
}

inline void HPTPartialBltO(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int ystep)
{	
	unsigned short tempus;
	//tempd1 += x_size_full - 1;
	//bool extrapixel = (x_size & 1);
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 + (xcount_temp));
			*(tempf1 + (xcount_temp)) = tempus;
		}
		//if(extrapixel) *(tempf1) = *(tempd1);
		tempd1 += ystep;
		tempf1 += 480;
	
	}
}


inline void HPTPartialBltHO(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int ystep)
{	
	unsigned short tempus;
	//tempd1 += x_size_full - 1;
	//bool extrapixel = (x_size & 1);
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 - (xcount_temp));
			*(tempf1 + (xcount_temp)) = tempus;
		}
		//if(extrapixel) *(tempf1) = *(tempd1);
		tempd1 += ystep;
		tempf1 += 480;
	
	}
}

inline void HPTPartialBltVO(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int ystep)
{	
	unsigned short tempus;
	//tempd1 += ystep*y_size;
	//tempd1 += (y_size_full*ystep) - ystep;
	//bool extrapixel = (x_size & 1);
	for(int ycount = (y_size - 1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = ((x_size)-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 + (xcount_temp));
			*(tempf1 + (xcount_temp)) = tempus;
		}
		//if(extrapixel) *(tempf1) = *(tempd1);
		tempd1 -= ystep;
		tempf1 += 480;
	
	}
}

inline void HPTPartialBltHVO(unsigned short* tempf1,unsigned short* tempd1,int x_size,int y_size,int ystep)
{	
	unsigned short tempus;
	//tempd1 += (y_size_full*ystep) - (ystep) + x_size_full - 1;
	for(int ycount = (y_size-1);ycount >= 0;ycount--)
	{
		for(int xcount_temp = (x_size-1);xcount_temp >= 0;xcount_temp--)
		{
			tempus = *(tempd1 - xcount_temp);
			*(tempf1 + xcount_temp) = tempus;
		}
		tempd1 -= ystep;
		tempf1 += 480;
	
	}
}


inline void HPTBlt16x16O(unsigned short* dest,unsigned short* source,int ystep)
{


	for(unsigned int y = 16;y > 0;y--)
	{
		*(dest) = *(source);
		*(dest + 1) = *(source + 1);
		*(dest + 2) = *(source + 2);
		*(dest + 3) = *(source + 3);
		*(dest + 4) = *(source + 4);
		*(dest + 5) = *(source + 5);
		*(dest + 6) = *(source + 6);
		*(dest + 7) = *(source + 7);
		*(dest + 8) = *(source + 8);
		*(dest + 9) = *(source + 9);
		*(dest + 10) = *(source + 10);
		*(dest + 11) = *(source + 11);
		*(dest + 12) = *(source + 12);
		*(dest + 13) = *(source + 13);
		*(dest + 14) = *(source + 14);
		*(dest + 15) = *(source + 15);
		source += ystep;
		dest += 480;
	
	}

}

//#endif





#endif
