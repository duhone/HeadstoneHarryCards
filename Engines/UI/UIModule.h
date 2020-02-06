/*
 *  MasterController.h
 *  Headstone Harry
 *
 *  Created by Robert Shoemate on 10/2/09.
 *  Copyright 2009 Conjured Realms LLC. All rights reserved.
 *
 */
#pragma once
#include "FSM.h"
#include "Event.h"
#include "Controller2.h"
#include <vector>

namespace CR
{
	namespace UI
	{
		class UIModule : public CR::Utility::IState
		{
		public:
			UIModule();
			virtual ~UIModule();
			
			// usage
			void Start();
			void Execute();
			
			// events
			Event RequestClose;
			
		protected:
			// delegate methods
			virtual void OnRequestClose();
			void AddState(Controller2 *state);
			
		private:
			CR::Utility::FSM<> m_controllerFSM;
		};
	}
}