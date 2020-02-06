/*
 *  PokerController.cpp
 *  hhcards
 *
 *  Created by Eric Duhon on 3/7/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#include "PokerController.h"
#include "PokerView.h";
#include "AssetList.h"

using namespace CR::UI;
using namespace CR::HHCards;


Control* PokerController::OnGenerateView()
{
	PokerView *view = new PokerView();
	
	m_dealButton = UIEngine::Instance().CreateButton(view, CR::AssetList::ButtonDeal, 900);
	m_dealButton->SetPosition(770, 650);
	m_dealButton->TouchUpInside += Delegate(this, &PokerController::OnDeal);
	//pauseButton->SetSoundTouchDown(CR::AssetList::sounds::tile_generic3::ID);
	
	return view;
}
