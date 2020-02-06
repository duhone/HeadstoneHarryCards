/*
 *  PokerController.h
 *  hhcards
 *
 *  Created by Eric Duhon on 3/7/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once
#include "Controller2.h"
#include "Event.h"
#include "Button.h"

namespace CR
{
	namespace HHCards
	{
		class PokerController : public CR::UI::Controller2
		{
		public:
			Event Deal;
			void EnableDeal(bool _enabled) {m_dealButton->Enabled(_enabled);}
		private:
			virtual Control* OnGenerateView();
			void OnDeal() {Deal();}
			CR::UI::Button *m_dealButton;
		};
	}
}
