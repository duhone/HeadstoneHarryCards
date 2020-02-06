/*
 *  TimeLabel.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/5/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "TouchControl.h"
#include "Graphics.h"
#include <vector>
#include "NumberLabel.h"
#include "RepeatedSpriteHelper.h"
//#include "UIEngine.h"

namespace CR
{
	namespace UI
	{
		class TimeLabel : public TouchControl
		{
		public:
			TimeLabel(int _nSprite, int _zInitial);
			virtual ~TimeLabel();
			
			void SetSeconds(int _value) { m_seconds = _value; }
			
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
			CR::Graphics::RepeatedSpriteHelper m_spriteHelper;
			CR::Math::PointF offset;
			
			// Graphics
			NumberLabel *hoursLabel;
			NumberLabel *minutesLabel;
			NumberLabel *secondsLabel;
			
			int m_seconds;
		};
	}
}