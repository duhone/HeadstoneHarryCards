#pragma once

#import <UIKit/UIKit.h>
#include <vector>
#include <list>
#include "Input_Object.h"
#include "Input_Button.h"
#include "AssetList.h"
#include "ITouchable.h"
#include "Singleton.h"

using namespace std;

namespace CR
{
	namespace Input
	{
		class InputEngine : public CR::Utility::Singleton<InputEngine>
		{
		public:
			friend class CR::Utility::Singleton<InputEngine>;
			
			InputEngine();
			virtual ~InputEngine();
			
			// To be deprecated
			bool RegisterITouchable(ITouchable* arg);
			bool UnregisterITouchable();
			void ResetControls();
			
			// new way, supports multiple ITouchables
			void AddTouchable(ITouchable *inputController);
			void RemoveTouchable(ITouchable *inputController);
			void TouchesBegan(UIView *view, NSSet *touches);
			void TouchesMoved(UIView *view, NSSet *touches);
			void TouchesEnded(UIView *view, NSSet *touches);
			void TouchesCancelled(UIView *view, NSSet *touches);
			
		private:
			// to be deprecated
			UITouch *touch;
			ITouchable *input_controller;		
			
			// New way
			list<ITouchable*> m_inputControllers;
		};
	}
}