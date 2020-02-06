/*
 *  Game.cpp
 *  hhcards
 *
 *  Created by Eric Duhon on 2/12/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#include "Game.h"
#include "Initial.h"
#include "Splash.h"
#include "Poker.h"
#include "Load.h"

using namespace CR::HHCards;
using namespace CR::Graphics;

GameImpl::GameImpl() : m_graphics(NULL)
{
	m_graphics = GetGraphicsEngine();
	
	m_stateMachine << new Initial() << new Splash() << new Load() << new Poker();
	
	m_stateMachine.State = 0;
}

GameImpl::~GameImpl()
{
	m_graphics->Release();
}

void GameImpl::Initialize()
{
	
}

void GameImpl::TearDown()
{

}

void GameImpl::Tick()
{	
	m_stateMachine();
	
	m_graphics->BeginFrame();	
	
	m_graphics->EndFrame();
}

void GameImpl::ApplicationTerminated()
{

}