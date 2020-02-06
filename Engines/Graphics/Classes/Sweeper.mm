/*
 *  Sweeper.cpp
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/26/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Sweeper.h"
#include "TextureStruct.h"
#include "GraphicsEngineInternal.h"
#include "SceneGraph.h"

using namespace CR::Graphics;
using namespace CR::Math;
using namespace std;

const int NOT_ASSIGNED = 0x0ffffffff;

extern GraphicsEngineInternal *gengine;

Sweeper::Sweeper(int _z) : m_z(_z), m_texture(NULL), m_imageNumber(NOT_ASSIGNED), m_sweep(1.0f),m_transitionWidth(0), m_visible(true)
{	
	m_indices[0] = 0;
	m_indices[1] = 1;
	m_indices[2] = 2;
	m_indices[3] = 1;
	m_indices[4] = 2;
	m_indices[5] = 3;	
	m_indices[6] = 1;
	m_indices[7] = 4;
	m_indices[8] = 3;
	m_indices[9] = 4;
	m_indices[10] = 3;
	m_indices[11] = 5;
	m_indices[12] = 4;
	m_indices[13] = 6;
	m_indices[14] = 5;
	m_indices[15] = 6;
	m_indices[16] = 5;
	m_indices[17] = 7;
		
	m_vertices[0].Color.Set(255,255,255,255);
	m_vertices[1].Color.Set(255,255,255,255);
	m_vertices[2].Color.Set(255,255,255,255);
	m_vertices[3].Color.Set(255,255,255,255);
	m_vertices[4].Color.Set(255,255,255,0);
	m_vertices[5].Color.Set(255,255,255,0);
	m_vertices[6].Color.Set(255,255,255,0);
	m_vertices[7].Color.Set(255,255,255,0);
	
	gengine->GetSceneGraph()->AddSpecial(this);
}

Sweeper::~Sweeper() 
{	
	if(m_texture)
		m_texture->ReleaseTexture();
	gengine->GetSceneGraph()->RemoveSpecial(this);
}

void Sweeper::Update()
{	
	if(m_sweeping)
	{
		m_sweep += gengine->GetFrameTime();
		if(m_sweep >= m_sweepTime)
		{
			m_sweep = m_sweepTime;
			m_sweeping = false;
		}
	}
}

void Sweeper::RenderActual()
{
	float sweep = (m_sweep*(1+m_transitionWidth))/m_sweepTime;
	
	GLfloat top,bot,left,right,middle,middleLeft;
	GetUVBounds(left,right,top,bot);
	middle = left+(right-left)*sweep;
	middleLeft = middle-(right-left)*m_transitionWidth;
	middle = min(middle,right);
	middleLeft = min(middleLeft,right);
	
	m_vertices[0].U = left;
	m_vertices[0].V = bot;
	m_vertices[1].U = middleLeft;
	m_vertices[1].V = bot;
	m_vertices[2].U = left;
	m_vertices[2].V = top;
	m_vertices[3].U = middleLeft;
	m_vertices[3].V = top;
	m_vertices[4].U = middle;
	m_vertices[4].V = bot;
	m_vertices[5].U = middle;
	m_vertices[5].V = top;
	m_vertices[6].U = right;
	m_vertices[6].V = bot;
	m_vertices[7].U = right;
	m_vertices[7].V = top;
	
	int xstart = m_position.X()-512-(m_texture->width>>1);
	int ystart = 384-m_position.Y()-(m_texture->height>>1);
	float mpos = xstart + m_texture->width*sweep; 
	float mlpos = mpos-m_texture->width*m_transitionWidth; 
	mpos = min<float>(mpos,xstart+m_texture->width);
	mlpos = min<float>(mlpos,xstart+m_texture->width);
	
	m_vertices[0].X = xstart;
	m_vertices[0].Y = ystart;
	m_vertices[1].X = mlpos;
	m_vertices[1].Y = ystart;
	m_vertices[2].X = xstart;
	m_vertices[2].Y = ystart+m_texture->height;
	m_vertices[3].X = mlpos;
	m_vertices[3].Y = ystart+m_texture->height;	
	m_vertices[4].X = mpos;
	m_vertices[4].Y = ystart;
	m_vertices[5].X = mpos;
	m_vertices[5].Y = ystart+m_texture->height;	
	m_vertices[6].X = xstart+m_texture->width;
	m_vertices[6].Y = ystart;
	m_vertices[7].X = xstart+m_texture->width;
	m_vertices[7].Y = ystart+m_texture->height;
		
	glBindTexture(GL_TEXTURE_2D,m_texture->glTextureIds[0]);
		
	glEnable(GL_TEXTURE_2D);
	
    glVertexPointer(2, GL_FLOAT, sizeof(Vertex), m_vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &(m_vertices[0].U));
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(Vertex), &(m_vertices[0].Color));
    glEnableClientState(GL_COLOR_ARRAY);
	
	glDrawElements(GL_TRIANGLES, 18,GL_UNSIGNED_SHORT, m_indices);
}

void Sweeper::Release()
{
	delete this;
}

void Sweeper::SetImage(int pallette_entry)
{
	if(m_imageNumber == pallette_entry) return;
	if(m_imageNumber != NOT_ASSIGNED) m_texture->ReleaseTexture();
	m_texture = NULL;
	m_imageNumber = pallette_entry;
	if(m_imageNumber >= gengine->GetTextureEntrys())
	{
		m_imageNumber = NOT_ASSIGNED;
		return;
	}
	
	m_texture = gengine->GetTexture(m_imageNumber);
	m_texture->UseTexture();	
}

void Sweeper::GetUVBounds(GLfloat &_left,GLfloat &_right,GLfloat &_top,GLfloat &_bot)
{	
	int heightp2 = m_texture->GetNextPowerOf2(m_texture->height);
	int diffheight = heightp2-m_texture->height;
	int top = diffheight/2;
	int bot = top+m_texture->height-1;
	int left = 0;		
	int right = left + m_texture->width-1;	
		
	_top = static_cast<GLfloat>(top)/heightp2 + m_texture->m_halfv;
	_bot = static_cast<GLfloat>(bot)/heightp2 + m_texture->m_halfv;
	_left = static_cast<GLfloat>(left)/(m_texture->total_width) + m_texture->m_halfu;
	_right = static_cast<GLfloat>(right)/(m_texture->total_width) + m_texture->m_halfu;	
}
