#pragma once

#import <UIKit/UIKit.h>
#include <vector>
#include <list>

using namespace std;
#include "Input_Object.h"
#include "Input_Button.h"

class Input_Controller
	{
	public:
		virtual void InputChanged() {};
		vector<Input_Object*> input_objects;
		
		virtual void TouchesBegan(UIView *view, NSSet *touches) {};
		virtual void TouchesMoved(UIView *view, NSSet *touches) {};
		virtual void TouchesEnded(UIView *view, NSSet *touches) {};
		virtual void TouchesCancelled(UIView *view, NSSet *touches) {};
	};

class Input_Engine
	{
	public:
		Input_Engine();
		virtual ~Input_Engine();
		
		bool RegisterInputController(Input_Controller* arg);
		bool UnregisterInputController();
		
		void Release();
		void AddRef(){ref_count++;};
		
		void TouchesBegan(UIView *view, NSSet *touches);
		void TouchesMoved(UIView *view, NSSet *touches);
		void TouchesEnded(UIView *view, NSSet *touches);
		void TouchesCancelled(UIView *view, NSSet *touches);
		
		//void DidAccelerate(UIAccelerometer *accelerometer, UIAcceleration *acceleration);
		// Input Objects
		//list<Input_Object*> input_objects;
		
		//Input_Button *CreateButton();
		//Input_Analog *CreateAnalogStick();
		
		void ResetControls();
		
	private:
		UITouch *touch;
		Input_Controller *input_controller;
		long ref_count;
	};

Input_Engine* GetInputEngine();