/*
 *  Input_Button.h
 *  BoB
 *
 *  Created by Robert Shoemate on 1/19/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 *  Sprite Requirements:
 *	Total Frames: 2
 *	Frame 1: Up Image
 *	Frame 2: Down Image
 */
#pragma once

#include "Input_Object.h"
#include "Event.h"
#include "Sound.h"

using namespace CR::Graphics;
class Input_Button : public Input_Object
{
public:
	Input_Button();
	virtual ~Input_Button();
	
	void SetButtonBounds(float left, float top, float width, float height);
	void SetSpriteAndBounds(float left, float top, int nSprite, int zPos);
	
	void TouchesBeganImpl(UIView *view, NSSet *touches);
	void TouchesMovedImpl(UIView *view, NSSet *touches);
	void TouchesEndedImpl(UIView *view, NSSet *touches);
	void TouchesCancelledImpl(UIView *view, NSSet *touches);
	
	void SetSound(const CR::Utility::Guid &soundId)
	{
		//this->soundId = soundId;
		if (soundId.IsNull()) return;
		
		sound = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
	}
	
	void SetDisabledSound(const CR::Utility::Guid &soundId)
	{
		if (soundId.IsNull()) return;
		
		disabledSound = CR::Sound::ISound::Instance().CreateSoundFX(soundId);
	}
	
	bool IsDown() const {return isDown;}
	//void Temp(int _value) {temp = _value;}
	bool WasPressed()
	{
		// reset wasPressed whenever it is checked for
		if (wasPressed)
		{
			wasPressed = false;
			return true;
		}
		
		return false;
	}
	
	bool IsActing()
	{
		// reset isActing whenever it is checked for
		if (isActing)
		{
			isActing = false;
			return true;
		}
		
		return false;
	}
	
	
	void Reset();
	virtual void Update();
	virtual void FreeResources();
	virtual void SetPosition(int x, int y);
	void SetSoundOn(bool isOn) { soundOn = isOn; }
	Event OnClicked;
private:
	Rect bounds;
	bool isDown;
	bool isActing;
	
	bool wasPressed;
	UITouch *touch;
	Sprite* objectSprite;
	
	bool soundOn;
	
	void SetSprite(int nSprite, int zPos);
	
	//CR::Utility::Guid soundId;
	std::tr1::shared_ptr<CR::Sound::ISoundFX> sound;
	std::tr1::shared_ptr<CR::Sound::ISoundFX> disabledSound;
};