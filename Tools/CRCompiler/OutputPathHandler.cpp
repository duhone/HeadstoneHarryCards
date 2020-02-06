#include "StdAfx.h"
#include "OutputPathHandler.h"
#include "CompilerImpl.h"

using namespace CR;
using namespace CR::Compiler;
using namespace boost;

OutputPathHandler::OutputPathHandler(void)
{
}

OutputPathHandler::~OutputPathHandler(void)
{
}

void OutputPathHandler::HandleAttribute(const std::wstring &name,const std::wstring& value)
{
	if(to_lower_copy(name) == L"path")
		CompilerImpl::Instance().AddOutputPath(value);
}