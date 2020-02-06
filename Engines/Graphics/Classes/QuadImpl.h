/*
 *  QuadImpl.h
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/16/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once
#include "Graphics.h"
#include "Special.h"
#include "Vertex.h"

namespace CR
{
	namespace Graphics
	{
		class QuadImpl : public Quad, public Special
		{
		public:
			QuadImpl(int _zInitial);
			virtual ~QuadImpl();
		
			virtual void TopLeft(float _x,float _y) {m_vertices[2].X = _x-160; m_vertices[2].Y = 240-_y;}
			virtual void TopRight(float _x,float _y) {m_vertices[3].X = _x-160; m_vertices[3].Y = 240-_y;}
			virtual void BottomLeft(float _x,float _y) {m_vertices[0].X = _x-160; m_vertices[0].Y = 240-_y;}
			virtual void BottomRight(float _x,float _y) {m_vertices[1].X = _x-160; m_vertices[1].Y = 240-_y;}
			virtual void Color(const CR::Math::Color32 &_color)
			{
				m_vertices[0].Color = _color;
				m_vertices[1].Color = _color;
				m_vertices[2].Color = _color;
				m_vertices[3].Color = _color;
			}
			virtual int GetZ() const { return z; }
			virtual void Render() {m_visible = true;}
			virtual void Update();
			virtual void RenderActual();
			virtual void Release();
			virtual void ClearVisible() {m_visible = false;}
			virtual bool Visible() const {return m_visible;}
			virtual void Visible(bool _visible) {m_visible = _visible;}

		private:
			bool m_visible;
			VertexPC m_vertices[4];
			unsigned short m_indices[6];
			int z;
		};
	}
}
