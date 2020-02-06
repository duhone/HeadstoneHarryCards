#ifndef HPT_TEXTURE_STRUCT_H
#define HPT_TEXTURE_STRUCT_H

#define NULL 0L

#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<OpenGLES/ES1/gl.h>
#include<OpenGLES/ES1/glext.h>
#include<limits>

namespace CR
{
	namespace Graphics
	{		
		struct TextureStruct
		{
			int width;
			int height;
			int total_width;
			int total_height;
			int padded_height;
			float m_halfu;
			float m_halfv;
		/*	int color_key_red;
			int color_key_blue;
			int color_key_green;
		*/	unsigned short color_key;
			float default_frame_rate;
			bool default_auto_animate;
			int num_frame_sets;
			int numTextures;
			int *frames_per_set;
		/*	void **data;
			void **real_data;*/
			//int data_size;
			int zlib_size;
			int zlib_pos;
			char file_name[255];
			int ref_count;
			GLuint *glTextureIds;
			int type;
			//TwGfxSurfaceType** data;
			//TwGfxSurfaceInfoType *buffer_info;
			TextureStruct()
			{
				frames_per_set = NULL;
				//data = NULL;
				ref_count = 0;
				//buffer_info = NULL;		
				glTextureIds = NULL;
			}
			~TextureStruct()
			{
				if(frames_per_set != NULL) delete[] frames_per_set;
				frames_per_set = NULL;
				FreeTexture();

			}
		public:
			void ReLoad();
			void LoadTexture(FILE *filep);
			void LoadTextureTiles(FILE *filep);
			void ReleaseTexture();
			void UseTexture();
			short old_num_frame_sets;
			int ReadPNG(char *name,FILE* &filep);
			unsigned int GetNextPowerOf2(unsigned int _original);
		private:

			void FreeTexture();
			void LoadTexture();

			static float s_totalLoadTime;
			static float s_totalLzmaTime;
			static int s_numLoads;
		};
	}
}

#endif