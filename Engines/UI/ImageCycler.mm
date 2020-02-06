/*
 *  ImageCycler.cpp
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/1/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "ImageCycler.h"
using namespace CR::UI;
using namespace std;

extern CR::Graphics::GraphicsEngine *graphics_engine;

ImageCycler::ImageCycler(int _zInitial)
{
	m_spriteZ = _zInitial;
	m_visibleSprite = 0;
}

ImageCycler::~ImageCycler()
{
	for (int i = 0; i < m_sprites.size(); i++)
		delete m_sprites[i];
}

void ImageCycler::AddImage(int _asset)
{
	Sprite *sprite = graphics_engine->CreateSprite1(false, m_spriteZ);
	sprite->SetImage(_asset);
	m_sprites.push_back(sprite);
}

void ImageCycler::Next()
{
	m_visibleSprite++;
	if (m_visibleSprite >= m_sprites.size())
		m_visibleSprite = 0;
}

void ImageCycler::Prev()
{
	m_visibleSprite--;
	if (m_visibleSprite < 0 )
		m_visibleSprite = m_sprites.size() - 1;
}

int ImageCycler::CurrentPage()
{
	return m_visibleSprite;
}

void ImageCycler::CurrentPage(int _value)
{
	m_visibleSprite = _value;
	if (m_visibleSprite > m_sprites.size() || m_visibleSprite < 0)
		m_visibleSprite = 0;
}

int ImageCycler::TotalPages()
{
	return m_sprites.size();
}

void ImageCycler::OnBeforeUpdate()
{
	//m_sprites[m_visibleSprite]->SetPositionAbsolute(bounds.left, bounds.top);
	m_sprites[m_visibleSprite]->SetPositionAbsolute(position.X(), position.Y());
}
