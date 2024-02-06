---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/2/6 12:15
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

-- 导入class包
require "class"

-- 设置包名（一定不要在后面导入其它包）
Package("org.example")

-- 创建父类
--- 父类
---@class Parent: Any
---@field name string 名字
---@field age number 年龄
local Parent = Class("Parent")
local builder = Parent.builder

-- 实现构造方法
--- 实例化
---@param name string 名字
---@param age number 年龄
---@return self 实例
function Parent:new(name, age)
	self.name = name
	self.age = age
end

-- 声明方法
--- 发言
---@param content string 内容
---@return void
function Parent:say(content)
	local fmt = "%s(%d岁): %s"
	print(fmt:format(self.name, self.age, content))
end

builder:build()

-- 创建子类并继承父类
--- 子类
---@class Child: Parent
---@field origin string 籍贯
local Child = Class("Child", Parent)
local builder = Child.builder

-- 也可以在构建器中声明
-- local Child = Class("Child")
-- local builder = Child.builder
-- builder.extends = Parent

-- 重写构造方法
--- 实例化
---@param name string 名字
---@param age number 年龄
---@param origin string 籍贯
---@return self 实例
function Child:new(name, age, origin)
	-- 获取父类
	local Super = Child.super
	-- 调用父类的new方法
	Super.new(self, name, age)
	-- 赋值
	self.origin = origin
	print(self.name, self.age, self.origin)
end

-- 重写方法
--- 发言
---@param content string 内容
---@return void
function Child:say(content)
	local fmt = "%s(%d岁) - %s: %s"
	print(fmt:format(self.name, self.age, self.origin, content))
end

builder:build()

local me = Parent("Parent", 48)
local you = Child("Child", 22, "China")

me:say("Hi")
you:say("Hello")