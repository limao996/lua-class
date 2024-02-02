---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/30 17:08
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

require "class"

-- 声明父类 class
---@class Parent: Any 父类
local Parent = Class()
-- 获取构建器
local builder = Parent.builder

-- 声明静态方法
--- 加法
---@param n number 被加数
---@return number 结果
function Parent.add(n)
	return n + 1
end

-- 构建 class
builder:build()

-- 声明 class
---@class Test: Parent 测试
---@field name string 名字
---@field age number 年龄
local Test = Class("Test", Parent)
-- 获取构建器
local builder = Test.builder

-- 初始化 class 成员
builder.fields = {
	name = 'limao996',
	age = 22
}

-- 设置构造方法
builder.ctor = { "new" }

-- 声明 class 方法
--- 静态方法
---@param t table 表单
---@return Test 对象
function Test.fromTable(t)
	local o = Test:new()
	o.name = t.name
	o.age = t.age
	return o
end

--- 构造方法
---@return self
function Test:new()
end

--- 对象方法
---@param n number 年龄
---@return void
function Test:setAge(n)
	self.age = n
	return self
end

-- 重写父类方法
--- 加法
---@param a number 被加数
---@param b number 加数
---@return number 结果
function Test.add(a, b)
	return Test.super.add(a) - 1 + b
end

-- 构建 class
builder:build()
-- 返回 class
return Test