/*
 *  TimerBar2.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/4/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "TimerBar2.h"

extern CR::Graphics::GraphicsEngine *graphics_engine;

using namespace CR::Math;

TimerBar2::TimerBar2(int _zInitial) : m_zInitial(_zInitial), fillSprite(NULL), fillQuad(NULL),
	m_colorSprite(NULL), m_color(1.0f), m_colorDn(false), m_noiseSprite(NULL), m_noiseOffset(0), m_plungerSprite(NULL), baseSprite(NULL)
{	
	maxTime = 60;
	currTime = maxTime;
	m_halted = false;
}

void TimerBar2::BaseSprite(int _baseSprite)
{
	if (baseSprite)
		baseSprite->Release();
	
	baseSprite = graphics_engine->CreateSprite1(true,m_zInitial);
	baseSprite->SetImage(_baseSprite);
	baseSprite->SetFrameRate(40);
	baseSprite->SetAutoAnimate(true);
}

void TimerBar2::UseFillQuad()
{
	if(!fillQuad)
		fillQuad = graphics_engine->CreateQuad(m_zInitial-3);	
}

void TimerBar2::FillSprite(int _fillSprite)
{
	if(fillSprite)
		fillSprite->Release();
	fillSprite = graphics_engine->CreateSprite1(true,m_zInitial-3);
	fillSprite->SetImage(_fillSprite);	
}

void TimerBar2::ColorSprite(int _colorSprite)
{
	if(m_colorSprite)
		m_colorSprite->Release();
	m_colorSprite = graphics_engine->CreateSprite1(true,m_zInitial-1);
	m_colorSprite->SetImage(_colorSprite);	
}

void TimerBar2::NoiseSprite(int _noiseSprite)
{
	if(m_noiseSprite)
		m_noiseSprite->Release();
	m_noiseSprite = graphics_engine->CreateSprite1(true,m_zInitial-2);
	m_noiseSprite->SetImage(_noiseSprite);	
}

void TimerBar2::PlungerSprite(int _plungerSprite)
{
	if (m_plungerSprite)
		m_plungerSprite->Release();
	
	m_plungerSprite = graphics_engine->CreateSprite1(true, m_zInitial);
	m_plungerSprite->SetImage(_plungerSprite);
}

TimerBar2::~TimerBar2()
{
	if (baseSprite)
		baseSprite->Release();
	if(fillSprite)
		fillSprite->Release();
	if(m_colorSprite)
		m_colorSprite->Release();
	if(m_noiseSprite)
		m_noiseSprite->Release();
	if(fillQuad)
		fillQuad->Release();
	if(m_plungerSprite)
		m_plungerSprite->Release();
}

void TimerBar2::SetMaxTime(float _value)
{
	maxTime = _value;
	
	if (currTime > maxTime)
		currTime = maxTime;
}

void TimerBar2::SetMaxTime(float _value, bool addDiff)
{
	if (addDiff) {
		float currMaxTime = maxTime;
		SetMaxTime(_value);
		
		currTime = currTime + (_value - currMaxTime);
		
	}
	else {
		SetMaxTime(_value);	
	}
}

void TimerBar2::ResetTimer()
{
	currTime = maxTime;
}

void TimerBar2::Stop()
{
	currTime = 0;
}

void TimerBar2::IncreaseTimer(float time)
{
	currTime += time;
	if (currTime >= maxTime)
		currTime = maxTime;
}

void TimerBar2::DecreaseTimer(float time)
{
	if(currTime > 0)
	{
		currTime -= time;
		
		if (currTime <= 0)
		{
			currTime = 0;
			TimerExpired();
		}
	}
}

void TimerBar2::OnSetPosition(float x, float y)
{

	
	if (baseSprite)
		baseSprite->SetPositionAbsolute(x, y);
	if(fillSprite)
		fillSprite->SetPositionAbsolute(x, y);
	if(m_colorSprite)
		m_colorSprite->SetPositionAbsolute(x, y);
	if(m_noiseSprite)
		m_noiseSprite->SetPositionAbsolute(x, y);
	if (m_plungerSprite)
		m_plungerSprite->SetPositionAbsolute(x,y);
}

void TimerBar2::OnSetBounds(Rect _bounds)
{
}

void TimerBar2::OnBeforeUpdate()
{
	m_timer.Update();
	
	if (!m_halted)
		DecreaseTimer(m_timer.GetLastFrameTime());
	
	float percent = (float)currTime / (float) maxTime;
	float frame = (1 - percent) * 59.0;
	if(fillSprite)
		fillSprite->SetFrame(frame);
	if(fillQuad)
	{
		float topOffset = (m_topRight.X() - m_topLeft.X())*percent;
		float botOffset = (m_bottomRight.X() - m_bottomLeft.X())*percent;
		fillQuad->TopLeft(m_topLeft.X()+topOffset,m_topLeft.Y());
		fillQuad->TopRight(m_topRight.X(),m_topRight.Y());	
		fillQuad->BottomLeft(m_bottomLeft.X()+botOffset,m_bottomLeft.Y());	
		fillQuad->BottomRight(m_bottomRight.X(),m_bottomRight.Y());
	}
	if(m_colorSprite)
	{
		if(m_colorDn)
		{
			m_color -= 0.2*m_timer.GetLastFrameTime();
			if(m_color <= 0.75f)
			{
				m_color = 0.75f;
				m_colorDn = false;
			}
		}
		else
		{
			m_color += 0.2*m_timer.GetLastFrameTime();
			if(m_color >= 1.0f)
			{
				m_color = 1.0f;
				m_colorDn = true;
			}
		}
		m_colorSprite->Color(Color32(255*m_color,255*m_color,255*m_color,255));
	}
	if(m_noiseSprite)
	{
		m_noiseOffset -= 0.3f*m_timer.GetLastFrameTime();
		if(m_noiseOffset < 0.0f)
			m_noiseOffset += 1.0f;
		m_noiseSprite->UOffset(m_noiseOffset);
	}
	if(m_plungerSprite)
	{
		float xOffset = (m_topRight.X() - m_topLeft.X())*percent;
		m_plungerSprite->SetPositionAbsolute(m_topLeft.X() + xOffset + (m_plungerSprite->GetFrameWidth()/2), GetPosition().Y());
		
		//float botOffset = (m_bottomRight.X() - m_bottomLeft.X())*percent;
		//fillQuad->TopLeft(m_topLeft.X()+topOffset,m_topLeft.Y());
		//fillQuad->TopRight(m_topRight.X(),m_topRight.Y());	
		//fillQuad->BottomLeft(m_bottomLeft.X()+botOffset,m_bottomLeft.Y());	
		//fillQuad->BottomRight(m_bottomRight.X(),m_bottomRight.Y());
	}
}

void TimerBar2::HaltTimer()
{
	m_halted = true;
}

void TimerBar2::ResumeTimer()
{
	m_halted = false;
}