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

---@class Map: Any
---@field data table 数据表
local Map = Class("Map")
local builder = Map.builder

-- 设置命名构造方法
builder.ctor = { "new" }
-- 设置主构造方法
builder.mainCtor = "new"

function builder:fields()
	self.data = {}
end

function Map:new()
end

--- 遍历
---@return fun(table: table,index: any): any, table
function Map:each()
	return next, self.data
end

function Map.Meta:__index(key)
	local data = rawget(self, key)
	if data ~= nil then
		return data
	end
	return rawget(self.data, key)
end

function Map.Meta:__newindex(key, value)
	rawset(self.data, key, value)
end

function Map.Meta:__tostring()
	if not self:isInstance() then
		return Map:getSuperMeta().__tostring(self)
	end
	local str = {}
	for k, v in self:each() do
		str[#str + 1] = string.format("%s:%s", tostring(k), tostring(v))
	end
	return string.format("%s{%s}", self:getClassName(), table.concat(str, ", "))
end

builder:build()

local map1 = Map()
local map2 = Map()
map1.a = 1
map1.b = 2
map2.a = 3
map2.b = 4
print(map1:instanceOf(Map))
print(map1)