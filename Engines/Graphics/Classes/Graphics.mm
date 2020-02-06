#include "Graphics.h"
#include "GraphicsEngineInternal.h"

using namespace CR::Graphics;

GraphicsEngineInternal *gengine = NULL;

/*void GENEW(void *arg)
{
	if(arg == NULL)
	{
	//	exit(0);
	}
};*/

GraphicsEngine* CR::Graphics::GetGraphicsEngine()
{
	if(gengine == NULL)
	{
		gengine = new GraphicsEngineInternal();
		//GENEW(gengine);
	}
	gengine->AddRef();
	return gengine;
}