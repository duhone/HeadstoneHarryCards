/*
 *  MasterController.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/2/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "UIModule.h"

using namespace CR::UI;

UIModule::UIModule()
{
}

UIModule::~UIModule()
{
}

void UIModule::OnRequestClose()
{
	RequestClose();
}

void UIModule::Start()
{
	m_controllerFSM.State = 0;
}

void UIModule::Execute()
{
	m_controllerFSM();
}

void UIModule::AddState(Controller2 *state)
{
	m_controllerFSM << state;
}