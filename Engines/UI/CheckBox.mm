/*
 *  CheckBox.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 11/24/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "CheckBox.h"
using namespace CR::UI;

extern CR::Graphics::GraphicsEngine *graphics_engine;

CheckBox::CheckBox(int _nSprite, int _zInitial) : TouchControl()
{
	checkSprite = graphics_engine->CreateSprite1(false, _zInitial);
	checkSprite->SetImage(_nSprite);
	//SetBounds(checkSprite->GetFrameWidth(), checkSprite->GetFrameHeight());
	
	m_allowDragTouch = false;	
	m_checked = true;
}

CheckBox::~CheckBox()
{
	checkSprite->Release();
}

bool CheckBox::Checked()
{
	return m_checked;
}

void CheckBox::Checked(bool _value)
{
	m_checked = _value;
}

void CheckBox::OnBeforeUpdate()
{
	
}

void CheckBox::SetSoundTouchDown(const CR::Utility::Guid &soundId)
{
	//this->soundId = soundId;
	if (soundId.IsNull()) return;
	
	m_soundTouchDown = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
}

void CheckBox::SetSoundDisabled(const CR::Utility::Guid &soundId)
{
	if (soundId.IsNull()) return;
	
	m_soundDisabled = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
}

void CheckBox::OnTouchDown()
{
	if (m_soundTouchDown)
		m_soundTouchDown->Play();
	
	m_checked = !m_checked;
	CheckToggled();
}

void CheckBox::OnTouchDownWhileDisabled()
{
	if (m_soundDisabled)
		m_soundDisabled->Play();
}

void CheckBox::OnTouchUpInside()
{

}

void CheckBox::OnTouchUpOutside()
{

}

void CheckBox::OnSetPosition(float x, float y)
{
	// Adjust the position to the top left corner (HACK?)
	x = x + checkSprite->GetFrameWidth()/2;
	y = y + checkSprite->GetFrameHeight()/2;
	
	checkSprite->SetPositionAbsolute(x, y);
	
	// Set the bounds of this control based on its position
	Rect rect;
	rect.left = x -checkSprite->GetFrameWidth()/2;
	rect.right = x + checkSprite->GetFrameWidth()/2;
	rect.top = y -checkSprite->GetFrameHeight()/2;
	rect.bottom = y + checkSprite->GetFrameHeight()/2;
	SetBounds(rect);
}

void CheckBox::OnSetBounds(Rect _bounds)
{
}