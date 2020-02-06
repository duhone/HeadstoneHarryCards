/*
 *  PokerStateHold.h
 *  hhcards
 *
 *  Created by Eric Duhon on 3/28/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */


#pragma once
#include "PokerHand.h"
#include "Graphics.h"
#include "PokerState.h"

namespace CR
{
	namespace HHCards
	{
		class PokerStateHold : public PokerState
		{
		public:
			PokerStateHold(int _nextState) : m_nextState(_nextState) {}
			virtual bool Begin() {m_goNext = false; return true;}
			virtual void Deal() {m_goNext = true;}
			virtual int Process();
		private:
			int m_nextState;
			bool m_goNext;
		};
		
		
		int PokerStateHold::Process()
		{	
			if(m_goNext)
				return m_nextState;
			else
				return UNCHANGED;			
		}
	}
}
