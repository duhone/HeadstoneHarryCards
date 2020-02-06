/*
 *  Load.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/22/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */


#include "FSM.h"
#include "Graphics.h"
#include "Timer.h"

namespace CR
{
	namespace HHCards
	{
		class Load : public CR::Utility::IState
		{	
			CR::Graphics::Background *m_splash;
			virtual int Process();
			virtual bool Begin();
			virtual void End();
			
			const static float c_minTime;
			CR::Utility::Timer m_timer;
		};
	}
}


