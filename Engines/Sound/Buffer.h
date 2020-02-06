/*
 *  Buffer.h
 *  Bumble Tales
 *
 *  Created by Eric Duhon on 8/29/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once

#include "DatabaseFwd.h"
#include "IDecompressor.h"

namespace CR
{
	namespace Sound
	{		
		class Buffer
		{
		public:
			Buffer(const CR::Database::IRecord* const _record);
			~Buffer();
			unsigned int OpenALID() {return m_id;}
		private:
			unsigned short* m_data;
			unsigned int m_id;
		};
	}
}
