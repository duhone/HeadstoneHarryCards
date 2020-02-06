/*
 *  Buffer.cpp
 *  Bumble Tales
 *
 *  Created by Eric Duhon on 8/29/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Buffer.h"
#include "Database.h"
#include <OpenAL/al.h>
#include <OpenAL/alc.h>
#include "OpenAL/oalStaticBufferExtension.h"
#include "OpenAL/oalMacOSX_OALExtensions.h"
#include "OGGHelper.h"
#include "DecompressorFactory.h"

using namespace std;
using namespace std::tr1;
using namespace CR::Sound;
using namespace CR::Database;

Buffer::Buffer(const CR::Database::IRecord* const _record) : m_data(NULL)
{
	std::auto_ptr<IRecordData> data = _record->GetData();
	long dataSize,compressedSize;
	long compressionType;
	(*data.get()) >> dataSize >> compressedSize >> compressionType;
	
	shared_ptr<IDecompressor> decompressor(DecompressorFactory::Instance().Create(compressionType));
	decompressor->Init(*data.get(),compressedSize,dataSize);

	m_data = decompressor->DecompressFull();
			
	alGenBuffers(1, &m_id);
	
	alBufferDataStaticProcPtr alBufferDataStaticProc = (alBufferDataStaticProcPtr)alcGetProcAddress(NULL, (const ALCchar *)"alBufferDataStatic");	
	alBufferDataStaticProc(m_id,AL_FORMAT_MONO16,m_data,dataSize,16000);
}

Buffer::~Buffer()
{	
	alDeleteBuffers(1, &m_id);
	delete[] m_data;
}
