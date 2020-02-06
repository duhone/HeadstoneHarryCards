/*
 *  KeyboardManager.mm
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/4/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */

#include "KeyboardManager.h"

KeyboardManager::KeyboardManager()
{
	m_keyboardShowing = false;
}

KeyboardManager::~KeyboardManager()
{
}

void KeyboardManager::SetTextView(UITextField *textView)
{
	m_textView = textView;
}

void KeyboardManager::SetEditText(std::string str)
{
	[m_textView setText:[[NSString alloc] initWithCString:str.c_str()]];
}

void KeyboardManager::ShowKeyboard()
{
	if (!m_keyboardShowing)
	{
		[m_textView setText:@""];
		[m_textView becomeFirstResponder];
		m_keyboardShowing = true;
		KeyboardShown();
	}
}

void KeyboardManager::HideKeyboard()
{
	if (m_keyboardShowing)
	{
		[m_textView resignFirstResponder];
		m_keyboardShowing = false;
		KeyboardHidden();
	}
}

void KeyboardManager::ReportCharactersTyped(NSRange range, NSString* str)
{
	if (!m_keyboardShowing) return;
	
	if (str != NULL)
		KeyTyped([str UTF8String][0]);
}