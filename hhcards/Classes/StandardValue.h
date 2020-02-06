/*
 *  StandardValue.h
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
		struct StandardValue
		{
			enum Values
			{
				Two = 2,
				Three,
				Four,
				Five,
				Six,
				Seven,
				Eight,
				Nine,
				Ten,
				Jack,
				Queen,
				King,
				Ace
			};
			static int NumValues() {return 13;}
			static Values GetValue(int _arg) { assert(_arg >= 0 && _arg < NumValues()); return static_cast<Values>(Two+_arg);}
			static Values GetDefault() {return Two;}
			typedef Values ValueType;
		protected:
			StandardValue() {}			
		};
	}
}
