/*
 *  PokerHand.h
 *  hhcards
 *
 *  Created by Eric Duhon on 3/1/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once

namespace CR
{
	namespace Cards
	{
		template<typename DeckType>
		class PokerHand
		{
		public:
			void Deal(DeckType &_deck);
			void Reset(); 
			bool IsHeld(int _arg) {return m_hand[_arg].m_held;}
			bool IsDealt(int _arg) {return m_hand[_arg].m_dealt;}
			void ToggleHeld(int _arg) {m_hand[_arg].m_held = !m_hand[_arg].m_held;}
			const static int NumCards = 5;
		private:
			struct Card
			{
				typename DeckType::CardType m_card;
				bool m_dealt;
				bool m_held;
				void Reset()
				{
					m_dealt = false;
					m_held = false;
				}
			};
			Card m_hand[NumCards];
		};
		
		template<typename DeckType>
		void PokerHand<DeckType>::Deal(DeckType &_deck)
		{			
			for(int i = 0; i < NumCards;++i)
			{
				if(!m_hand[i].m_held)
					m_hand[i].m_card = _deck.Deal();
			}
		}
		
		template<typename DeckType>
		void PokerHand<DeckType>::Reset()
		{
			for(int i = 0; i < NumCards;++i)
			{
				m_hand[i].Reset();
			}
		}
		
	}
}