#pragma once
#include "icompiler.h"
#include<vector>
#include <hash_map>
#include <hash_set>
#include "..\Utility\Singleton.h"

namespace CR
{
	namespace Compiler
	{
		class NodeHandler;
		class INodeHandler;
		class INodeCompiler;
		class TopCompiler;
		class Asset;

		class CompilerImpl :
			public ICompiler, public CR::Utility::Singleton<CompilerImpl>
		{
			friend Singleton<CompilerImpl>;
		public:
			void Init(const std::wstring &compilerPath,const std::wstring &dataPath,const std::wstring &dataFile);
			virtual const std::wstring& CompilerPath();
			virtual const std::wstring& DataPath();
			NodeHandler* GetHandler(std::wstring name);
			void Run();
			void Compile();
			void BuildAssetList();
			void AddOutputPath(std::wstring path) {outputPaths.push_back(path);}
			void AddAssetPath(std::wstring path) {assetPaths.push_back(path);}
			void SetTop(CR::Compiler::INodeCompiler *top);
			virtual bool SettingExists(const std::wstring &setting) const;
			virtual const std::wstring* GetSettingValue(const std::wstring &setting) const;
			virtual void AddSetting(const std::wstring &name,const std::wstring &value);
			virtual void AddAssetSection(const std::wstring &section) {assetSections.insert(boost::to_lower_copy(section));}
			virtual bool ContainsSection(const std::wstring &section) {return assetSections.count(boost::to_lower_copy(section)) != 0;}
		private:
			CompilerImpl() {};
			virtual ~CompilerImpl(void);
			void LoadPlugins();
			void AddHandler(INodeHandler* handler);
			std::wstring compilerPath;
			std::wstring dataPath;
			std::wstring dataFile;
			std::vector<HMODULE> plugins;
			stdext::hash_map<std::wstring,NodeHandler*> handlers;
			std::vector<std::wstring> outputPaths;
			std::vector<std::wstring> assetPaths;
			CR::Compiler::TopCompiler *top;
			Asset *topAsset;
			void CopyFiles(void);
			stdext::hash_map<std::wstring,std::wstring> settings;
			stdext::hash_set<std::wstring> assetSections;
		};
	}
}
