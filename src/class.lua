---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/30 17:14
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

local _M = {}
local _ENV = setmetatable(_M, { __index = _G })

--- 获取内存地址
---@param obj table
---@return string
local function getAddress(obj)
	local str = tostring(obj)
	return str:match("(0?x?%x+)$")
end

local ClassMeta = {
	__tostring = function(self)
		local meta = self:getMeta()
		local address = meta.__address
		if not address then
			return string.format(
					"class %s",
					meta.__name)
		end
		return string.format(
				"class %s@%s",
				meta.__name, address)
	end
}

--- Class 基类
---@class Any
---@field builder ClassBuilder|nil 类构建器
---@field Meta table|nil 构建时类元表
---@field super Any 父类
Any = {}

---@field private __name string 类名称
---@field private __class Any 归属类
---@field private __address string 内存地址
---@field private __fields table|fun(self:Any):void 初始化成员
local AnyMeta = {
	__name = "Any",
	__tostring = ClassMeta.__tostring,
	__class = Any
}
-- 绑定元表
setmetatable(Any, AnyMeta)

--- Class 构建器
---@class ClassBuilder
---@field class Any 归属类
---@field className string 类名称
---@field address string 内存地址
---@field fields table|fun(self:Any):void 初始化成员
---@field extends Any 类继承
---@field methods function[] 类方法
---@field meta function[] 类方法
---@field ctor string[]|string 构造方法
---@field mainCtor string 主构造方法

local ClassBuilder = {
	className = "Any",
	ctor = "new",
	extends = Any,
}

--- 检查实例归属
---@param instance Any 类或实例
---@return boolean
function Any:instanceOf(instance)
	while true do
		if self:getClass() == instance:getClass() then
			return true
		end
		self = self.super
		if not self then
			return false
		end
	end
end

--- 获取类
---@return Any
function Any:getClass()
	return self:getMeta().__class
end

--- 获取类名称
---@return string
function Any:getClassName()
	return self:getMeta().__name
end

--- 是否为实例
---@return boolean
function Any:isInstance()
	return not not self:getMeta().__address
end

--- 获取父类
---@return Any
function Any:getSuper()
	return self.super
end

--- 获取类元表
---@return any
function Any:getMeta()
	return getmetatable(self)
end

--- 获取父类元表
---@return any
function Any:getSuperMeta()
	return getmetatable(self.super)
end

--- 创建实例
---@return self
function Any:newInstance()
	local instance = {}
	local meta = { __address = getAddress(instance) }
	for k, v in pairs(self:getMeta()) do
		meta[k] = v
	end
	meta.__index = self
	local fields = meta.__fields
	if fields then
		if type(fields) == "table" then
			for k, v in pairs(fields) do
				rawset(instance, k, v)
			end
		else
			fields(instance)
		end
	end
	return setmetatable(instance, meta)
end

--- 是否为实例
---@generic T
---@param fn fun(self:Any):T
---@return T
function Any:let(fn)
	return fn(self)
end

--- Class 构建时元表
local BuildMeta = {
	__index = function(self, key)
		if key == "Meta" then
			local builder = rawget(self, 'builder')
			local meta = builder.meta or {}
			builder.meta = meta
			return meta
		end
		return rawget(self, key)
	end,
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
		local builder = self.builder
		return string.format(
				"@Build -> class %s",
				builder.className)
	end,
}

--- 创建 Class
---@param name string 类名称
---@param extends Any 继承类
---@return Any
function Class(name, extends)
	-- 实例化对象
	---@type ClassBuilder
	local builder = ClassBuilder:new()
	---@type Any
	local cls = {
		builder = builder,
	}

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
	-- 获取元表
	local meta = self.meta or {}
	self.meta = meta

	-- 解除元表
	setmetatable(class, nil)

	-- 设置元属性
	rawset(meta, "__name", self.className)
	rawset(meta, "__class", class)
	rawset(meta, "__fields", self.fields)

	-- 设置父类
	local extends = self.extends
	if extends then
		rawset(meta, "__index", extends)
		rawset(class, "super", extends)
		for k, v in pairs(getmetatable(extends)) do
			if meta[k] == nil then
				meta[k] = v
			end
		end
	end

	-- 初始化成员
	local fields = self.fields
	if fields then
		if type(fields) == "table" then
			for k, v in pairs(fields) do
				rawset(class, k, v)
			end
		else
			fields(class)
		end
	end

	-- 初始化方法
	local methods = self.methods
	if methods then
		local ctor = self.ctor
		if type(ctor) == "string" then
			ctor = { ctor }
		end
		for k, v in pairs(ctor) do
			local method = methods[v]
			if method then
				methods[v] = function(self, ...)
					local instance = self:newInstance()
					method(instance, ...)
					return instance
				end
			end
		end
		for k, v in pairs(methods) do
			rawset(class, k, v)
		end
	end

	local mainCtor = self.mainCtor
	if mainCtor then
		meta.__call = rawget(class, mainCtor)
	end

	-- 解除构建状态
	setmetatable(class, meta)
	class.builder = nil
end

-- 加载到全局环境
for k, v in pairs(_M) do
	_G[k] = v
end
return _M