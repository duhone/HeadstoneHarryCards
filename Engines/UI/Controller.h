/*
 *  Controller.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/28/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

#pragma once
#include "FSM.h"
#include "View.h"
#include "Graphics.h"
#include "UIEngine.h"
using namespace CR::UI;

namespace CR
{
	namespace UI
	{
		template<class T, class S> 
		class Controller : public CR::Utility::IState, S
		{
		public:
			Controller()
			{
			
			}
			
			virtual ~Controller()
			{
			}
			
			//IState
			virtual bool Begin()
			{	
				m_view = new T(this);
				m_requestState = CR::Utility::IState::UNCHANGED;
				UIEngine::Instance().SetRootControl(m_view);
				OnInitialized();
				
				return true;
			}
			
			virtual void End()
			{
				UIEngine::Instance().SetRootControl(NULL);
				OnDestroyed();
			}
			
			virtual int Process()
			{
				m_view->Update();
				
				return m_requestState;
			}
			
		protected:
			void SetRequestState(int state) { m_requestState = state; }
			virtual void OnInitialized() {};
			virtual void OnDestroyed() {};
			
			T *m_view;
			int m_requestState;
		};
	}
}