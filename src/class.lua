---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/30 17:14
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---


--- Class 构建器
---@class ClassBuilder
---@field class Any 归属类
---@field fields table 初始化成员
---@field className string 类名称
local ClassBuilder = {}

--- Class 基类
---@class Any
---@field builder ClassBuilder|nil
local Any = {}

--- Class 构建时元表
local Meta = {
	__newindex = function(self, key, value)
	end
}

--- 创建 Class
---@return Any
local function Class()
	-- 实例化对象
	---@type ClassBuilder
	local builder = ClassBuilder:new()
	---@type Any
	local cls = setmetatable({ builder = builder }, Meta)

	-- 为构建器绑定归属类
	builder.class = cls

	-- 返回 Class 对象
	return cls
end

--- 实例化构建器
---@private
---@return ClassBuilder
function ClassBuilder:new()
	local o = { __index = self }
	return setmetatable(o, o)
end

-- 设置元方法
---@private
Any.__name = "Any"

-- 返回顶级函数
return Class