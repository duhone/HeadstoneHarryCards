/*
 *  KeyboardManager.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 1/4/10.
 *  Copyright 2010 Conjured Realms LLC. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#include "Singleton.h"
#include "Event.h"
#include <string>

class KeyboardManager : public CR::Utility::Singleton<KeyboardManager>
{
public:
	friend class CR::Utility::Singleton<KeyboardManager>;
	
	KeyboardManager();
	~KeyboardManager();
	
	void SetTextView(UITextField *textView);
	void SetEditText(std::string str);
	void ShowKeyboard();
	void HideKeyboard();
	
	// call these from the delegate of the view displaying the keyboard
	void ReportCharactersTyped(NSRange range, NSString* str);
	
	void SetMainView(UIView *mainView) { m_mainView = mainView; }
	UIView *GetMainView() { return m_mainView; }
	
	// events
	Event KeyboardShown;
	Event KeyboardHidden;
	Event1<char> KeyTyped;
	
private:
	bool m_keyboardShowing;
	UITextField *m_textView;
	UIView *m_mainView;
};