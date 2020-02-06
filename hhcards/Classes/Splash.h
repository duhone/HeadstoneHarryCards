/*
 *  Splash.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/14/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#pragma once

#include "FSM.h"
#include "Graphics.h"

namespace CR
{
	namespace HHCards
	{
		class Splash : public CR::Utility::IState
		{	
			CR::Graphics::Background *m_splash;
			virtual int Process();
			virtual bool Begin();
			virtual void End();
			
		};
	}
}


