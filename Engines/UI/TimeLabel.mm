/*
 *  TimeLabel.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/5/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#include "TimeLabel.h"
#include "UIEngine.h"

using namespace CR::UI;
extern CR::Graphics::GraphicsEngine *graphics_engine;

TimeLabel::TimeLabel(int _nSprite, int _zInitial) : TouchControl(), m_spriteHelper(_nSprite,true, _zInitial)
{
	hoursLabel = UIEngine::Instance().CreateNumberLabel(this, _nSprite, _zInitial);
	hoursLabel->SetAlignment(AlignFontLeft);
	
	minutesLabel = UIEngine::Instance().CreateNumberLabel(this, _nSprite, _zInitial);
	minutesLabel->SetMinDigits(2);
	
	secondsLabel = UIEngine::Instance().CreateNumberLabel(this, _nSprite, _zInitial);
	secondsLabel->SetMinDigits(2);
	
	//numberFont = graphics_engine->CreateSprite1(true, _zInitial);
	//numberFont->SetImage(_nSprite);
	//numberFont->SetPositionAbsolute(160, 240);
	//SetBounds(numberFont->GetFrameWidth(), numberFont->GetFrameHeight());
}

TimeLabel::~TimeLabel()
{
	//numberFont->Release();
}

void TimeLabel::OnBeforeUpdate()
{
	int temp = m_seconds;
	int hours = 0;
	int minutes = 0;
	int seconds = 0;
	
	// hours
	if (temp >= 3600)
	{
		hours = temp / 3600;
		temp = temp - (hours * 3600);
	}
	
	// minutes
	if (temp >= 60)
	{
		minutes = temp / 60;
		temp = temp - (minutes * 60);
	}
	
	// seconds
	seconds = temp;
	
	hoursLabel->SetValue(hours);
	minutesLabel->SetValue(minutes);
	secondsLabel->SetValue(seconds);
	
	//
	//hoursLabel->Visible(hours > 0);
	//minutesLabel->Visible(minutes > 0);
	//secondsLabel->Visible(false);
	
	m_spriteHelper.Start();
	
	m_spriteHelper.NewSprite();
	m_spriteHelper.SetPosition(offset.X(), offset.Y());
	m_spriteHelper.SetFrame(10);
	
	m_spriteHelper.NewSprite();
	m_spriteHelper.SetPosition(offset.X() + 45, offset.Y());
	m_spriteHelper.SetFrame(10);
	
	m_spriteHelper.End();
}

void TimeLabel::OnSetPosition(float x, float y)
{

	
	offset.X(x);
	offset.Y(y);
	
	//numberFont->SetPositionAbsolute(x, y);
	hoursLabel->SetPosition(x, y);
	minutesLabel->SetPosition(x + 30, y);
	secondsLabel->SetPosition(x + 80, y);
}

void TimeLabel::OnSetBounds(Rect _bounds)
{
}