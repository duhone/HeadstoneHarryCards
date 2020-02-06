/*
 *  Game.h
 *  hhcards
 *
 *  Created by Eric Duhon on 2/12/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */
#pragma once
#include "Singleton.h"
#include "Graphics.h"
#include "FSM.h"

namespace CR
{
	namespace HHCards
	{
		class GameImpl
		{
			friend class CR::Utility::Singleton<GameImpl>;
		public:
			void Initialize();
			void TearDown();
			void Tick();
			void ApplicationTerminated();
			CR::Graphics::GraphicsEngine* Graphics() const {return m_graphics;}
		private:
			GameImpl();
			~GameImpl();
			
			CR::Graphics::GraphicsEngine *m_graphics;
			CR::Utility::FSM<> m_stateMachine;
		};
		
		typedef CR::Utility::Singleton<GameImpl> Game;
	}
}
