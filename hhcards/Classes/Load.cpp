/*
 *  Load.cpp
 *  hhcards
 *
 *  Created by Eric Duhon on 2/22/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#include "Load.h"
#include "Game.h"
#include "AssetList.h"

using namespace CR::HHCards;

const float Load::c_minTime = 0.0;

int Load::Process()
{
	Game::Instance().Graphics()->SetClearScreen(false);
	
	m_timer.Update();
	if(m_timer.GetTotalTime() > c_minTime)
		return NEXT|DELAYED;
	else
		return UNCHANGED;
}

bool Load::Begin()
{	
	m_splash = Game::Instance().Graphics()->CreateBackground();
	m_splash->SetImage(CR::AssetList::Splash);
	Game::Instance().Graphics()->SetBackgroundImage(m_splash);
	m_timer.Reset();
	return true;
}

void Load::End()
{
	Game::Instance().Graphics()->SetBackgroundImage(NULL);
	m_splash->Release();
}