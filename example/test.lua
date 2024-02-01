---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/31 16:20
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

local Class = require "class"

---@class Test1: Any
local Test = Class("Test1")
local builder = Test.builder

---@type number|string
Test.a = 1

---@return number
function Test.add(a, b)
	return a + b
end

builder:build()

print(Test.add(1, 2))