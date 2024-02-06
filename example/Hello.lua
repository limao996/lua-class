---
--- Project Name: lua-class
--- Created by limao996.
--- DateTime: 2024/1/30 17:08
---
--- Open Source:
--- [Gitee](https://gitee.com/limao996/lua-class)
--- [Github](https://github.com/limao996/lua-class)
---

-- 导入class包
require "class"

-- 设置包名（一定不要在后面导入其它包）
Package("org.example")

-- 创建Class并使用EmmyLua注解插件添加Class声明并继承Any类，以获得智能补全支持
--- 类
---@class Person: Any
---@field name string 名字
---@field age number 年龄
---@field origin string 籍贯
local Person = Class("Person")
-- 获取Class构建器
local builder = Person.builder
-- 初始化成员
Person.origin = "China"

-- 实现构造方法，默认构造方法为new
-- 构造方法将传入实例为self，也将自动返回实例
-- 无需手动return
--- 实例化
---@param name string 名字
---@param age number 年龄
---@return self 实例
function Person:new(name, age)
	self.name = name
	self.age = age
end

-- 声明方法
--- 发言
---@param content string 内容
---@return void
function Person:say(content)
	local fmt = "%s(%d岁) - %s: %s"
	print(fmt:format(self.name, self.age, self.origin, content))
end

-- 构建Class
builder:build()

-- 使用主构造方法实例化，默认主构造方法为new
-- 主构造方法没有补全支持
local me = Person("Limao", 22)
-- 使用命名构造方法实例化，默认命名构造方法为new
local you = Person:new("Unknown", 18)

-- 调用方法
me:say("Hello")
you:say("Hi")

-- 打印类和对象
print(Person)
print(me)
print(you)