#include "InputEngine.h"
#include <algorithm>
using namespace CR::Input;

InputEngine::InputEngine()
{
	touch = NULL;
	input_controller = NULL;
}

InputEngine::~InputEngine()
{
}

bool InputEngine::RegisterITouchable(ITouchable* arg)
{
	//ResetControls();
	input_controller = arg;
	ResetControls();
	return true;
}

bool InputEngine::UnregisterITouchable()
{
	input_controller = NULL;
	return true;
}

void InputEngine::AddTouchable(ITouchable *inputController)
{
	// add this item to the list if the list doesn't already contain it
	list<ITouchable*>::iterator result;
	result = find(m_inputControllers.begin(), m_inputControllers.end(), inputController);
	if (result == m_inputControllers.end()) // no matching element found
		m_inputControllers.push_back(inputController);
}

void InputEngine::RemoveTouchable(ITouchable *inputController)
{
	// remove item from the list if the list contains it
	list<ITouchable*>::iterator result;
	result = find(m_inputControllers.begin(), m_inputControllers.end(), inputController);
	if (result != m_inputControllers.end()) // matching element found
		m_inputControllers.remove(inputController);
}

void InputEngine::TouchesBegan(UIView *view, NSSet *touches)
{
	//if (input_controller == NULL) return;
	
	// Only allow a single touch
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			return;
	
		this->touch = touch;
	}
	
	// TODO: Remove this, old way
	if (input_controller != NULL)
	{
		input_controller->TouchesBegan(view, touches);
		for (int i = 0; i < input_controller->input_objects.size(); i++)
		{
			input_controller->input_objects[i]->TouchesBegan(view, touches);
		}
		input_controller->InputChanged();
	}
		
	// TODO: This is the new and improved way, make this the only way, and remove the old ways
	for (list<ITouchable*>::iterator it = m_inputControllers.begin(); it != m_inputControllers.end(); it++)
	{
		(*it)->TouchesBegan(view, touches);
	}
}

void InputEngine::TouchesMoved(UIView *view, NSSet *touches)
{
	//if (input_controller == NULL) return;
	
	// Only allow a single touch
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			return;
		
		this->touch = touch;
	}
	
	// TODO: Remove this, old way
	if (input_controller != NULL)
	{	
		input_controller->TouchesMoved(view, touches);
		
		for (int i = 0; i < input_controller->input_objects.size(); i++)
		{
			input_controller->input_objects[i]->TouchesMoved(view, touches);
		}
		input_controller->InputChanged();
	}
		
	// TODO: This is the new and improved way, make this the only way, and remove the old ways
	for (list<ITouchable*>::iterator it = m_inputControllers.begin(); it != m_inputControllers.end(); it++)
	{
		(*it)->TouchesMoved(view, touches);
	}
}

void InputEngine::TouchesEnded(UIView *view, NSSet *touches)
{
	//if (input_controller == NULL) return;

	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			return;
		
		if (touch == this->touch)
		{
			this->touch = NULL;
		}
	}
	
	// TODO: Remove this, old way
	if (input_controller != NULL)
	{	
		input_controller->TouchesEnded(view, touches);
		
		for (int i = 0; i < input_controller->input_objects.size(); i++)
		{
			input_controller->input_objects[i]->TouchesEnded(view, touches);
		}
		
		input_controller->InputChanged();
	}
	
	// TODO: This is the new and improved way, make this the only way, and remove the old ways
	for (list<ITouchable*>::iterator it = m_inputControllers.begin(); it != m_inputControllers.end(); it++)
	{
		(*it)->TouchesEnded(view, touches);
	}
}

void InputEngine::TouchesCancelled(UIView *view, NSSet *touches)
{
	//if (input_controller == NULL) return;
	
	for (UITouch *touch in touches)
	{
		if (this->touch != NULL && touch != this->touch)
			return;
		
		if (touch == this->touch)
		{
			this->touch = NULL;
		}
	}
		
	// TODO: Remove this, old way
	if (input_controller != NULL)
	{	
		input_controller->TouchesCancelled(view, touches);
		
		for (int i = 0; i < input_controller->input_objects.size(); i++)
		{
			input_controller->input_objects[i]->TouchesCancelled(view, touches);
		}
		
		input_controller->InputChanged();
	}
	
	// TODO: This is the new and improved way, make this the only way, and remove the old ways
	for (list<ITouchable*>::iterator it = m_inputControllers.begin(); it != m_inputControllers.end(); it++)
	{
		(*it)->TouchesCancelled(view, touches);
	}
}
		
void InputEngine::ResetControls()
{
	if (input_controller != NULL)
	{
		for (int i = 0; i < input_controller->input_objects.size(); i++)
		{
			input_controller->input_objects[i]->Reset();
		}
	}
}
