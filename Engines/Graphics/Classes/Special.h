/*
 *  Special.h
 *  Headstone Harry
 *
 *  Created by Eric Duhon on 10/17/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once

namespace CR
{
	namespace Graphics
	{
		class Special
		{
		public:
			virtual void RenderActual() = 0;
			virtual int GetZ() const = 0;
			virtual void ClearVisible() = 0;
			virtual bool Visible() const = 0;
			virtual void Update() = 0;
		};
	}
}
