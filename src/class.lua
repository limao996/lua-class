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
---@field className string 类名称
---@field fields table 初始化成员
---@field extends Any 类继承
---@field methods function[] 类方法
---@field meta function[] 类方法
---@field ctor string[]|string 构造方法
local ClassBuilder = {
	className = "class",
	ctor = "new"
}

--- Class 基类
---@class Any
---@field builder ClassBuilder|nil 类构建器
local Any = {}

--- Class 构建时元表
local Meta = {
	__newindex = function(self, key, value)
		---@type ClassBuilder
		local builder = self.builder
		if type(value) == "function" then
			builder.methods = builder.methods or {}
			rawset(builder.methods, key, value)
		else
			builder.fields = builder.fields or {}
			rawset(builder.fields, key, value)
		end
	end
}

--- 创建 Class
---@param name string 类名称
---@param extends Any 继承类
---@return Any
local function Class(name, extends)
	-- 实例化对象
	---@type ClassBuilder
	local builder = ClassBuilder:new()
	---@type Any
	local cls = setmetatable({ builder = builder }, Meta)

	-- 初始化构建器属性
	builder.class = cls
	builder.className = name or builder.className
	builder.extends = extends or builder.extends

	-- 返回 Class 对象
	return cls
end

--- 实例化构建器
---@private
---@return ClassBuilder
function ClassBuilder:new()
	-- 创建构建器对象并返回
	local builder = { __index = self }
	return setmetatable(builder, builder)
end

--- 构建 Class
---@return void
function ClassBuilder:build()
	-- 获取归属类
	local class = self.class

	-- 重新设置元表
	setmetatable(class, class)

	-- 设置类名称
	rawset(class, "__name", self.className)

	-- 设置父类
	rawset(class, "__extends", self.extends)

	-- 初始化成员
	for k, v in pairs(self.fields) do
		rawset(class, k, v)
	end
end

-- 设置元方法
---@private
Any.__name = "Any"

-- 返回顶级函数
return Class