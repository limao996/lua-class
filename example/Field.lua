---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/2/9 9:52
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

-- 导入class包
require "class"

-- 设置包名（一定不要在后面导入其它包）
Package("org.example")

-- 创建Class
--- 类
---@class FieldTest: Any
---@field field number 测试成员
local Test = Class("FieldTest")
-- 获取Class构建器
local builder = Test.builder

-- 静态初始化成员 方案1
-- Test.field = 0

--[[ 静态初始化成员 方案2
builder.fields = {
	field = 0
}
]]

-- 动态初始化成员
function builder:fields()
	self.field = 0
end

-- 如果有非共用对象，建议使用动态初始化，反之静态初始化
-- 仅在实例中存在的成员建议在构造方法中初始化（动态初始化会影响实例化效率）
-- 构建时只能选择一种方案，否则有概率出错

-- 实现构造方法
--- 实例化
---@return self 实例
function Test:new()
end

-- 构建Class
builder:build()

-- 测试
local mTest = Test()
Test.field = 1
mTest.field = 2
print(Test.field)
print(mTest.field)
