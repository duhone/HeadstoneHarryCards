/*
 *  NumberLabel.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/12/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "RepeatedSpriteHelper.h"
#include "Point.h"
#include "TouchControl.h"
#include "Graphics.h"
#include <vector>

extern CR::Graphics::GraphicsEngine *graphics_engine;

namespace CR
{
	namespace UI
	{
		enum FontAlignment { AlignFontRight, AlignFontCenter, AlignFontLeft };
		
		class NumberLabel : public TouchControl
		{
		public:
			NumberLabel(int _nSprite, int _zInitial);
			virtual ~NumberLabel();
			
			void SetValue(int _value) { m_numValue = _value; }
			int GetValue() { return m_numValue; }
			void SetMinDigits(int _value) { m_minDigits = _value; }
			int GetMinDigits() { return m_minDigits; }
			void SetAlignment(FontAlignment _align) { m_align = _align; }
			
		protected:
			// Control Methods
			virtual void OnBeforeUpdate();
			virtual void OnBeforeRender();
			
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
			CR::Graphics::Sprite *numberSprite;
			CR::Graphics::RepeatedSpriteHelper m_spriteHelper;
			FontAlignment m_align;
			int m_minDigits;
			int m_numValue;
		};
	}
}