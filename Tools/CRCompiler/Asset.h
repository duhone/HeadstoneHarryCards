#pragma once
#include "..\Utility\Guid.h"
#include <iostream>

namespace CR
{
	namespace Compiler
	{
		class Asset
		{
		public:
			Asset(void);
			~Asset(void);
			const std::wstring& Name() const {return name;}
			void Name(const std::wstring &_name) {name = _name;}
			const CR::Utility::Guid& ID() {return id;}
			void ID(const std::wstring &_id) {id.Set(_id);}
			void ID(const CR::Utility::Guid &_id) {id = _id;}
			void AddChild(Asset *_child) {children.push_back(_child);}
			void GenerateFile(std::wofstream &_outputFile);
		private:
			void OutputAsset(std::wofstream &_outputFile,std::wstring _tabs);
			std::wstring name;
			CR::Utility::Guid id;
			std::vector<Asset*> children;
		};
	}
}
