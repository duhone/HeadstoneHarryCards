/*
 *  PokerStateInitial.h
 *  hhcards
 *
 *  Created by Eric Duhon on 3/7/10.
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
		template<typename DeckType>
		class PokerStateInitial : public PokerState
		{
		public:
			PokerStateInitial(CR::Cards::PokerHand<DeckType> &_hand,std::vector<CR::Graphics::Sprite*> &_sprites);
			virtual void Deal() {m_goNext = true;}
			virtual int Process();

		private:
			virtual bool Begin();
			CR::Cards::PokerHand<DeckType> &m_hand;
			std::vector<CR::Graphics::Sprite*> &m_sprites;
			bool m_goNext;
		};
		
		template<typename DeckType>
		PokerStateInitial<DeckType>::PokerStateInitial(CR::Cards::PokerHand<DeckType> &_hand,std::vector<CR::Graphics::Sprite*> &_sprites) : 
			m_hand(_hand), m_sprites(_sprites)
		{
			
		}
		
		template<typename DeckType>
		bool PokerStateInitial<DeckType>::Begin()
		{
			m_hand.Reset();
			
			for(int i = 0;i < m_sprites.size(); ++i)
			{
				m_sprites[i]->Visible(false);
			}
			
			m_goNext = false;
			
			return true;
		}
		
		template<typename DeckType>
		int PokerStateInitial<DeckType>::Process()
		{	
			if(m_goNext)
				return NEXT;
			else
				return UNCHANGED;			
		}
		
	}
}
