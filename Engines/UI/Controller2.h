/*
 *  Controller2.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 9/30/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */

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
		class Controller2 : public CR::Utility::IState
		{
		public:
			Controller2()
			{
				m_view = NULL;
				m_keepInMemory = false;
				
				m_autoTransitionStateEnabled = false;
				m_autoTransitionState = 0;
			}
			
			Controller2(bool keepInMemory)
			{
				m_view = NULL;
				m_keepInMemory = keepInMemory;
				
				m_autoTransitionStateEnabled = false;
				m_autoTransitionState = 0;
			}
					
			virtual ~Controller2()
			{
				delete m_view;
			}
			
			void Initialize()
			{
				if (m_view == NULL)
					m_view = OnGenerateView();
			}
			
			void DeInitialize()
			{
				if (m_view != NULL)
				{
					delete m_view;
					m_view = NULL;
				}
			}
			
			//IState
			virtual bool Begin()
			{	
				if (m_view == NULL)
					m_view = OnGenerateView();
				
				m_requestState = CR::Utility::IState::UNCHANGED;
				UIEngine::Instance().SetRootControl(m_view);
				OnInitialized();
				
				//GetGraphicsEngine()->BeginFrame();
				//m_view->Render();
				//GetGraphicsEngine()->EndFrame();
				
				return false;
			}
			
			virtual void End()
			{				
				UIEngine::Instance().SetRootControl(NULL);
				OnDestroyed();
				
				// delete this view if it wasn't requested to stay in memory
				if (!m_keepInMemory)
				{
					delete m_view;
					m_view = NULL;
				}
				//else {
				//	GetGraphicsEngine()->BeginFrame();
				//	m_view->Render();
				//	GetGraphicsEngine()->EndFrame();
				//}

			}
			
			virtual int Process()
			{
				if (m_view != NULL)
				{
					m_view->Update();
				}
				
				return m_requestState;
			}
			
			virtual Control *GetView() { return m_view; }
			
			
			// Transition Properties/Events
			void AutoTransitionStateOnClose(bool _enabled, int _toState)
			{
				m_autoTransitionStateEnabled = _enabled;
				m_autoTransitionState = _toState;
			}
			
			Event RequestClose;
			
		protected:
			
			void InitializeView(Control* view, bool keepInMemory)
			{
				m_keepInMemory = keepInMemory;
				m_view = view;
			}
			
			void KeepViewInMemory(bool keepInMemory)
			{
				m_keepInMemory = keepInMemory;
			}
			
			void OnRequestClose()
			{
				if (m_autoTransitionStateEnabled)
				{
					SetRequestState(m_autoTransitionState);
				}
				else
				{
					RequestClose();
				}
			}
			
			void SetRequestState(int state) { m_requestState = state; }
			void ResumeControl() { UIEngine::Instance().SetRootControl(m_view); }
			virtual Control* OnGenerateView() { return NULL; }
			virtual void OnInitialized() {};
			virtual void OnDestroyed() {};
			Control *m_view;
			int m_requestState;
			
			bool m_autoTransitionStateEnabled;
			int m_autoTransitionState;
			
		private:
			bool m_keepInMemory;
		};
	}
}