/*
 *  Splash.cpp
 *  hhcards
 *
 *  Created by Eric Duhon on 2/14/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#include "Splash.h"
#include "Game.h"
#import <Foundation/Foundation.h>
#include "AssetList.h"

using namespace CR::HHCards;

int Splash::Process()
{
	Game::Instance().Graphics()->SetClearScreen(false);
	return NEXT|DELAYED;
}

bool Splash::Begin()
{
	NSString *path = [[NSBundle mainBundle] pathForResource: @"main" ofType: @"hgf"];
	const char *mainhgf = [path UTF8String];
	Game::Instance().Graphics()->LoadHGF(const_cast<char*>(mainhgf));
	
	m_splash = Game::Instance().Graphics()->CreateBackground();
	m_splash->SetImage(CR::AssetList::Splash);
	Game::Instance().Graphics()->SetBackgroundImage(m_splash);
	return true;
}

void Splash::End()
{
	Game::Instance().Graphics()->SetBackgroundImage(NULL);
	m_splash->Release();
}