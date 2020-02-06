#include "TileBackgroundInternal.h"
#include "GraphicsEngineInternal.h"

using namespace CR::Graphics;

extern GraphicsEngineInternal *gengine;
//extern void GENEW(void *arg);

TileBackgroundInternal::TileBackgroundInternal() : m_color(255,255,255,255), m_lighting(false)
{
	tile_sprite = NULL;
	tile_matrix = NULL;
	tile_flags = NULL;
	x_position = 0;
	y_position = 0;
	tile_sprite = new SpriteInternal();
	//GENEW(tile_sprite);
	set_loaded = false;
	tiles = NULL;
	
	int y_step = gridWidth*vertsPerTile;
	int y_istep = gridWidth*c_indicesPerTile;
	
	for(int y = 0;y < gridHeight; y++)
	{
		for(int x = 0;x < gridWidth; x++)
		{
			m_vertices[y*y_step+x*vertsPerTile].X = x*16;
			m_vertices[y*y_step+x*vertsPerTile].Y = -y*16;
			m_vertices[y*y_step+x*vertsPerTile+1].X = x*16+16;
			m_vertices[y*y_step+x*vertsPerTile+1].Y = -y*16;
			m_vertices[y*y_step+x*vertsPerTile+2].X = x*16;
			m_vertices[y*y_step+x*vertsPerTile+2].Y = -y*16-16;
			m_vertices[y*y_step+x*vertsPerTile+3].X = x*16+16;
			m_vertices[y*y_step+x*vertsPerTile+3].Y = -y*16-16;
			
			m_indices[y*y_istep+x*c_indicesPerTile] = y*y_step+x*vertsPerTile;
			m_indices[y*y_istep+x*c_indicesPerTile+1] = y*y_step+x*vertsPerTile+1;
			m_indices[y*y_istep+x*c_indicesPerTile+2] = y*y_step+x*vertsPerTile+2;
			m_indices[y*y_istep+x*c_indicesPerTile+3] = y*y_step+x*vertsPerTile+1;
			m_indices[y*y_istep+x*c_indicesPerTile+4] = y*y_step+x*vertsPerTile+3;
			m_indices[y*y_istep+x*c_indicesPerTile+5] = y*y_step+x*vertsPerTile+2;
		}
	}
}

TileBackgroundInternal::~TileBackgroundInternal()
{
	if(tile_sprite != NULL)
	{
		tile_sprite->Release();
		tile_sprite = NULL;
	}
	if(tile_matrix != NULL) delete[] tile_matrix;
	if(tile_flags != NULL) delete[] tile_flags;
	if(tiles != NULL)
	{
		tiles->ReleaseTexture();
		delete tiles;
		tiles = NULL;
	}

}

