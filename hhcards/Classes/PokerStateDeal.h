/*
 *  PokerStateDeal.h
 *  hhcards
 *
 *  Created by Eric Duhon on 3/8/10.
 *  Copyright 2010 Apple Inc. All rights reserved.
 *
 */

#pragma once
#include "PokerHand.h"
#include "Graphics.h"
#include "PokerState.h"
#include "Timer.h"
#include "Math.h"

namespace CR
{
	namespace HHCards
	{
		template<typename DeckType>
		class PokerStateDeal : public PokerState
		{
			struct Animation
			{
				CR::Math::Vector3F StartPosition;
				CR::Math::Vector3F EndPosition;
				CR::Math::Vector3F CurrentPosition;
				
				float StartAngle;
				float EndAngle;
				float CurrentAngle;
				
				void Tick(float _percent)
				{
					CurrentPosition = ((EndPosition-StartPosition)*_percent)+StartPosition;
					CurrentAngle = ((EndAngle-StartAngle)*_percent)+StartAngle;
				}
			};
		public:
			PokerStateDeal(CR::Cards::PokerHand<DeckType> &_hand,std::vector<CR::Graphics::Sprite*> &_sprites,int _nextState);
			virtual bool CanDeal() {return false;}
		private:
			typedef CR::Cards::PokerHand<DeckType> HandType;
			
			virtual bool Begin();
			virtual int Process();
			
			const static float c_totalTime = 1.0;
			const static float c_invTotalTime = 1/1.0;
			
			CR::Cards::PokerHand<DeckType> &m_hand;
			std::vector<CR::Graphics::Sprite*> &m_sprites;
			CR::Utility::Timer m_timer;
			int m_nextState;
			
			Animation m_animation[HandType::NumCards];
		};
						
		template<typename DeckType>
		PokerStateDeal<DeckType>::PokerStateDeal(CR::Cards::PokerHand<DeckType> &_hand,std::vector<CR::Graphics::Sprite*> &_sprites,int _nextState) : 
		m_hand(_hand), m_sprites(_sprites), m_nextState(_nextState)
		{
			
		}
		
		template<typename DeckType>
		bool PokerStateDeal<DeckType>::Begin()
		{			
			for(int i = 0;i < m_sprites.size(); ++i)
			{
				m_sprites[i]->Visible(true);
			}
			m_timer.Reset();
			
			for (int i = 0; i < HandType::NumCards; ++i)
			{				
				m_animation[i].StartPosition.Set(512-44.0f,-50.0f,0);
				m_animation[i].EndPosition.Set(187+i*160.0f,430.0f,0);
				m_animation[i].StartAngle = ((rand()%1000)/1000.0f)*6.28f;
				m_animation[i].EndAngle = (((rand()%1000)/1000.0f)*0.1f)-0.05f+6.28f*4;
				
				m_animation[i].Tick(0);
			}
			for(int i = 0;i < m_sprites.size(); ++i)
			{
				m_sprites[i]->SetPositionAbsolute(m_animation[i].CurrentPosition.X(),m_animation[i].CurrentPosition.Y());
				m_sprites[i]->RotateZ(m_animation[i].CurrentAngle);
			}
			
			return true;
		}
		
		template<typename DeckType>
		int PokerStateDeal<DeckType>::Process()
		{	
			m_timer.Update();
			
			float percentDone = 1.0f - (c_totalTime-m_timer.GetTotalTime())*c_invTotalTime;
			
			percentDone = std::max(percentDone,0.0f);
			percentDone = std::min(percentDone,1.0f);
			
			for (int i = 0; i < HandType::NumCards; ++i)
			{				
				m_animation[i].Tick(percentDone);
			}
			
			for(int i = 0;i < m_sprites.size(); ++i)
			{
				m_sprites[i]->SetPositionAbsolute(m_animation[i].CurrentPosition.X(),m_animation[i].CurrentPosition.Y());
				m_sprites[i]->RotateZ(m_animation[i].CurrentAngle);
			}
			
			if(m_timer.GetTotalTime() > c_totalTime)
				return m_nextState;
			else
				return UNCHANGED;
		}
	}
}

