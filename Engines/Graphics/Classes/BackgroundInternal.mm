#include "BackgroundInternal.h"
#include "GraphicsEngineInternal.h"

using namespace CR::Graphics;
extern GraphicsEngineInternal *gengine;
//extern void GENEW(void *arg);

#define NOT_ASSIGNED 0x0ffffffff

BackgroundInternal::BackgroundInternal() : m_color(255,255,255,255), m_lighting(false)
{
	image_number = NOT_ASSIGNED;
	m_vertices[0].U = 0;
	m_vertices[0].V = 1-(1024-768)/2048.0f;
	m_vertices[1].U = 1.0f;
	m_vertices[1].V = 1-(1024-768)/2048.0f;
	m_vertices[2].U = 0;
	m_vertices[2].V = (1024-768)/2048.0f;
	m_vertices[3].U = 1.0f;
	m_vertices[3].V = (1024-768)/2048.0f;
	
	m_vertices[0].X = -512.0f;
	m_vertices[0].Y = -384.0f;
	m_vertices[1].X = 512.0f;
	m_vertices[1].Y = -384.0f;
	m_vertices[2].X = -512.0f;
	m_vertices[2].Y = 384.0f;
	m_vertices[3].X = 512.0f;
	m_vertices[3].Y = 384.0f;

}

BackgroundInternal::~BackgroundInternal()
{
	if(image_number != NOT_ASSIGNED) texture->ReleaseTexture();
}

void BackgroundInternal::SetImage(int pallette_entry)
{
	if(image_number == pallette_entry) return;
	if(image_number != NOT_ASSIGNED) texture->ReleaseTexture();
	image_number = pallette_entry;
	texture = gengine->GetTexture(pallette_entry);
	texture->UseTexture();
}

void BackgroundInternal::Release()
{
	delete this;
}

void BackgroundInternal::Render()
{	
	ProcessColor();
	
	//glPushMatrix();
	//glScalef(240, 160, 1);
	//glTranslatef(0, 0, -80.0f);
	glBindTexture(GL_TEXTURE_2D, texture->glTextureIds[0]);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glEnable(GL_TEXTURE_2D);
	
    glVertexPointer(2, GL_FLOAT, sizeof(Vertex), m_vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &(m_vertices[0].U));
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(Vertex), &(m_vertices[0].Color));
	glEnableClientState(GL_COLOR_ARRAY);
		
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	//glPopMatrix();
}


void BackgroundInternal::ReLoad()
{
	texture->ReLoad();
}


void BackgroundInternal::ProcessColor()
{
	m_vertices[0].Color = m_color;
	m_vertices[1].Color = m_color;
	m_vertices[2].Color = m_color;
	m_vertices[3].Color = m_color;
}