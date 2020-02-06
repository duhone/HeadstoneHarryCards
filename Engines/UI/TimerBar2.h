/*
 *  TimerBar2.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/4/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "TouchControl.h"
#include "Graphics.h"
#include "Timer.h"

class TimerBar2 : public CR::UI::TouchControl
{
public:
	TimerBar2(int _zInitial);
	virtual ~TimerBar2();
	
	void SetMaxTime(float _value);
	void SetMaxTime(float _value, bool addDiff);
	void ResetTimer();
	void Stop();
	void IncreaseTimer(float time);
	void DecreaseTimer(float time);
	float GetCurrTime() { return currTime; }
	
	void BaseSprite(int _baseSprite);
	void FillSprite(int _fillSprite);
	void ColorSprite(int _colorSprite);
	void NoiseSprite(int _noiseSprite);
	void PlungerSprite(int _plungerSprite);
	void UseFillQuad();
	
	void HaltTimer();
	void ResumeTimer();
	
	CR::Math::PointF& TopLeft() {return m_topLeft;}
	CR::Math::PointF& TopRight() {return m_topRight;}
	CR::Math::PointF& BottomLeft() {return m_bottomLeft;}
	CR::Math::PointF& BottomRight() {return m_bottomRight;}
	Event TimerExpired;
	
	
protected:
	// Control Methods
	virtual void OnBeforeUpdate();
	
	// TouchControl
	void OnTouchDown() {};
	void OnTouchDownWhileDisabled() {};
	void OnTouchUpInside() {};
	void OnTouchUpOutside() {};
	void OnSetPosition(float x, float y);
	void OnSetBounds(Rect _bounds);
	
private:
	CR::Graphics::Sprite *baseSprite;
	CR::Graphics::Sprite *m_colorSprite;
	CR::Graphics::Sprite *m_noiseSprite;
	CR::Graphics::Sprite *fillSprite;
	CR::Graphics::Quad *fillQuad;
	CR::Graphics::Sprite *m_plungerSprite;
	
	float maxTime;
	float currTime;
	int m_zInitial;
	CR::Math::PointF m_topLeft;
	CR::Math::PointF m_topRight;
	CR::Math::PointF m_bottomLeft;
	CR::Math::PointF m_bottomRight;
	
	float m_color;
	bool m_colorDn;
	float m_noiseOffset;
	bool m_halted;
	CR::Utility::Timer m_timer;
};