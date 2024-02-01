---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/31 16:20
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

require "class"

---@class Parent1: Any
local Parent = Class("Parent1")
local builder = Parent.builder
builder:build()

---@class Test1: Parent1
local Test = Class("Test1", Parent)
local builder = Test.builder

---@type number|string
Test.a = 1

---@param a number
---@param b number
---@return number
function Test.add(a, b)
	return a + b
end

builder:build()

print(Test.super)
print(Test:instanceOf(Parent))
print(Test:instanceOf(Any))

---@param it Parent1
Test.super:let(function(it)
	print(it:getClassName())
	print(it:isInstance())
	print(it.super)
end)