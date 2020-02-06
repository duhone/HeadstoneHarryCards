/*
 *  UIEngine.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/26/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "UIEngine.h"
#include <algorithm>
using namespace CR::UI;

UIEngine::UIEngine()
{
	m_rootTouchable = NULL;
}

UIEngine::~UIEngine()
{
}

bool UIEngine::TouchesBegan(UIView *view, NSSet *touches)
{
	if (m_rootTouchable == NULL) return false;
	
	return RecTouchesBegan(m_rootTouchable, view, touches);
}

bool UIEngine::TouchesMoved(UIView *view, NSSet *touches)
{
	if (m_rootTouchable == NULL) return false;
	
	return RecTouchesMoved(m_rootTouchable, view, touches);
}

void UIEngine::TouchesEnded(UIView *view, NSSet *touches)
{
	for (vector<Control*>::iterator it = m_touchedItems.begin(); it != m_touchedItems.end(); it++)
	{
		(*it)->TouchesEnded(view, touches);
	}
	
	m_touchedItems.clear();
}

void UIEngine::TouchesCancelled(UIView *view, NSSet *touches)
{
	for (vector<Control*>::iterator it = m_touchedItems.begin(); it != m_touchedItems.end(); it++)
	{
		(*it)->TouchesEnded(view, touches);
	}
	
	m_touchedItems.clear();
}

bool UIEngine::RecTouchesBegan(Control *touchable, UIView *view, NSSet *touches)
{
	// Retrieve the children for this Control
	vector<Control*> touchChildren = touchable->GetChildren();
	
	if (touchChildren.size() <= 0)
	{
		if (touchable->TouchesBegan(view, touches))
		{
			// Store this item as being touched so that TouchesEnded/TouchesCancelled can be called on it
			StoreTouchedItem(touchable);
			return true;
		}
		else
		{
			return false;
		}
	}
	
	for (vector<Control*>::iterator it = touchChildren.begin(); it != touchChildren.end(); it++)
	{
		if (RecTouchesBegan(*it, view, touches))
			return true;
	}
	
	if (touchable->TouchesBegan(view, touches))
	{
		// Store this item as being touched so that TouchesEnded/TouchesCancelled can be called on it
		StoreTouchedItem(touchable);
		return true;
	}
	else
	{
		return false;
	}
}

bool UIEngine::RecTouchesMoved(Control *touchable, UIView *view, NSSet *touches)
{
	// Retrieve the children for this Control
	vector<Control*> touchChildren = touchable->GetChildren();
	
	if (touchChildren.size() <= 0)
	{
		if (touchable->TouchesMoved(view, touches))
		{
			// Store this item as being touched so that TouchesEnded/TouchesCancelled can be called on it
			StoreTouchedItem(touchable);
			return true;
		}
		else
		{
			return false;
		}
	}
	
	for (vector<Control*>::iterator it = touchChildren.begin(); it != touchChildren.end(); it++)
	{
		if(RecTouchesMoved(*it, view, touches))
			return true;
	}
	
	if (touchable->TouchesMoved(view, touches))
	{
		// Store this item as being touched so that TouchesEnded/TouchesCancelled can be called on it
		StoreTouchedItem(touchable);
		return true;
	}
	else
	{
		return false;
	}
}

void UIEngine::SetRootControl(Control *touchable)
{
	m_rootTouchable = touchable;
}

Button *UIEngine::CreateButton(Control *_control, int _nSprite, int _zInitial)
{
	Button *btn = new Button(_nSprite, _zInitial);
	_control->GetChildren().push_back(btn);
	btn->Parent(_control);
	return btn;
}

ImageCycler *UIEngine::CreateImageCycler(Control *_control, int _zInitial)
{
	ImageCycler *cyc = new ImageCycler(_zInitial);
	_control->GetChildren().push_back(cyc);
	cyc->Parent(_control);
	return cyc;
}

SpriteLabel *UIEngine::CreateSpriteLabel(Control *_control, int _nSprite, int _zInitial)
{
	SpriteLabel *lbl = new SpriteLabel(_nSprite, _zInitial);
	_control->GetChildren().push_back(lbl);
	lbl->Parent(_control);
	return lbl;
}

TimerBar2 *UIEngine::CreateTimerBar(Control *_control, int _zInitial)
{
	TimerBar2 *tmr = new TimerBar2(_zInitial);
	_control->GetChildren().push_back(tmr);
	tmr->Parent(_control);
	return tmr;
}

NumberLabel *UIEngine::CreateNumberLabel(Control *_control, int _nSprite, int _zInitial)
{
	NumberLabel *lbl = new NumberLabel(_nSprite, _zInitial);
	_control->GetChildren().push_back(lbl);
	lbl->Parent(_control);
	return lbl;
}

TextLabel *UIEngine::CreateTextLabel(Control *_control, int _nSprite, int _zInitial)
{
	TextLabel *lbl = new TextLabel(_nSprite, _zInitial);
	_control->GetChildren().push_back(lbl);
	lbl->Parent(_control);
	return lbl;
}

CheckBox *UIEngine::CreateCheckBox(Control *_control, int _nSprite, int _zInitial)
{
	CheckBox *chk = new CheckBox(_nSprite, _zInitial);
	_control->GetChildren().push_back(chk);
	chk->Parent(_control);
	return chk;
}

TimeLabel *UIEngine::CreateTimeLabel(Control *_control, int _nSprite, int _zInitial)
{
	TimeLabel *lbl = new TimeLabel(_nSprite, _zInitial);
	_control->GetChildren().push_back(lbl);
	lbl->Parent(_control);
	return lbl;
}

/*VMeterBar *UIEngine::CreateVMeterBar(Control *_control, int _nSprite, int _zInitial)
{
	VMeterBar *mtr = new VMeterBar(_nSprite, _zInitial);
	_control->GetChildren().push_back(mtr);
	mtr->Parent(_control);
	return mtr;
}*/

void UIEngine::StoreTouchedItem(Control *touchable)
{
	// Make sure this item is not already stored in the touched items list
	vector<Control*>::iterator result;
	result = find(m_touchedItems.begin(), m_touchedItems.end(), touchable);
	if (result == m_touchedItems.end()) // no matching element found
		m_touchedItems.push_back(touchable);
}