/*
 *  Sound.cpp
 *  Steph
 *
 *  Created by Eric Duhon on 5/30/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "Sound.h"
#include "SoundImpl.h"

using namespace CR::Utility;
using namespace CR::Sound;

ISound::ISound() : m_soundImpl(new SoundImpl())
{
	
}

void ISound::SetDatabase(CR::Database::IDatabase* const _database)
{
	m_soundImpl->SetDatabase(_database);
}

std::tr1::shared_ptr<ISoundFX> ISound::CreateSoundFX(const CR::Utility::Guid &_id)
{
	return m_soundImpl->CreateSoundFX(_id);
}

void ISound::PlaySong(const CR::Utility::Guid &_id)
{
	return m_soundImpl->PlaySong(_id);	
}

void ISound::Tick()
{
	m_soundImpl->Tick();
}

void ISound::MuteMusic(bool _mute)
{
	m_soundImpl->MuteMusic(_mute);	
}

void ISound::MuteSounds(bool _mute)
{
	m_soundImpl->MuteSounds(_mute);	
}

