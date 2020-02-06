/*
 *  Control.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/28/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#include "Control.h"

using namespace CR::UI;
using namespace CR::Math;

Control::Control()
{
	m_enabled = true;
	m_visible = true;
	m_paused = false;
	m_ignoreTouches = false;
	
	position.X(0);
	position.Y(0);
	
	bounds.left = 0; 
	bounds.top = 0; 
	bounds.right = 0; 
	bounds.bottom = 0; 
	
	m_parent = NULL;
}

Control::~Control()
{
	DeleteControlTree();
}

void Control::SetPosition(float x, float y)
{
	position.X(x);
	position.Y(y);
	
	// if there is no parent, position anywhere
	if (m_parent == NULL)
	{	
		OnSetPosition(position.X(), position.Y());
	}
	else // if there is a parent, position relative
	{
		//bounds.left = m_parent->GetPosition().X() + x;
		//bounds.top = m_parent->GetPosition().Y() + y;
		//position.X(m_parent->GetPosition().X() + x);
		//position.Y(m_parent->GetPosition().Y() + y);
		
		OnSetPosition(m_parent->GetAbsolutePosition().X() + x, m_parent->GetAbsolutePosition().Y() + y);
	}

	//OnSetPosition(position.X(), position.Y());
	
	// update the relative position of controls in the control tree
	if (m_children.size() <= 0) return;
	
	for (vector<Control*>::iterator it = m_children.begin(); it != m_children.end(); it++)
	{
		//(*it)->SetPosition(position.X() + (*it)->GetPosition().X(), position.Y() + (*it)->GetPosition().Y());
		(*it)->SetPosition((*it)->GetPosition().X(), (*it)->GetPosition().Y());
	}
}

CR::Math::PointF Control::GetPosition()
{
	//PointF point;
	//point.X(bounds.left);
	//point.Y(bounds.top);
	//return point;
	return position;
}

CR::Math::PointF Control::GetAbsolutePosition()
{
	PointF aPos;
	
	if (m_parent != NULL)
	{
		aPos.X(m_parent->GetAbsolutePosition().X() + GetPosition().X());
		aPos.Y(m_parent->GetAbsolutePosition().Y() + GetPosition().Y());
	}
	else
	{
		aPos.X(GetPosition().X());
		aPos.Y(GetPosition().Y());
	}

	
	return aPos;
}

void Control::SetBounds(Rect _bounds)
{
	bounds.top = _bounds.top;
	bounds.left = _bounds.left;
	bounds.right = _bounds.right;
	bounds.bottom = _bounds.bottom;
	OnSetBounds(bounds);
}

/*
void Control::SetBounds(float left, top, width, height)
{
	bounds.left = left;
	bounds.top = top;
	bounds.right = width;
	bounds.bottom = height;
	OnSetBounds(left, top, width, height);
}
*/

bool Control::Enabled()
{
	return m_enabled;
}

void Control::Enabled(bool _enabled)
{
	m_enabled = _enabled;
}

bool Control::Visible()
{
	return m_visible;
}

void Control::Visible(bool _visible)
{
	m_visible = _visible;
}

bool Control::Paused()
{
	return m_paused;
}

bool Control::IgnoreTouches()
{
	return m_ignoreTouches;
}

void Control::IgnoreTouches(bool _ignoreTouches)
{
	m_ignoreTouches = _ignoreTouches;
}

void Control::Paused(bool _paused)
{
	m_paused = _paused;
	
	OnPaused(_paused);
}

vector<Control*> &Control::GetChildren()
{
	return m_children;
}

void Control::Parent(Control *parent)
{
	m_parent = parent;
	
	// Update the position of this control to be relative to parent
	SetPosition(position.X(), position.Y());
}

Control* Control::Parent()
{
	return m_parent;
}

void Control::Update()
{
	if (m_paused) return;
	
	BeforeUpdate();
	OnBeforeUpdate();
	UpdateControlTree();
}

void Control::UpdateControlTree()
{
	if (m_children.size() <= 0) return;
	
	for (vector<Control*>::iterator it = m_children.begin(); it != m_children.end(); it++)
	{
		(*it)->Update();
	}
}

void Control::DeleteControlTree()
{
	// This will call the destructor of child controls which call call their destructors and so on
	for (int i = 0; i < m_children.size(); i++)
		delete m_children[i];
}