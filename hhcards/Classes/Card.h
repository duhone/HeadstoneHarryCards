/*
 *  Card.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/8/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once
#include "StandardSuit.h"
#include "StandardValue.h"

namespace CR
{
	namespace Cards
	{
		template <typename ST = StandardSuit,typename VT = StandardValue>
		class Card
		{
		public:
			typedef typename ST::SuitType SuitType;
			typedef typename VT::ValueType ValueType;
			Card(SuitType _suit,ValueType _value) : m_suit(_suit), m_value(_value) {}
			Card()
			{
				m_suit = ST::GetDefault();
				m_value = VT::GetDefault();
			}
			SuitType Suit() const {return m_suit;}
			ValueType Value() const {return m_value;}
		private:
			SuitType m_suit;
			ValueType m_value;
		};
	}
}