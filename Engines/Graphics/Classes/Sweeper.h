/*
 *  Sweeper.h
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/26/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once

#include "Graphics.h"
#include "Special.h"
#include "Vertex.h"
#include "Point.h"

namespace CR
{
	namespace Graphics
	{
		class TextureStruct;
		
		class Sweeper : public ISweeper, public Special
		{
		public:
			Sweeper(int _z = 0);
			virtual ~Sweeper();
			virtual void ColorLeft(const CR::Math::Color32 &_color)
			{
				m_vertices[0].Color = _color;
				m_vertices[1].Color = _color;
			}
			virtual void ColorRight(const CR::Math::Color32 &_color)
			{
				m_vertices[2].Color = _color;
				m_vertices[3].Color = _color;
				m_vertices[4].Color = _color;
				m_vertices[5].Color = _color;
			}
			
			virtual int GetZ() const { return m_z; }
			virtual void Render() {m_visible = true;}
			virtual void Update();
			virtual void RenderActual();
			virtual void Release();
			virtual void ClearVisible() {m_visible = false;}
			virtual bool Visible() const {return m_visible;}
			virtual void Visible(bool _visible) {m_visible = _visible;}
			virtual void SetImage(int pallette_entry);
			
			virtual void Position(int _x,int _y)
			{
				m_position.X(_x);
				m_position.Y(_y);
			};
			
			virtual void SweepTime(float _time) {m_sweepTime = _time;}
			virtual void Start() {m_sweeping = true; Reset();}
			virtual void Reset() {m_sweep = 0;}
			virtual void TransitionWidth(float _transWidth) {m_transitionWidth = _transWidth;}
		private:
			bool m_visible;
			Vertex m_vertices[8];
			unsigned short m_indices[18];
			int m_imageNumber;
			int m_z;
			CR::Math::PointF m_position;
			TextureStruct *m_texture;
			float m_sweep;
			float m_sweepTime;
			bool m_sweeping;
			float m_transitionWidth;
			
			void GetUVBounds(GLfloat &_left,GLfloat &_right,GLfloat &_top,GLfloat &_bot);
		};
	}
}
