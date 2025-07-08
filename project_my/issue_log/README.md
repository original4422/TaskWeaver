# Issue Log 目录说明

## 目录作用
本目录用于记录TaskWeaver项目在使用过程中遇到的问题、解决方案和技术细节。

## 文件列表

### 1. deepseek_integration_issue.md
- **问题类型**: API集成问题
- **影响组件**: LLM服务模块
- **状态**: ✅ 已解决
- **关键词**: DeepSeek API, top_p参数, 参数验证

### 2. codeinterpreter_docker_issue.md
- **问题类型**: 代码执行环境问题
- **影响组件**: CodeInterpreter执行环境
- **状态**: ✅ 已解决
- **关键词**: Docker依赖, 执行模式, Container vs Local

## 使用建议

1. **问题记录**: 遇到新问题时，请按照现有格式创建新的markdown文件
2. **命名规范**: 使用`{问题类型}_{简短描述}_{日期}.md`的格式
3. **内容结构**: 包含问题描述、分析、解决过程、技术细节和后续建议

## 文档模板

创建新问题记录时，建议包含以下章节：
- 问题概述
- 错误信息
- 问题分析
- 解决过程
- 技术总结
- 后续改进建议

## 常见问题快速索引

### API相关问题
- **DeepSeek API集成**: 参见 `deepseek_integration_issue.md`
- **top_p参数错误**: 配置文件中添加 `"llm.top_p": 0.7`

### 执行环境问题
- **Docker连接错误**: 参见 `codeinterpreter_docker_issue.md` 
- **CodeInterpreter启动失败**: 设置 `"execution_service.kernel_mode": "local"`

### 配置问题
- **参数验证错误**: 确保配置文件包含所有必要参数
- **执行模式选择**: 开发环境推荐local模式，生产环境推荐container模式

---

**维护者**: TaskWeaver项目组
**最后更新**: 2025年7月8日 