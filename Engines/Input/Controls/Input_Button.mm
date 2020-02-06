/*
 *  Input_Button.cpp
 *  BoB
 *
 *  Created by Robert Shoemate on 1/19/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Input_Button.h"
#include "Sound.h"
using namespace CR::Sound;

extern CR::Graphics::GraphicsEngine *graphics_engine;

Input_Button::Input_Button()
{
	isDown = false;
	wasPressed = false;
	touch = NULL;
	bounds.top = 0;
	bounds.left = 0;
	bounds.bottom = 0;
	bounds.right = 0;
	objectSprite = 0;
	isActing = false;
	soundOn = false;
}

Input_Button::~Input_Button()
{
	FreeResources();
}

void Input_Button::FreeResources()
{
	if(	this->objectSprite != 0)
	{
		this->objectSprite->Release();
		this->objectSprite = 0;
	}
}

void Input_Button::SetButtonBounds(float left, float top, float width, float height)
{
	Rect r;
	r.top = top;
	r.left = left;
	r.bottom = height;
	r.right = width;
	bounds = r;
}

void Input_Button::SetSpriteAndBounds(float left, float top, int nSprite, int zPos)
{
	this->SetSprite(nSprite, zPos);
	
	Rect r;
	r.top = top;
	r.left = left;
	r.bottom = objectSprite->GetFrameHeight();
	r.right = objectSprite->GetFrameWidth();
	bounds = r;
}


 void Input_Button::SetSprite(int nSprite, int zPos)
 {
	 if(this->objectSprite == 0)
		 this->objectSprite = graphics_engine->CreateSprite1(false,zPos);	
	 this->objectSprite->SetImage(nSprite);
 }

void Input_Button::TouchesBeganImpl(UIView *view, NSSet *touches)
{
	CGPoint glLocation;
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			continue;
		
		glLocation = GetGLLocation(view, touch);
		
		if (glLocation.x > bounds.left && 
			glLocation.x < bounds.right + bounds.left &&
			glLocation.y > bounds.top &&
			glLocation.y < bounds.bottom + bounds.top)
		{
			isDown = true;
			isActing = true;
			this->touch = touch;
			
			if (sound)
				sound->Play();
			
		}
		else
		{
			isDown = false;
			isActing = false;
		}
	}
}

void Input_Button::TouchesMovedImpl(UIView *view, NSSet *touches)
{
	if (this->touch == NULL)
		return;
	
	CGPoint glLocation;
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			continue;
		
		glLocation = GetGLLocation(view, touch);
		
		if (glLocation.x > bounds.left && 
			glLocation.x < bounds.right + bounds.left &&
			glLocation.y > bounds.top &&
			glLocation.y < bounds.bottom + bounds.top)
		{
			isDown = true;
			isActing = true;
			this->touch = touch;
		}
		else
		{
			isDown = false;
			isActing = false;
		}
	}
}

void Input_Button::TouchesEndedImpl(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			if (isDown)
			{
				//if (soundOn)
				//	soundPlayer->PlaySound(clickon);
				
				if(OnClicked.Size() > 0)
					OnClicked();
				else
					wasPressed = true;
			}
			
			isDown = false;
			isActing = false;
			this->touch = NULL;
			break;
		}
	}
}

void Input_Button::TouchesCancelledImpl(UIView *view, NSSet *touches)
{
	for (UITouch *touch in touches)
	{
		if (touch == this->touch)
		{
			isDown = false;
			isActing = false;
			this->touch = NULL;
			break;
		}
	}
}

void Input_Button::Reset()
{
	touch = NULL;
	isDown = false;
	isActing = false;
	wasPressed = false;
}

void Input_Button::Update()
{
	if(objectSprite != 0)
	{
		//player_spr->SetPositionAbsolute(static_cast<int>(240 + nOffSet + xWorldOffset + xTransformOffset + xQuakeAttackModifier), static_cast<int>(159 + yWorldOffset + yTransformOffset + yQuakeAttackModifier));
		objectSprite->SetPositionAbsolute(bounds.left + (objectSprite->GetFrameWidth()/2), bounds.top + (objectSprite->GetFrameHeight()/2));
		if (!isDown)
		{
			//objectSprite->SetFrame(0);
			objectSprite->SetFrameSet(0);
		}
		else
		{
			//objectSprite->SetFrame(1);
			objectSprite->SetFrameSet(1);
		}
	}
}

void Input_Button::SetPosition(int x, int y)
{
	bounds.left = x;
	bounds.top = y;
}