/*
 *  Input_Object.cpp
 *  Input
 *
 *  Created by Robert Shoemate on 1/19/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Input_Object.h"

CGPoint Input_Object::GetGLLocation(UIView *view, UITouch *touch)
{
	CGPoint location;
	
	location = [touch locationInView: view];
	//location.x = location.x;
	//location.y = location.y;
	
	// TODO: iPad HACK! - Adjusts orientation
	float tmp = location.x; 
	location.x = location.y;
	location.y = 768 - tmp;
	
	return location;
}