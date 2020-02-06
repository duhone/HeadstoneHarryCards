/*
 *  UIEngine.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#import <UIKit/UIKit.h>
#include <vector>
#include "InputEngine.h"
#include "Control.h"
#include "View.h"
#include "Button.h"
#include "SpriteLabel.h"
#include "ImageCycler.h"
#include "TimerBar2.h"
#include "NumberLabel.h"
#include "TextLabel.h"
#include "TimeLabel.h"
#include "CheckBox.h"
//#include "VMeterBar.h"
#include "Singleton.h"
using namespace std;

namespace CR
{
	namespace UI
	{
		class UIEngine : public CR::Utility::Singleton<UIEngine>, public ITouchable
		{
		public:
			friend class CR::Utility::Singleton<UIEngine>;
			
			UIEngine();
			virtual ~UIEngine();

			// Methods to be called by Apple's touch API
			bool TouchesBegan(UIView *view, NSSet *touches);
			bool TouchesMoved(UIView *view, NSSet *touches);
			void TouchesEnded(UIView *view, NSSet *touches);
			void TouchesCancelled(UIView *view, NSSet *touches);

			// Properties
			void SetRootControl(Control *touchable);
			
			// Create Methods
			Button *CreateButton(Control *_control, int _nSprite, int _zInitial);
			ImageCycler *CreateImageCycler(Control *_control, int _zInitial);
			SpriteLabel *CreateSpriteLabel(Control *_control, int _nSprite, int _zInitial);
			TimerBar2 *CreateTimerBar(Control *_control, int _zInitial);
			NumberLabel *CreateNumberLabel(Control *_control, int _nSprite, int _zInitial);
			TextLabel *CreateTextLabel(Control *_control, int _nSprite, int _zInitial);
			CheckBox *CreateCheckBox(Control *_control, int _nSprite, int _zInitial);
			TimeLabel *CreateTimeLabel(Control *_control, int _nSprite, int _zInitial);
			//VMeterBar *CreateVMeterBar(Control *_control, int _nSprite, int _zInitial);
		private:
			// Tree traversal touch methods
			bool RecTouchesBegan(Control* touchable, UIView *view, NSSet *touches);
			bool RecTouchesMoved(Control* touchable, UIView *view, NSSet *touches);
			
			void StoreTouchedItem(Control *touchable);
			
			Control *m_rootTouchable;
			vector<Control*> m_touchedItems;
		};
	}
}