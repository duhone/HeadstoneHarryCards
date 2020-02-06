/*
 *  Poker.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/22/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#pragma once

#include "FSM.h"
#include "Graphics.h"
#include "Deck.h"
#include "PokerHand.h"
#include <vector>
#include <memory>
#include "FSM.h"
#include "PokerState.h"

namespace CR
{
	namespace HHCards
	{
		class Poker : public CR::Utility::IState
		{	
		public:
			Poker();
		private:
			virtual int Process();
			virtual bool Begin();
			virtual void End();
			virtual void OnDeal() {m_fsm->Deal();}
			
			CR::Graphics::Background *m_board;
			std::vector<CR::Graphics::Sprite*> m_cardSprites;
			CR::Cards::Deck<> m_deck;
			CR::Cards::PokerHand<CR::Cards::Deck<> > m_hand;
			class PokerController *m_controller;
			CR::Utility::FSM<PokerState> m_fsm;
		};
	}
}


