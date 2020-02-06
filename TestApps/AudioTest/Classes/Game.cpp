/*
 *  Game.cpp
 *  AudioTest
 *
 *  Created by Eric Duhon on 10/9/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Game.h"
#include "Sound.h"
#include "NewAssetList.h"

using namespace CR;
using namespace std;
using namespace CR::Database;
using namespace CR::Sound;

Game::Game() : m_database(NULL)
{
	
}

Game::~Game()
{
	if(m_database)
		m_database->Release();
}

void Game::Init(const wstring &_databaseFile)
{	
	m_database = DatabaseFactory::Instance().CreateDatabase(_databaseFile);	
	ISound::Instance().SetDatabase(m_database);
	
	m_startSound = ISound::Instance().CreateSoundFX(CR::AssetList::sounds::ArcadeReady::ID);
	m_startSound->Play();
	
	ISound::Instance().PlaySong(CR::AssetList::music::BT_BGM_Arcade::ID);
}


void Game::Tick()
{
	ISound::Instance().Tick();
}

