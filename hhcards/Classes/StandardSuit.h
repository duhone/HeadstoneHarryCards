/*
 *  StandardSuit.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/8/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once
#include "assert.h"

namespace CR
{
	namespace Cards
	{
		struct StandardSuit
		{
			enum Suits
			{
				Hearts,
				Diamonds,
				Clubs,
				Spades
			};
			static int NumSuits() {return 4;}
			static Suits GetSuit(int _arg) { assert(_arg >= 0 && _arg < NumSuits()); return static_cast<Suits>(Hearts+_arg);}
			static Suits GetDefault() {return Hearts;}
			typedef Suits SuitType;
		protected:
			StandardSuit() {}
		};
	}
}
