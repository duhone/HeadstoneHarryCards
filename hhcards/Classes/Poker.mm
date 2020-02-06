/*
 *  Poker.cpp
 *  hhcards
 *
 *  Created by Eric Duhon on 2/22/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#include "Poker.h"
#include "Game.h"
#include "AssetList.h"
#include "PokerController.h"
#include "PokerStateInitial.h"
#include "PokerStateDeal.h"
#include "PokerStateHold.h"

using namespace CR;
using namespace CR::HHCards;
using namespace CR::Graphics;
using namespace CR::Utility;
using namespace std;

Poker::Poker()
{
	m_fsm << new PokerStateInitial<CR::Cards::Deck<> >(m_hand,m_cardSprites) << new PokerStateDeal<CR::Cards::Deck<> >(m_hand,m_cardSprites,2) << new PokerStateHold(1);
}

int Poker::Process()
{	
	/*for(int i = 0;i < 5; ++i)
	{
		if(!m_hand.IsDealt(i))
		{
			m_cardSprites[i]->Visible(false);
			m_cardSprites[i]->SetFrame(0);
		}
		else
		{
			m_cardSprites[i]->Visible(true);
			m_cardSprites[i]->SetFrameSet(1);
			m_cardSprites[i]->SetFrame(0);
		}

	}*/
	
	m_controller->EnableDeal(m_fsm->CanDeal());
	m_controller->Process();
	
	m_fsm();
	
	return UNCHANGED;
}

bool Poker::Begin()
{	
	for(int i = 0;i < 5; ++i)
	{
		m_cardSprites.push_back(Game::Instance().Graphics()->CreateSprite1(false,500));
		m_cardSprites[i]->SetImage(AssetList::Cards);
		//m_cardSprites[i]->SetPositionAbsolute(187+i*160,430);
	}
	
	Game::Instance().Graphics()->SetClearScreen(false);
	m_board = Game::Instance().Graphics()->CreateBackground();
	m_board->SetImage(CR::AssetList::Board);
	Game::Instance().Graphics()->SetBackgroundImage(m_board);
	
	m_controller = new PokerController();
	m_controller->Deal += Delegate(this, &Poker::OnDeal);

	m_controller->Begin();
	
	m_fsm.State = 0;
	
	return true;
}

void Poker::End()
{
	m_fsm.Disable();
	
	m_controller->End();
	delete m_controller;
	
	Game::Instance().Graphics()->SetBackgroundImage(NULL);
	m_board->Release();
	ForEach(m_cardSprites, mem_fun(&Sprite::Release));
	m_cardSprites.clear();
	
}