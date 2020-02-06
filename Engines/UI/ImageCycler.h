/*
 *  ImageCycler.h
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
		class ImageCycler : public TouchControl
		{
		public:
			ImageCycler(int _zInitial);
			virtual ~ImageCycler();
			
			void AddImage(int _nSprite);
			void Next();
			void Prev();
			int CurrentPage();
			void CurrentPage(int _value);
			int TotalPages();
			
		protected:
			// Control Methods
			virtual void OnBeforeUpdate();
			
			// TouchControl Methods
			virtual void OnTouchDown() {};
			virtual void OnTouchDownWhileDisabled() {};
			virtual void OnTouchUpInside() {};
			virtual void OnTouchUpOutside() {};
			virtual void OnSetPosition(float x, float y) {};
			virtual void OnSetBounds(Rect _bounds) {};
			
		private:
			std::vector<Sprite*> m_sprites;
			int m_visibleSprite;
			int m_spriteZ;
		};
	}
}