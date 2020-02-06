/*
 *  CheckBox.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 11/24/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "TouchControl.h"
#include "Event.h"
#include "Graphics.h"
#include "Sound.h"
using namespace CR::Graphics;

namespace CR
{
	namespace UI
	{
		class CheckBox : public TouchControl
		{
		public:
			CheckBox(int _nSprite, int _zInitial);
			virtual ~CheckBox();
			
			// CheckBox
			bool Checked();
			void Checked(bool _value);
			
			// Sound
			void SetSoundTouchDown(const CR::Utility::Guid &soundId);
			void SetSoundDisabled(const CR::Utility::Guid &soundId);
			
			// Events
			Event CheckToggled;
			
		protected:
			// Control Methods
			virtual void OnBeforeUpdate();
			
			// TouchControl Methods
			virtual void OnTouchDown();
			virtual void OnTouchDownWhileDisabled();
			virtual void OnTouchUpInside();
			virtual void OnTouchUpOutside();
			virtual void OnSetPosition(float x, float y);
			virtual void OnSetBounds(Rect _bounds);
			
		private:
			// Graphics
			Sprite *checkSprite;
			bool m_checked;
			
			// Sounds
			std::tr1::shared_ptr<CR::Sound::ISoundFX> m_soundTouchDown;
			std::tr1::shared_ptr<CR::Sound::ISoundFX> m_soundDisabled;
		};
	}
}