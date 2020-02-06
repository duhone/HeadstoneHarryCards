/*
 *  QuadImpl.cpp
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/16/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "QuadImpl.h"
#include "GraphicsEngineInternal.h"
#include "SceneGraph.h"

using namespace CR::Graphics;

extern GraphicsEngineInternal *gengine;

QuadImpl::QuadImpl(int _zInitial) : z(_zInitial), m_visible(true)
{
	gengine->GetSceneGraph()->AddSpecial(this);
	m_vertices[0].X = 0;
	m_vertices[0].Y = 0;
	m_vertices[1].X = 1;
	m_vertices[1].Y = 0;	
	m_vertices[2].X = 0;
	m_vertices[2].Y = 1;	
	m_vertices[3].X = 1;
	m_vertices[3].Y = 1;
	
	m_vertices[0].Color.Red(0);
	m_vertices[0].Color.Green(0);
	m_vertices[0].Color.Blue(0);
	m_vertices[0].Color.Alpha(255);	
	m_vertices[1].Color.Red(0);
	m_vertices[1].Color.Green(0);
	m_vertices[1].Color.Blue(0);
	m_vertices[1].Color.Alpha(255);		
	m_vertices[2].Color.Red(0);
	m_vertices[2].Color.Green(0);
	m_vertices[2].Color.Blue(0);
	m_vertices[2].Color.Alpha(255);		
	m_vertices[3].Color.Red(0);
	m_vertices[3].Color.Green(0);
	m_vertices[3].Color.Blue(0);
	m_vertices[3].Color.Alpha(255);		
	
	m_indices[0] = 0;
	m_indices[1] = 1;
	m_indices[2] = 2;
	m_indices[3] = 1;
	m_indices[4] = 3;
	m_indices[5] = 2;
	
}

QuadImpl::~QuadImpl()
{
	gengine->GetSceneGraph()->RemoveSpecial(this);
	
}

void QuadImpl::Update()
{
	
}

void QuadImpl::RenderActual()
{
	glDisable(GL_TEXTURE_2D);
	
    glVertexPointer(2, GL_FLOAT, sizeof(VertexPC), m_vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(VertexPC), &(m_vertices[0].Color));
    glEnableClientState(GL_COLOR_ARRAY);
	
	//glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	glDrawElements(GL_TRIANGLES, 6,GL_UNSIGNED_SHORT, m_indices);
	
}

void QuadImpl::Release()
{
	delete this;
}
