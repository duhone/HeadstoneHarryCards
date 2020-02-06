/*
 *  TouchControl.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "Control.h"
#include <vector>
using namespace std;

namespace CR
{
	namespace UI
	{
		class TouchControl : public Control
		{
		public:
			TouchControl();
			virtual ~TouchControl();
			
			virtual bool TouchesBegan(UIView *view, NSSet *touches);
			virtual bool TouchesMoved(UIView *view, NSSet *touches);
			virtual void TouchesEnded(UIView *view, NSSet *touches);
			virtual void TouchesCancelled(UIView *view, NSSet *touches);
			
		protected:
			// Custom Methods (Event Invokers)
			virtual void OnTouchDown() = 0;
			virtual void OnTouchDownWhileDisabled() = 0;
			virtual void OnTouchUpInside() = 0;
			virtual void OnTouchUpOutside() = 0;
			virtual void OnSetPosition(float x, float y) = 0;
			virtual void OnSetBounds(Rect _bounds) = 0;
			
			bool m_touchDown;
			bool m_allowDragTouch;
			
		private:
			UITouch *touch;
		};
	}
}