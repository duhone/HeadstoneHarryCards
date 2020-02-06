/*
 *  SceneGraph.cpp
 *  Bumble Tales
 *
 *  Created by Eric Duhon on 8/13/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SceneGraph.h"
#include <vector>
#include <functional>
#include <tr1/functional>
#include <tr1/unordered_map>
#include <map>
#include "Graphics.h"
#include "SpriteInternal.h"
#include "../../Utility/FunctionObjects.h"
#include "Vector.h"
#include "Special.h"

#include<OpenGLES/ES1/gl.h>
#include<OpenGLES/ES1/glext.h>

using namespace std;
using namespace std::tr1;
using namespace CR::Graphics;
using namespace CR::Utility;

namespace CR
{
	namespace Graphics
	{
		class Bucket
		{
		public:
			map<int,vector<SpriteInternal*> > m_sprites;
			vector<Special*> m_specials;
		};
		
		class SceneGraphImpl
		{
		public:
			void AddSprite(SpriteInternal *_sprite);
			void RemoveSprite(SpriteInternal *_sprite);
			void AddSpecial(Special *_special);
			void RemoveSpecial(Special *_special);
			int Size();
			void Render();
			int NumGroups();
			void BeginFrame();
		private:
			int GenerateKey(SpriteInternal *_sprite);
			void AddSprite(SpriteInternal *_sprite,int _key);
			void RemoveSprite(SpriteInternal *_sprite,int _key);
			
			std::vector<SpriteInternal*> m_sceneList;
			map<int,Bucket, greater<int> > m_sceneGraph;	
			std::vector<Special*> m_specialList;
		};	
	}
}
	
			
SceneGraph::SceneGraph() : m_impl(new SceneGraphImpl())
{
}

void SceneGraph::AddSprite(SpriteInternal *_sprite)
{
	m_impl->AddSprite(_sprite);
}

void SceneGraph::RemoveSprite(SpriteInternal *_sprite)
{
	m_impl->RemoveSprite(_sprite);
}

void SceneGraph::AddSpecial(Special *_special)
{
	m_impl->AddSpecial(_special);
}

void SceneGraph::RemoveSpecial(Special *_special)
{
	m_impl->RemoveSpecial(_special);
}

int SceneGraph::Size()
{
	return m_impl->Size();
}

void SceneGraph::Render()
{
	m_impl->Render();
}

int SceneGraph::NumGroups()
{
	return m_impl->NumGroups();
}

void SceneGraph::BeginFrame()
{
	m_impl->BeginFrame();
}

int SceneGraphImpl::GenerateKey(SpriteInternal *_sprite)
{
	//return (_sprite->GetImage() << 16) | _sprite->GetFrameSet();
	return _sprite->GetTextureId();
}

void SceneGraphImpl::AddSpecial(Special *_special)
{
	m_specialList.push_back(_special);
	m_sceneGraph[_special->GetZ()].m_specials.push_back(_special);
}

void SceneGraphImpl::RemoveSpecial(Special *_special)
{	
	vector<Special*>::iterator iterator = find(m_specialList.begin(),m_specialList.end(),_special);
	if(iterator != m_specialList.end())
	{
		UnorderedRemove(m_specialList,iterator);
	}	
	
	if(m_sceneGraph.count(_special->GetZ()) == 0)
		return;
	vector<Special*> &bucket = m_sceneGraph[_special->GetZ()].m_specials;
	vector<Special*>::iterator bucketIterator = find(bucket.begin(),bucket.end(),_special);
	if(bucketIterator != bucket.end())
	{
		UnorderedRemove(bucket,bucketIterator);
	}
	if(bucket.empty() && m_sceneGraph[_special->GetZ()].m_sprites.empty())
	{
		m_sceneGraph.erase(_special->GetZ());
	}
}

void SceneGraphImpl::AddSprite(SpriteInternal *_sprite)
{
	AddSprite(_sprite,GenerateKey(_sprite));
		
	m_sceneList.push_back(_sprite);
}

void SceneGraphImpl::RemoveSprite(SpriteInternal *_sprite)
{	
	RemoveSprite(_sprite,GenerateKey(_sprite));
	
	vector<SpriteInternal*>::iterator iterator = find(m_sceneList.begin(),m_sceneList.end(),_sprite);
	if(iterator != m_sceneList.end())
	{
		UnorderedRemove(m_sceneList,iterator);
	}		
}

void SceneGraphImpl::AddSprite(SpriteInternal *_sprite,int _key)
{	
	//unordered_map<int,vector<SpriteInternal*> > &bucket = m_scene_graph[_sprite->GetZ()];
	/*if(bucket.count(_key) == 0)
	{
		bucket.insert(make_pair(_key, vector<SpriteInternal*>()));
	}
	bucket[_key].push_back(_sprite);*/
	m_sceneGraph[_sprite->GetZ()].m_sprites[_key].push_back(_sprite);
}

