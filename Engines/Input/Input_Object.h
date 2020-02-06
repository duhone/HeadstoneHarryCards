/*
 *  Input_Object.h
 *  Input
 *
 *  Created by Robert Shoemate on 1/19/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#include "graphics.h"

class Input_Object
	{
	public:	
		Input_Object() : m_disabled(false)
		{
			
		}
		
		virtual ~Input_Object()
		{
		}
		
		void TouchesBegan(UIView *view, NSSet *touches)
		{
			if(!m_disabled)
				TouchesBeganImpl(view,touches);
		}
		void TouchesMoved(UIView *view, NSSet *touches)
		{
			if(!m_disabled)
				TouchesMovedImpl(view,touches);			
		}
		void TouchesEnded(UIView *view, NSSet *touches)
		{
			if(!m_disabled)
				TouchesEndedImpl(view,touches);			
		}
		void TouchesCancelled(UIView *view, NSSet *touches)
		{
			if(!m_disabled)
				TouchesCancelledImpl(view,touches);			
		}
		bool Disabled() const {return m_disabled;}
		void Disabled(bool _disabled) 
		{
			if(!_disabled && m_disabled)
				Reset();
			m_disabled = _disabled;
		}
		
		virtual void TouchesBeganImpl(UIView *view, NSSet *touches) = 0;
		virtual void TouchesMovedImpl(UIView *view, NSSet *touches) = 0;
		virtual void TouchesEndedImpl(UIView *view, NSSet *touches) = 0;
		virtual void TouchesCancelledImpl(UIView *view, NSSet *touches) = 0;
		virtual void Reset() { }
		
		CGPoint GetGLLocation(UIView *view, UITouch *touch);

		//void SetSprite(int nSprite);
		virtual void Update(){}
		virtual void Render() = 0;
		virtual void FreeResources() { };
	protected:
		bool m_disabled;
	};