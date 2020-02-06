/*
 *  PokerState.h
 *  hhcards
 *
 *  Created by Eric Duhon on 3/8/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once

#include "FSM.h"

namespace CR
{
	namespace HHCards
	{
		class PokerState : public CR::Utility::IState
		{
		public:
			virtual bool CanDeal() {return true;}
			virtual void Deal() {}
		};		
	}
}
