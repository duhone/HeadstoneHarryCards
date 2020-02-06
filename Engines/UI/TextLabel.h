/*
 *  TextLabel.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 11/27/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "RepeatedSpriteHelper.h"
#include "TouchControl.h"
#include "Graphics.h"
#include "NumberLabel.h"
#include <vector>
#include <string>

namespace CR
{
	namespace UI
	{
		class TextLabel : public TouchControl
		{
		public:
			TextLabel(int _nSprite, int _zInitial);
			virtual ~TextLabel();
			
			void SetText(std::string _text);
			
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
			CR::Math::PointF offset;
			CR::Graphics::RepeatedSpriteHelper m_spriteHelper;
			Sprite *fontSprite;
			FontAlignment m_align;
			std::string m_text;
		};
	}
}