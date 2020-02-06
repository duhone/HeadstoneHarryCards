/*
 *  Game.h
 *  AudioTest
 *
 *  Created by Eric Duhon on 10/9/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once

#include "Database.h"
#include "Sound.h"

namespace CR
{
	class Game
	{
	public:
		Game();
		~Game();
		void Init(const std::wstring &_databaseFile);
		void Tick();
	private:
		CR::Database::IDatabase *m_database;
		std::tr1::shared_ptr<CR::Sound::ISoundFX> m_startSound;
	};
}