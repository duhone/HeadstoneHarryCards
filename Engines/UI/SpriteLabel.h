/*
 *  SpriteLabel.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/1/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "TouchControl.h"
#include "Graphics.h"
#include <vector>

namespace CR
{
	namespace UI
	{
		class SpriteLabel : public TouchControl
		{
		public:
			SpriteLabel(int _nSprite, int _zInitial);
			virtual ~SpriteLabel();
			
			void SetFrame(int _value);
			
		protected:
			// Control Methods
			virtual void OnBeforeUpdate();
			
			// TouchControl Methods
			virtual void OnTouchDown() {};
			virtual void OnTouchDownWhileDisabled() {};
			virtual void OnTouchUpInside() {};
			virtual void OnTouchUpOutside() {};
			virtual void OnSetPosition(float x, float y);
			virtual void OnSetBounds(Rect _bounds);
			
		private:
			// Graphics
			Sprite *labelSprite;
		};
	}
}