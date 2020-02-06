/*
 *  SpriteLabel.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/1/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "SpriteLabel.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;


SpriteLabel::SpriteLabel(int _nSprite, int _zInitial) : TouchControl()
{
	labelSprite = graphics_engine->CreateSprite1(true, _zInitial);
	labelSprite->SetImage(_nSprite);
	labelSprite->SetPositionAbsolute(160, 240);
	//SetBounds(labelSprite->GetFrameWidth(), labelSprite->GetFrameHeight());
}

SpriteLabel::~SpriteLabel()
{
	labelSprite->Release();
}

void SpriteLabel::SetFrame(int _value)
{
	labelSprite->SetFrame(_value);
}

void SpriteLabel::OnBeforeUpdate()
{
	
}

void SpriteLabel::OnSetPosition(float x, float y)
{
	// Adjust the position to the top left corner (HACK?)
	x = x + labelSprite->GetFrameWidth()/2;
	y = y + labelSprite->GetFrameHeight()/2;
	
	labelSprite->SetPositionAbsolute(x, y);
	
	// Set the bounds of this control based on its position
	Rect rect;
	rect.left = x -labelSprite->GetFrameWidth()/2;
	rect.right = x + labelSprite->GetFrameWidth()/2;
	rect.top = y -labelSprite->GetFrameHeight()/2;
	rect.bottom = y + labelSprite->GetFrameHeight()/2;
	SetBounds(rect);
}

void SpriteLabel::OnSetBounds(Rect _bounds)
{
}