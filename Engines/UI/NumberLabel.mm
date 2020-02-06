/*
 *  NumberLabel.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/12/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "NumberLabel.h"
#include <stack>

using namespace std;
using namespace CR::UI;

NumberLabel::NumberLabel(int _nSprite, int _zInitial) : m_spriteHelper(_nSprite,true, _zInitial)
{
	numberSprite = graphics_engine->CreateSprite1(true, _zInitial);
	numberSprite->SetImage(_nSprite);
	m_minDigits = 0;
	m_align = AlignFontCenter;
	m_numValue = 0;
	SetPosition(0, 0);
}

NumberLabel::~NumberLabel()
{
	numberSprite->Release();
}

void NumberLabel::OnBeforeUpdate()
{
}

void NumberLabel::OnBeforeRender()
{
	m_spriteHelper.Start();
	
	stack<int> digits;
	
	int cValue = m_numValue;
	
	while (cValue != 0)
	{
		int digit = cValue % 10;
		cValue = cValue / 10;
		digits.push(digit);
	}
	
	while (digits.size() < m_minDigits)
	{
		digits.push(0);
	}
	
	int xPos = 0;
	if (m_align == AlignFontCenter)
	{
		if (digits.size() > 0)
			xPos = offset.X() - ((digits.size() * numberSprite->GetFrameWidth())/2);
		else
			xPos = offset.X() - (numberSprite->GetFrameWidth())/2;
	}
	else if (m_align == AlignFontRight)
	{
		xPos = offset.X();// - ((digits.size() * numberSprite->GetFrameWidth())/2);
	}
	else if (m_align = AlignFontLeft)
	{
		if (digits.size() > 0)
			xPos = offset.X() - ((digits.size() * numberSprite->GetFrameWidth()));
		else
			xPos = offset.X() - (numberSprite->GetFrameWidth());
	}
	
	if (digits.size() == 0)
	{
		m_spriteHelper.NewSprite();
		m_spriteHelper.SetPosition(xPos, offset.Y());
		m_spriteHelper.SetFrame(0);
	}
	
	while (digits.size() > 0)
	{
		int digit = digits.top();
		digits.pop();
		
		m_spriteHelper.NewSprite();
		m_spriteHelper.SetPosition(xPos, offset.Y());
		m_spriteHelper.SetFrame(digit);
		
		xPos += numberSprite->GetFrameWidth();
	}
	
	m_spriteHelper.End();
}

void NumberLabel::OnSetPosition(float x, float y)
{

	
	offset.X(x);
	offset.Y(y);
}

void NumberLabel::OnSetBounds(Rect _bounds)
{
}