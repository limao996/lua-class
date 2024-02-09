---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/2/9 11:52
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
---@class MethodTest: Any
local Test = Class("MethodTest")
-- 获取Class构建器
local builder = Test.builder

-- 声明方法 方案1
function Test:say(content)
	print(self, content)
end

--[[ 声明方法 方案2
builder.methods = {
	say = function(self, content)
		print(self, content)
	end
}
]]

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
Test:say("Hi")
mTest:say("Hello")