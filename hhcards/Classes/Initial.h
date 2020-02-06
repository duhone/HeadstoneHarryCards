/*
 *  Initial.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/14/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once

#include "FSM.h"

namespace CR
{
	namespace HHCards
	{
		class Initial : public CR::Utility::IState
		{			
			virtual int Process();
		};
	}
}

