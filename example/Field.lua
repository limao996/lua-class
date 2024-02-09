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
local FieldTest = Class("FieldTest")
-- 获取Class构建器
local builder = FieldTest.builder

-- 静态初始化成员 方案1
-- TestField.field = 0

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

-- 实现构造方法
--- 实例化
---@return self 实例
function FieldTest:new()
end

-- 构建Class
builder:build()

-- 测试
local mFieldTest = FieldTest()
FieldTest.field = 1
mFieldTest.field = 2
print(FieldTest.field)
print(mFieldTest.field)
