---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/30 17:14
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

--- 获取内存地址
---@param obj table
---@return string
local function getAddress(obj)
	local str = tostring(obj)
	return str:match("(0?x?%x+)$")
end

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
---@field super Any 父类
---@field private __name string 类名称
---@field private __address string 内存地址
local Any = {}

--- Class 构建时元表
local BuildMeta = {
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
	end,
	__tostring = function(self)
		return string.format(
				"@Build -> class %s: %s",
				self.builder.className,
				self.__address)
	end,
	__type = function(self)
		return string.format(
				"@Build -> class %s",
				self.builder.className)
	end
}

local ClassMeta = {
	__tostring = function(self)
		return string.format(
				"class %s: %s",
				self.__name,
				self.__address)
	end,
	__type = function(self)
		return string.format("class %s", self.__name)
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
	local cls = {
		builder = builder,
		__tostring = ClassMeta.__tostring,
		__type = ClassMeta.__type,
	}

	-- 记录内存地址
	cls.__address = getAddress(cls)

	-- 初始化构建器属性
	builder.class = cls
	builder.className = name or builder.className
	builder.extends = extends or builder.extends

	-- 返回 Class 对象
	return setmetatable(cls, BuildMeta)
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

	-- 解除构建状态
	setmetatable(class, class)
	class.builder = nil

	-- 设置类名称
	rawset(class, "__name", self.className)

	-- 设置父类
	rawset(class, "__index", self.extends)
	rawset(class, "super", self.extends)

	-- 初始化成员
	if self.fields then
		for k, v in pairs(self.fields) do
			rawset(class, k, v)
		end
	end


	-- 初始化方法
	if self.methods then
		for k, v in pairs(self.methods) do
			rawset(class, k, v)
		end
	end
end

-- 设置元方法
---@private
Any.__name = "Any"

---@class Number:Any
local Number = 0

-- 返回顶级函数
return Class