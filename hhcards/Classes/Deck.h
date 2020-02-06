/*
 *  Deck.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/8/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once
#include "Card.h"
#include <vector>
#include <algorithm>
#include "StandardLayout.h"

namespace CR
{
	namespace Cards
	{
		template<typename ST = StandardSuit,typename VT = StandardValue,template <int,typename,typename> class DeckLayout = StandardLayout>
		class Deck : public DeckLayout<1,ST,VT>
		{
		public:
			typedef Card<ST,VT> CardType;
			Deck();
			void Shuffle();
			Card<ST,VT> Deal();
		private:
			std::vector<CardType> m_deck;
			std::vector<CardType> m_dealt;
		};
		
		
		template<typename ST,typename VT,template <int,typename,typename> class  DeckLayout>
		Deck<ST,VT,DeckLayout>::Deck()
		{
			Layout(m_deck);
		}
		
		template<typename ST,typename VT,template <int,typename,typename> class  DeckLayout>
		void Deck<ST,VT,DeckLayout>::Shuffle()
		{
			std::copy(m_dealt.begin(),m_dealt.end(),std::back_inserter(m_deck));
			m_dealt.clear();
			std::random_shuffle(m_deck.begin(),m_deck.end());
		}
		
		template<typename ST,typename VT,template <int,typename,typename> class  DeckLayout>
		Card<ST,VT> Deck<ST,VT,DeckLayout>::Deal()
		{
			assert(m_deck.size());
			Card<ST,VT> card = m_deck.back();
			m_deck.pop_back();
			m_dealt.push_back(card);
			return card;
		}		
	}
}