void SceneGraphImpl::RemoveSprite(SpriteInternal *_sprite,int _key)
{
	if(m_sceneGraph.count(_sprite->GetZ()) == 0)
		return;
	map<int,vector<SpriteInternal*> > &bucket = m_sceneGraph[_sprite->GetZ()].m_sprites;
	if(bucket.count(_key) == 0)
		return;
	vector<SpriteInternal*> &sprites = bucket[_key];
	vector<SpriteInternal*>::iterator iterator = find(sprites.begin(),sprites.end(),_sprite);
	if(iterator != sprites.end())
	{
		UnorderedRemove(sprites,iterator);
	}
	if(sprites.empty())
	{
		bucket.erase(_key);
	}
	if(bucket.empty() && m_sceneGraph[_sprite->GetZ()].m_specials.empty())
		m_sceneGraph.erase(_sprite->GetZ());
}

int SceneGraphImpl::Size()
{
	return m_sceneList.size()+m_specialList.size();
}

void SceneGraphImpl::Render()
{
	
	ForEach(m_specialList,mem_fun(&Special::Update));	
	vector<SpriteInternal*>::iterator sprite_iterator = m_sceneList.begin();
	vector<SpriteInternal*>::iterator end_sprite_iterator = m_sceneList.end();
	while(sprite_iterator != end_sprite_iterator)
	{		
		(*sprite_iterator)->Update();
		if(GenerateKey((*sprite_iterator)) != (*sprite_iterator)->GetOldTextureId())
		{
			RemoveSprite((*sprite_iterator),(*sprite_iterator)->GetOldTextureId());
			AddSprite((*sprite_iterator),GenerateKey((*sprite_iterator)));
		}
		++sprite_iterator;	
	}		
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glEnable(GL_TEXTURE_2D);
	
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);	
	
	vector<Vertex> vertices;
	vector<GLushort> indices;
	
	
	map<int,Bucket >::iterator sceneBegin = m_sceneGraph.begin();
	map<int,Bucket >::iterator sceneEnd = m_sceneGraph.end();
	while(sceneBegin != sceneEnd)
	{
		map<int,std::vector<SpriteInternal*> >::iterator iterator = sceneBegin->second.m_sprites.begin();
		map<int,std::vector<SpriteInternal*> >::iterator end = sceneBegin->second.m_sprites.end();
		while(iterator != end)
		{
			glEnable(GL_TEXTURE_2D);
			
			glEnableClientState(GL_VERTEX_ARRAY);
			glEnableClientState(GL_TEXTURE_COORD_ARRAY);
			glEnableClientState(GL_COLOR_ARRAY);	
			glBindTexture(GL_TEXTURE_2D,iterator->first);
			vertices.clear();
			indices.clear();	
			std::vector<SpriteInternal*>::iterator sprite_iterator = iterator->second.begin();
			std::vector<SpriteInternal*>::iterator end_sprite_iterator = iterator->second.end();
			while(sprite_iterator != end_sprite_iterator)
			{
				SpriteInternal *sprite = (*sprite_iterator);
				if(sprite->Visible())
				{
					if(sprite->IsClipping())
					{
						vector<Vertex> vertices;
						vector<GLushort> indices;
						sprite->Render(vertices,indices);
						
						CR::Math::RectangleI &clip = sprite->GetClip();
						
						glEnable(GL_SCISSOR_TEST);
						glScissor(clip.Left(), clip.Top(), clip.Width(), clip.Height());
						
						glVertexPointer(3, GL_FLOAT, sizeof(Vertex), &(vertices[0]));
						glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &(vertices[0].U));
						glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(Vertex), &(vertices[0].Color));
						
						glDrawElements(GL_TRIANGLES, indices.size(),GL_UNSIGNED_SHORT, &(indices[0]));
						glDisable(GL_SCISSOR_TEST);					
						
					}
					else
						sprite->Render(vertices,indices);
				}
				++sprite_iterator;	
			}			
							
			glVertexPointer(3, GL_FLOAT, sizeof(Vertex), &(vertices[0]));
			glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &(vertices[0].U));
			glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(Vertex), &(vertices[0].Color));
			
			glDrawElements(GL_TRIANGLES, indices.size(),GL_UNSIGNED_SHORT, &(indices[0]));
			
					
			++iterator;
		}
		std::vector<Special*>::iterator special_iterator = sceneBegin->second.m_specials.begin();
		std::vector<Special*>::iterator end_special_iterator = sceneBegin->second.m_specials.end();
		while(special_iterator != end_special_iterator)
		{
			Special *special = (*special_iterator);
			if(special->Visible())
			{
				special->RenderActual();
			}
			++special_iterator;	
		}	
		++sceneBegin;
	}
}

int SceneGraphImpl::NumGroups()
{
	return m_sceneGraph.size();
}

void SceneGraphImpl::BeginFrame()
{
	//ForEach(m_sceneList,mem_fun(&SpriteInternal::ClearVisible));	
	//ForEach(m_specialList,mem_fun(&Special::ClearVisible));	
}	

