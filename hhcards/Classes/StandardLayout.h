/*
 *  StandardLayout.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/8/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once

namespace CR
{
	namespace Cards
	{
		template<int NumDecks,typename SuitType,typename ValueType>
		class StandardLayout
		{
			typedef Card<SuitType,ValueType> CardType;
		public:
			~StandardLayout() {}
			void Layout(std::vector<CardType> &_deck)
			{
				for (int i = 0; i < NumDecks; ++i)
				{
					for(int suit = 0;suit < SuitType::NumSuits();++suit)
					{
						for(int value = 0;value < ValueType::NumValues();++value)
						{
							_deck.push_back(CardType(SuitType::GetSuit(suit),ValueType::GetValue(value)));
						}						
					}
				}
			}
		};
	}
}
	