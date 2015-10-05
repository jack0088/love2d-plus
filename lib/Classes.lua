-- Classes.lua
-- http://codea.io
-- Compatible with Lua >5.1 (not 5.0)

function class(base)
    local c = {} -- a new class instance
    if type(base) == 'table' then
        -- Our new class is a shallow copy of the base class!
        for i, v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end
    -- The class will be the metatable for all its objects, and they will look up their methods in it.
    c.__index = c
	
    -- Expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj, c)
        if class_tbl.init then
            class_tbl.init(obj, ...)
        else 
            -- Make sure that any stuff from the base class is initialized!
            if base and base.init then
                base.init(obj, ...)
            end
        end        
        return obj
    end
	
	-- Expose a method to check affiliation of two classes
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do 
            if m == klass then return true end
            m = m._base
        end
        return false
    end

    setmetatable(c, mt)
    return c
end