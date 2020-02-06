/*
 *  Control.h
 *  Bumble Tales
 *
 *  Created by Robert Shoemate on 7/9/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#import <UIKit/UIKit.h>
#include <vector>
#include "ITouchable.h"
#include "Point.h"
#include "Event.h"

using namespace std;

namespace CR
{
	namespace UI
	{
		class Control : public ITouchable
		{
		public:
			virtual ~Control();
			
			// Return true if a touch was detected within this Control's bounds
			virtual bool TouchesBegan(UIView *view, NSSet *touches) = 0;
			virtual bool TouchesMoved(UIView *view, NSSet *touches) = 0;
			virtual void TouchesEnded(UIView *view, NSSet *touches) = 0;
			virtual void TouchesCancelled(UIView *view, NSSet *touches) = 0;
			
			virtual vector<Control*> &GetChildren();
			
			virtual void Parent(Control *parent);
			virtual Control* Parent();
			
			void SetPosition(float x, float y);
			CR::Math::PointF GetPosition();
			CR::Math::PointF GetAbsolutePosition();
			
			void SetBounds(Rect _bounds);

			//void SetBounds(float left, top, width, height);
			
			bool Enabled();
			void Enabled(bool _enabled);
			
			bool Visible();
			void Visible(bool _visible);
			
			bool Paused();
			void Paused(bool _paused);
			
			bool IgnoreTouches();
			void IgnoreTouches(bool _ignoreTouches);
			
			void Update();
			
			// Events
			Event BeforeUpdate;
			
		protected:
			Control();
			
			// Protected Methods
			virtual void UpdateControlTree();
			
			// Event Invokers
			virtual void OnSetPosition(float x, float y) = 0;
			virtual void OnSetBounds(Rect _bounds) = 0;
			//virtual void OnSetBounds(float left, float top, float width, float height) {}
			virtual void OnBeforeUpdate() = 0;
			virtual void OnPaused(bool _paused) {};
			
			Control *m_parent;
			vector<Control*> m_children;
			CR::Math::PointF position;
			Rect bounds;
			bool m_enabled;
			bool m_visible;
			bool m_paused;
			bool m_ignoreTouches;
			
		private:
			void DeleteControlTree();
		};
	}
}