void TileBackgroundInternal::LoadTileSet(char *name)
{
//		OutputDebugString("loading tile set");
	
//	TCHAR temps[100];
	int count;
	int color_key_red;
	int color_key_blue;
	int color_key_green;
	if(tile_matrix != NULL) delete[] tile_matrix;
	if(tile_flags != NULL) delete[] tile_flags;
	if(tiles != NULL) delete tiles;
	
	FILE* filep;
	filep = fopen(name,"rb");
	char temp[3];
	fread(temp,sizeof(char),3,filep);
	if((temp[0] != 'H') || (temp[1] != 'T') || (temp[2] != 'F'))
	{
//		MessageBox(NULL,_T("requested file is not a HTF file"),name,MB_OK);
		fclose(filep);
		return;
	}
	int tempi;
	fread(&tempi,sizeof(int),1,filep);
	if(tempi != 1)
	{
//		MessageBox(NULL,_T("requested file is a HTF file version that is not recognized by this version of the HPT Graphics Engine"),name,MB_OK);
		fclose(filep);
		return;
	}
	tiles = new TextureStruct();
	//GENEW(tiles);
//	fread(&(tiles->width),sizeof(int),1,filep);
//	fread(&(tiles->height),sizeof(int),1,filep);
	tiles->width = 16;
	tiles->height = 16;
//	tiles->total_height = tiles->height;
	fread(&(tiles->total_width),sizeof(int),1,filep);
	fread(&(tiles->total_height),sizeof(int),1,filep);
	tiles->m_halfu = 1.0f/(1.0f*(tiles->total_width))*0.375f;
	tiles->m_halfv = 1.0f/(1.0f*tiles->total_height)*0.375f;
/*	fread(&(color_key_red),sizeof(int),1,filep);
	fread(&(color_key_green),sizeof(int),1,filep);
	fread(&(color_key_blue),sizeof(int),1,filep);
*/
	color_key_red = 255;
	color_key_green = 0;
	color_key_blue = 255;


	tiles->color_key = 0;
	tiles->color_key += (color_key_red)>>3;
/*	if(gengine->GetScreenFormat() == FORMAT565)
	{*/
		tiles->color_key = (tiles->color_key)<<5;
		tiles->color_key += (color_key_green)>>3;
	//	color_key = color_key<<6;
/*	}
	else
	{
		tiles->color_key = (tiles->color_key)<<5;
		tiles->color_key += (color_key_green)>>3;
		//color_key = color_key<<5;
	}*/
	tiles->color_key = (tiles->color_key)<<5;
	tiles->color_key += (color_key_blue)>>3;
	tiles->color_key = (tiles->color_key)<<1;

	
	tiles->default_frame_rate = 1;
	tiles->default_auto_animate = false;
	fread(&(tiles->num_frame_sets),sizeof(int),1,filep);

	tiles->frames_per_set = new int[tiles->num_frame_sets];
	//GENEW(tiles->frames_per_set);
	fread(&(tiles->frames_per_set[0]),sizeof(int)*tiles->num_frame_sets,1,filep);
	//int type;
//	fread(&type,sizeof(int),1,filep);
	// 1=bmp  2=png  3=jpg
	tiles->ReadPNG(name,filep);
	tiles->LoadTextureTiles(filep);
	tiles->ref_count++;
	fread(&tile_matrix_width,sizeof(int),1,filep);
	fread(&tile_matrix_height,sizeof(int),1,filep);
	
	tile_matrix = new Tile[tile_matrix_width*tile_matrix_height];
	//GENEW(tile_matrix);
//	bool *isopaq = new bool[tiles->frames_per_set[0]];
//	GENEW(isopaq);
/*	unsigned short *tile_data_temp;
	TwGfxLockSurface(tiles->data[0],(void**)(&tile_data_temp));

	for(count = 0;count < tiles->frames_per_set[0];count++)
	{
		isopaq[count] = true;
		for(int y = 0;y < 16;y++)
		{
			for(int x = 0;x < 16; x++)
			{
				if((tile_data_temp)[tiles->total_width*y + count*16 + x] == tiles->color_key) isopaq[count] = false;
			}
		}
	}
	TwGfxUnlockSurface(tiles->data[0],true);
*/
	tile_flags = new unsigned char[tile_matrix_width*tile_matrix_height];
	//GENEW(tile_flags);
	fread(tile_matrix,sizeof(Tile),tile_matrix_width*tile_matrix_height,filep);

	for(count = 0;count < (signed)tile_matrix_width*(signed)tile_matrix_height;count++)
	{
		char tempi = 0/*tile_matrix[count].flip*/;
		if(tile_matrix[count].layer & 0x08000) tempi = tempi | HFLIP;
		if(tile_matrix[count].layer & 0x04000) tempi = tempi | VFLIP;
//		if(isopaq[tile_matrix[count].layer & 0x03fff]) tempi = tempi | HPTOPAQUE;
		tile_flags[count] = tempi;
		tile_matrix[count].layer = tile_matrix[count].layer & 0x03fff;

	}


	tile_sprite->SetTexture(tiles);

	tile_sprite->SetFrameSet(0);

	tile_sprite->SetAutoAnimate(false);

	fclose(filep);
	set_loaded = true;
	
//	delete[] isopaq;
	
//		OutputDebugString("done loading tile set");

	

}

void TileBackgroundInternal::Release()
{
	delete this;
}

void TileBackgroundInternal::ProcessColor()
{	
	int y_step = gridWidth*vertsPerTile;	
	for(int y = 0;y < gridHeight; y++)
	{
		for(int x = 0;x < gridWidth; x++)
		{
			m_vertices[y*y_step+x*vertsPerTile].Color = m_color;
			m_vertices[y*y_step+x*vertsPerTile+1].Color = m_color;
			m_vertices[y*y_step+x*vertsPerTile+2].Color = m_color;
			m_vertices[y*y_step+x*vertsPerTile+3].Color = m_color;
		}
	}	
}

