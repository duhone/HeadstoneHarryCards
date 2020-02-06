/*
 *  View.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/27/09.
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
		class View : public TouchControl
		{
		public:
			View();
			View(int _nSprite, int _zInitial);
			virtual ~View();
			
			// Events
			Event TouchDown;
			
		protected:
			// Control Methods
			virtual void OnBeforeUpdate();
			
			// TouchControl Methods
			virtual void OnTouchDown() { TouchDown(); };
			virtual void OnTouchDownWhileDisabled() {};
			virtual void OnTouchUpInside() {};
			virtual void OnTouchUpOutside() {};
			virtual void OnSetPosition(float x, float y);
			virtual void OnSetBounds(Rect _bounds);
			
		private:	
			// Graphics
			Sprite *backgroundSprite;
		};
	}
}