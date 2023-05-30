local table = table
local pairs = pairs
local type = type
local floor = math.floor
local gtable = require("gears.table")
local base = require("wibox.widget.base")

local align = {}

function align:layout(context, width, height)
    local result = {}

    local size_first = 0
    local size_remains = self._private.dir == "y" and height or width
    local size_second = 0
    local third_pos = { x = width, y = height }
    local size_third = 0

    if self._private.first then
        local w, h, _ = width, height, nil

        if self._private.dir == "y" then
            _, h = base.fit_widget(self, context, self._private.first, width, size_remains)
            size_first = h
            size_remains = size_remains - h
        else
            w, _ = base.fit_widget(self, context, self._private.first, size_remains, height)
            size_first = w
            size_remains = size_remains - w
        end
        table.insert(result, base.place_widget_at(self._private.first, 0, 0, w, h))
    end

    if self._private.third and size_remains > 0 then
        local w, h, _ = width, height, nil
        if self._private.dir == "y" then
            _, h = base.fit_widget(self, context, self._private.third, width, size_remains)
            size_third = h
            size_remains = size_remains - h
        else
            w, _ = base.fit_widget(self, context, self._private.third, size_remains, height)
            size_third = w
            size_remains = size_remains - w
        end
        local x, y = width - w, height - h
        third_pos = { x = x, y = y }
        table.insert(result, base.place_widget_at(self._private.third, x, y, w, h))
    end

    -- Now we want to position second as close on the middle as possible
    if self._private.second and size_remains > 0 then
        local x, y, w, h = 0, 0, width, height
        if self._private.dir == "y" then
            _, h = base.fit_widget(self, context, self._private.second, width, size_second)
            y = floor( (height - h)/2 )

            local end_y = y + w;
            local overflowed_top = false
            local overflowed_bottom = false

            if y < size_first then
                overflowed_top = true
                local overflow = size_first - y
                y = y + overflow
                end_y = y + w
            end

            if end_y > third_pos.y then
                overflowed_bottom = true
                local overflow = end_y - third_pos.y
                y = y - overflow
                end_y = y + w
            end

            if y < size_first then
                overflowed_top = true
            end

            if overflowed_top and overflowed_bottom then
                y = size_first
                w = size_remains
            end
        else
            w, _ = base.fit_widget(self, context, self._private.second, size_remains, height)
            x = floor( (width -w)/2 )
            local end_x = x + w;
            local overflowed_left = false
            local overflowed_right = false

            if x < size_first then
                overflowed_left = true
                local overflow = size_first - x
                x = x + overflow
                end_x = x + w
            end

            if end_x > third_pos.x then
                overflowed_right = true
                local overflow = end_x - third_pos.x
                x = x - overflow
                end_x = x + w
            end

            if x < size_first then
                overflowed_left = true
            end

            if overflowed_left and overflowed_right then
                x = size_first
                w = size_remains
            end
        end
        table.insert(result, base.place_widget_at(self._private.second, x, y, w, h))
    end
    return result
end

--- The widget in slot one.
--
-- This is the widget that is at the left/top.
--
-- @property first
-- @tparam[opt=nil] widget|nil first
-- @propertytype nil This spot will be empty. Depending on how large the second
--  widget is an and the value of `expand`, it might mean it will leave an empty
--  area.
-- @propemits true false

function align:set_first(widget)
    if self._private.first == widget then
        return
    end
    self._private.first = widget
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::first", widget)
end

--- The widget in slot two.
--
-- This is the centered one.
--
-- @property second
-- @tparam[opt=nil] widget|nil second
-- @propertytype nil When this property is `nil`, then there will be an empty
--  area.
-- @propemits true false

function align:set_second(widget)
    if self._private.second == widget then
        return
    end
    self._private.second = widget
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::second", widget)
end

--- The widget in slot three.
--
-- This is the widget that is at the right/bottom.
--
-- @property third
-- @tparam[opt=nil] widget|nil third
-- @propertytype nil This spot will be empty. Depending on how large the second
--  widget is an and the value of `expand`, it might mean it will leave an empty
--  area.
-- @propemits true false

function align:set_third(widget)
    if self._private.third == widget then
        return
    end
    self._private.third = widget
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::third", widget)
end

for _, prop in ipairs {"first", "second", "third", "expand" } do
    align["get_"..prop] = function(self)
        return self._private[prop]
    end
end

function align:get_children()
    return gtable.from_sparse {self._private.first, self._private.second, self._private.third}
end

function align:set_children(children)
    self:set_first(children[1])
    self:set_second(children[2])
    self:set_third(children[3])
end

-- Fit the align layout into the given space. The align layout will
-- ask for the sum of the sizes of its sub-widgets in its direction
-- and the largest sized sub widget in the other direction.
-- @param context The context in which we are fit.
-- @param orig_width The available width.
-- @param orig_height The available height.
function align:fit(context, orig_width, orig_height)
    local used_in_dir = 0
    local used_in_other = 0

    for _, v in pairs{self._private.first, self._private.second, self._private.third} do
        local w, h = base.fit_widget(self, context, v, orig_width, orig_height)

        local max = self._private.dir == "y" and w or h
        if max > used_in_other then
            used_in_other = max
        end

        used_in_dir = used_in_dir + (self._private.dir == "y" and h or w)
    end

    if self._private.dir == "y" then
        return used_in_other, used_in_dir
    end
    return used_in_dir, used_in_other
end

function align:reset()
    for _, v in pairs({ "first", "second", "third" }) do
        self[v] = nil
    end
    self:emit_signal("widget::layout_changed")
end

local function get_layout(dir, first, second, third)
    local ret = base.make_widget(nil, nil, {enable_properties = true})
    ret._private.dir = dir

    for k, v in pairs(align) do
        if type(v) == "function" then
            rawset(ret, k, v)
        end
    end

    ret:set_first(first)
    ret:set_second(second)
    ret:set_third(third)

    -- An align layout allow set_children to have empty entries
    ret.allow_empty_widget = true

    return ret
end

--- Returns a new horizontal align layout.
--
-- The three widget slots are aligned left, center and right.
--
-- Additionally, this creates the aliases `set_left`, `set_middle` and
-- `set_right` to assign @{first}, @{second} and @{third} respectively.
-- @constructorfct wibox.layout.align.horizontal
-- @tparam[opt] widget left Widget to be put in slot one.
-- @tparam[opt] widget middle Widget to be put in slot two.
-- @tparam[opt] widget right Widget to be put in slot three.
function align.horizontal(left, middle, right)
    local ret = get_layout("x", left, middle, right)

    rawset(ret, "set_left"  , ret.set_first  )
    rawset(ret, "set_middle", ret.set_second )
    rawset(ret, "set_right" , ret.set_third  )

    return ret
end

--- Returns a new vertical align layout.
--
-- The three widget slots are aligned top, center and bottom.
--
-- Additionally, this creates the aliases `set_top`, `set_middle` and
-- `set_bottom` to assign @{first}, @{second} and @{third} respectively.
-- @constructorfct wibox.layout.align.vertical
-- @tparam[opt] widget top Widget to be put in slot one.
-- @tparam[opt] widget middle Widget to be put in slot two.
-- @tparam[opt] widget bottom Widget to be put in slot three.
function align.vertical(top, middle, bottom)
    local ret = get_layout("y", top, middle, bottom)

    rawset(ret, "set_top"   , ret.set_first  )
    rawset(ret, "set_middle", ret.set_second )
    rawset(ret, "set_bottom", ret.set_third  )

    return ret
end

--@DOC_fixed_COMMON@

return align

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80