void TileBackgroundInternal::Render()
{
	if(!set_loaded) return;
	
	//int x_position = this->x_position-8;
	//int y_position = this->y_position-8;
	
	int y_step = gridWidth*vertsPerTile;
	
	int startX = 0;
	if((x_position+15) < 0)
	{
		startX = ((-(x_position))>>4);
	}
	int endX = startX + 31;
	if(endX > (signed)tile_matrix_width) endX = tile_matrix_width;
	
	int startY = 0;
	if((y_position+15) < 0)
	{
		startY = ((-(y_position))>>4);
	}
	int endY = startY + 21;
	if(endY > (signed)tile_matrix_height) endY = tile_matrix_height;
	
	float rowStep = 16.0f/tiles->GetNextPowerOf2(tiles->total_height);
	float rowHeight = 15.0f/tiles->GetNextPowerOf2(tiles->total_height);
	
	int lastRow = (tiles->GetNextPowerOf2(tiles->total_height)/16)-1;
	Tile *temp2;
	Tile *temp2i = tile_matrix + startX;
	for(int y = startY;y < endY; y++)
	{
		temp2 = temp2i + tile_matrix_width*y;
		int flags_offset = tile_matrix_width*(y) + startX;
		for(int x = startX;x < endX; x++)
		{
			int row = lastRow - ((temp2->layer>>6) & 0x00fff);
			
			int tile = temp2->layer & 0x0003f;
			
			int flags = tile_flags[flags_offset];
			int texCoordsOffset = (y-startY)*y_step+(x-startX)*vertsPerTile;
			
			//float halfu = 1.0f/(1.0f*(tiles->total_width))*0.5f;
			//float halfv = 1.0f/(1.0f*tiles->total_height)*0.5f;
			
			float left = tile*(16.0f/tiles->total_width)+tiles->m_halfu;
			float right = tile*(16.0f/tiles->total_width)+(15.0f/tiles->total_width)+tiles->m_halfu;
			float top = row*rowStep+tiles->m_halfv;
			float bot = row*rowStep+rowHeight+tiles->m_halfv;
			
			if(flags&HFLIP)
			{
				m_vertices[texCoordsOffset].U = right;
				m_vertices[texCoordsOffset+1].U = left;
				m_vertices[texCoordsOffset+2].U = right;
				m_vertices[texCoordsOffset+3].U = left;
			}
			else
			{
				m_vertices[texCoordsOffset].U = left;
				m_vertices[texCoordsOffset+1].U = right;
				m_vertices[texCoordsOffset+2].U = left;
				m_vertices[texCoordsOffset+3].U = right;
			}
			
			if(flags&VFLIP)
			{
				m_vertices[texCoordsOffset].V = top;
				m_vertices[texCoordsOffset+1].V = top;
				m_vertices[texCoordsOffset+2].V = bot;
				m_vertices[texCoordsOffset+3].V = bot;
			}
			else
			{
				m_vertices[texCoordsOffset].V = bot;
				m_vertices[texCoordsOffset+1].V = bot;
				m_vertices[texCoordsOffset+2].V = top;
				m_vertices[texCoordsOffset+3].V = top;
			}
			
			temp2++;
			flags_offset++;
		}
	}	
	
	ProcessColor();
	
	glPushMatrix();
	glTranslatef(x_position-240+(startX<<4), 160-y_position-(startY<<4), -60.0f);
	
	glBindTexture(GL_TEXTURE_2D,tiles->glTextureIds[0]);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glEnable(GL_TEXTURE_2D);	
	
   /* glVertexPointer(2, GL_FLOAT, 0, gridVerts);
    glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, gridTexCoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);*/
	
	glVertexPointer(2, GL_FLOAT, sizeof(Vertex), m_vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &(m_vertices[0].U));
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(Vertex), &(m_vertices[0].Color));
    glEnableClientState(GL_COLOR_ARRAY);
	
	glDrawElements(GL_TRIANGLES, gridWidth*gridHeight*c_indicesPerTile,GL_UNSIGNED_SHORT, m_indices);
	
	
	//glDrawArrays(GL_TRIANGLES, 0, gridWidth*gridHeight*6);
	glPopMatrix();				  
}

void TileBackgroundInternal::ReLoad()
{
	tiles->ReLoad();
}


