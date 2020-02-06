/*
 *  TextLabel.cpp
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 11/27/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "TextLabel.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;


TextLabel::TextLabel(int _nSprite, int _zInitial) : TouchControl(), m_spriteHelper(_nSprite,true, _zInitial)
{
	fontSprite = graphics_engine->CreateSprite1(true, _zInitial);
	fontSprite->SetImage(_nSprite);
	fontSprite->SetPositionAbsolute(160, 240);
	//SetBounds(fontSprite->GetFrameWidth(), fontSprite->GetFrameHeight());
	
	m_align = AlignFontRight;
}

TextLabel::~TextLabel()
{
	fontSprite->Release();
}

void TextLabel::OnBeforeUpdate()
{	
	int xPos = offset.X();
	int yPos = 0;
	
	m_spriteHelper.Start();
	
	for (int i = 0; i < m_text.length(); i++)
	{
		m_spriteHelper.NewSprite();
		m_spriteHelper.SetPosition(xPos, offset.Y());
		m_spriteHelper.SetFrame(m_text[i] - 33);
		
		xPos += fontSprite->GetFrameWidth();
	}
	
	m_spriteHelper.End();	
}

void TextLabel::OnSetPosition(float x, float y)
{

	
	offset.X(x);
	offset.Y(y);
}

void TextLabel::OnSetBounds(Rect _bounds)
{
}

void TextLabel::SetText(std::string _text)
{
	m_text = _text;
}
