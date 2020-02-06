/*
 *  Button.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "Button.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;

Button::Button(int _nSprite, int _zInitial) : TouchControl()
{
	buttonSprite = graphics_engine->CreateSprite1(true, _zInitial);
	buttonSprite->SetImage(_nSprite);
	//SetBounds(buttonSprite->GetFrameWidth(), buttonSprite->GetFrameHeight());
	
	m_allowDragTouch = false;
}

Button::~Button()
{
	buttonSprite->Release();
}

void Button::OnBeforeUpdate()
{
	if(!m_enabled && buttonSprite->NumFrames() >= 3)
	{
		buttonSprite->SetFrame(2);
	}
	else if (m_touchDown)
	{
		buttonSprite->SetFrame(1);
	}
	else
	{
		buttonSprite->SetFrame(0);
	}
}

void Button::SetSoundTouchDown(const CR::Utility::Guid &soundId)
{
	//this->soundId = soundId;
	if (soundId.IsNull()) return;
	
	m_soundTouchDown = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
}

void Button::SetSoundDisabled(const CR::Utility::Guid &soundId)
{
	if (soundId.IsNull()) return;
	
	m_soundDisabled = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
}

void Button::OnTouchDown()
{
	if (m_soundTouchDown)
		m_soundTouchDown->Play();
	
	TouchDown();
}

void Button::OnTouchDownWhileDisabled()
{
	if (m_soundDisabled)
		m_soundDisabled->Play();
}

void Button::OnTouchUpInside()
{
	TouchUpInside();
}

void Button::OnTouchUpOutside()
{
	TouchUpOutside();
}

void Button::OnSetPosition(float x, float y)
{
	// Adjust the position to the top left corner (HACK?)
	x = x + buttonSprite->GetFrameWidth()/2;
	y = y + buttonSprite->GetFrameHeight()/2;
	//position.X(x);
	//position.Y(y);
	
	//buttonSprite->SetPositionAbsolute(x + buttonSprite->GetFrameWidth()/2, y + buttonSprite->GetFrameHeight()/2);
	buttonSprite->SetPositionAbsolute(x, y);
	
	// Set the bounds of this control based on its position
	Rect rect;
	rect.left = x -buttonSprite->GetFrameWidth()/2;
	rect.right = x + buttonSprite->GetFrameWidth()/2;
	rect.top = y -buttonSprite->GetFrameHeight()/2;
	rect.bottom = y + buttonSprite->GetFrameHeight()/2;
	SetBounds(rect);
}

void Button::OnSetBounds(Rect _bounds)
{
}