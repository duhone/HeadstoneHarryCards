/*
 *  View.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/27/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "View.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;


View::View()
{
	backgroundSprite = NULL;
	//SetBounds(1024, 768);
	Rect rect;
	rect.top = 0;
	rect.left = 0;
	rect.right = 1024;
	rect.bottom = 768;
	SetBounds(rect);
}

View::View(int _nSprite, int _zInitial) : TouchControl()
{
	backgroundSprite = graphics_engine->CreateSprite1(false, _zInitial);
	backgroundSprite->SetImage(_nSprite);
	backgroundSprite->SetPositionAbsolute(160, 240);
	//SetBounds(backgroundSprite->GetFrameWidth(), backgroundSprite->GetFrameHeight());
}

View::~View()
{
	if (backgroundSprite != NULL)
		backgroundSprite->Release();
}

void View::OnBeforeUpdate()
{

}

void View::OnSetPosition(float x, float y)
{
	// Adjust the position to the top left corner (HACK?)
	x = x + backgroundSprite->GetFrameWidth()/2;
	y = y + backgroundSprite->GetFrameHeight()/2;
	//position.X(x);
	//position.Y(y);
	
	
	if (backgroundSprite != NULL)
	{
		backgroundSprite->SetPositionAbsolute(x, y);
	
		// Set the bounds of this control based on its position
		Rect rect;
		rect.left = x -backgroundSprite->GetFrameWidth()/2;
		rect.right = x + backgroundSprite->GetFrameWidth()/2;
		rect.top = y -backgroundSprite->GetFrameHeight()/2;
		rect.bottom = y + backgroundSprite->GetFrameHeight()/2;
		SetBounds(rect);
	}
}

void View::OnSetBounds(Rect _bounds)
{
}