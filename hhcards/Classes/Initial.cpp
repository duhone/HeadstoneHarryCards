/*
 *  Initial.cpp
 *  hhcards
 *
 *  Created by Eric Duhon on 2/14/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#include "Initial.h"
#include "Game.h"

using namespace CR::HHCards;

int Initial::Process()
{
	Game::Instance().Graphics()->SetClearScreen(true);
	Game::Instance().Graphics()->SetBackgroundColor(0,0,0);
	return NEXT|DELAYED;
}