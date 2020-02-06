/*
 *  IITouchable.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/27/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once

#import <UIKit/UIKit.h>
#include <vector>
#include <list>
#include "Input_Object.h"
#include "Input_Button.h"
#include "AssetList.h"
using namespace std;

class ITouchable
{
public:
	ITouchable() {};
	virtual ~ITouchable() {};
	
	virtual bool TouchesBegan(UIView *view, NSSet *touches) { return false; }
	virtual bool TouchesMoved(UIView *view, NSSet *touches) { return false; }
	virtual void TouchesEnded(UIView *view, NSSet *touches) {};
	virtual void TouchesCancelled(UIView *view, NSSet *touches) {};
	
	// TODO: To be deprecated
	virtual void InputChanged() {};
	vector<Input_Object*> input_objects;
	
protected:
	
};