#include "StdAfx.h"
#include "Compressor.h"
#include "lzmalib.h"
#include "zlib.h"

#include "lzo/lzoconf.h"
#include "lzo/lzo1x.h"

Compressor::Compressor(unsigned char* _source,unsigned int unCompressedSize,Syntax::Utility::BinaryWriter &_file) : m_source(_source)
{
	size_t propSize = LZMA_PROPS_SIZE;
	unsigned char *props = new unsigned char[propSize];
	unsigned long compressedSize = static_cast<unsigned long>(unCompressedSize*1.5);
	unsigned char* compressed = new unsigned char[compressedSize];
	

	lzo_init();
	unsigned char* wrkmem = new unsigned char[LZO1X_999_MEM_COMPRESS];
	lzo1x_999_compress(_source,unCompressedSize,compressed,&compressedSize,wrkmem);
	lzo1x_optimize(compressed,compressedSize,_source,(lzo_uint*)&unCompressedSize,NULL);
	//compress2(compressed,&compressedSize,_source,unCompressedSize,9);

	//LzmaCompress(compressed,&compressedSize,m_source,unCompressedSize,
	//	props,&propSize,9,4*1024,-1,-1,-1,-1,-1);

	_file.Write((char*)props,propSize);
	_file.Write((char*)compressed,compressedSize);
	delete[] props;
	delete[] compressed;
	delete wrkmem;
}

Compressor::~Compressor(void)
{
}
