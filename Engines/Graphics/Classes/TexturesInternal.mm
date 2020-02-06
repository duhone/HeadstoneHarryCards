#include "TexturesInternal.h"
#include "GraphicsEngineInternal.h"

using namespace CR::Graphics;
extern GraphicsEngineInternal *gengine;
//extern void GENEW(void *arg);

TexturesInternal::TexturesInternal()
{
		entrys = NULL;

}

TexturesInternal::~TexturesInternal()
{
		if(entrys != NULL) delete[] entrys;

}

void TexturesInternal::LoadHGF(char *name)
{
//		OutputDebugString("loading hgf");

//	char temps[100];
	int color_key_red;
	int color_key_blue;
	int color_key_green;

	FILE* filep;
	if((filep = fopen(name,"rb")) == NULL)
	{
//		MessageBox(NULL,name,_T("could not open HFF file"),MB_OK);
		return;
	}
	char temp[3];
	fread(temp,sizeof(char),3,filep);
	if((temp[0] != 'H') || (temp[1] != 'G') || (temp[2] != 'F'))
	{
//		MessageBox(NULL,_T("requested file is not a HGF file"),name,MB_OK);
		fclose(filep);
		return;
	}
	int tempi;
	fread(&tempi,sizeof(int),1,filep);
	if(tempi != 1)
	{
//		MessageBox(NULL,_T("requested file is a HGF file version that is not recognized by this version of the HPT Graphics Engine"),name,MB_OK);
		fclose(filep);
		return;
	}
	if(entrys != NULL) delete[] entrys;

	//int nimages;
	fread(&num_entrys,sizeof(int),1,filep);

	entrys = new TextureStruct[num_entrys];
//	if(entrys == NULL) MessageBox(NULL,_T("Out of memory while loading HGF file"),_T("ERROR"),MB_OK);
		
	for(int count = 0;count < num_entrys;count++)
	{
		fread(&entrys[count].width,sizeof(int),1,filep);
		fread(&entrys[count].height,sizeof(int),1,filep);
		fread(&entrys[count].total_width,sizeof(int),1,filep);
		fread(&entrys[count].total_height,sizeof(int),1,filep);
		entrys[count].m_halfu = 1.0f/(1.0f*(entrys[count].total_width))*0.375f;
		entrys[count].m_halfv = 1.0f/(1.0f*entrys[count].total_height)*0.375f;
		fread(&color_key_red,sizeof(int),1,filep);
		fread(&color_key_green,sizeof(int),1,filep);
		fread(&color_key_blue,sizeof(int),1,filep);
		entrys[count].color_key = 0;
		entrys[count].color_key += color_key_red>>3;
/*		if(gengine->GetScreenFormat() == FORMAT565)
		{*/
			entrys[count].color_key = entrys[count].color_key<<5;
			entrys[count].color_key += color_key_green>>3;
/*		}
		else
		{
			entrys[count].color_key = entrys[count].color_key<<5;
			entrys[count].color_key += color_key_green>>3;
		}*/
		entrys[count].color_key = entrys[count].color_key<<5;
		entrys[count].color_key += color_key_blue>>3;
		entrys[count].color_key = entrys[count].color_key<<1;

		fread(&entrys[count].default_frame_rate,sizeof(int),1,filep);
		fread(&entrys[count].default_auto_animate,sizeof(bool),1,filep);
		fread(&entrys[count].num_frame_sets,sizeof(int),1,filep);
		entrys[count].frames_per_set = new int[entrys[count].num_frame_sets];
//		if(entrys[count].frames_per_set == NULL) MessageBox(NULL,_T("Out of memory while loading HGF file"),_T("ERROR"),MB_OK);
		for(int count2 = 0;count2 < entrys[count].num_frame_sets;count2++)
		{
			fread(&(entrys[count].frames_per_set[count2]),sizeof(int),1,filep);
		}
		fread(&entrys[count].type,sizeof(int),1,filep);
//		if(type == 2)
//		{
			entrys[count].ReadPNG(name,filep);
//		}
	
	}



	fclose(filep);
//	OutputDebugString("done loading hgf");
}

int TexturesInternal::GetNumEntrys()
{
	return num_entrys;
}

void TexturesInternal::ReLoad()
{
	for(int count = 0;count < num_entrys;count++)
	{
		entrys[count].ReLoad();
	}
}
