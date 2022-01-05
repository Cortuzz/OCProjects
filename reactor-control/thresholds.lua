Interval = {}

function Interval:new(border, color, upper_text, text_color)
    local data= {}
        data.border = border
        data.color = color
        data.text = upper_text
        data.text_color = text_color

        if not text_color then
          data.text_color = color
        end

    function data:getColor()
        return self.color
    end

    function data:getText()
      return self.text
    end

    function data:getTextColor()
      return self.text_color
    end

    function data:getBorder()
      return self.border
    end

    setmetatable(data, self)
    self.__index = self; return data
end

temperature_control = {
Interval:new(1, 0x8B0000, " DANGER "),
Interval:new(0.9, 0xFF8C00, "OVERHEAT"),
Interval:new(0.65, 0x006400)
}

coolant_control = {
Interval:new(1, 0xFF8C00, "OVERFLOW"),
Interval:new(0.95, 0x006400, "LOW LEVEL", 0xFF8C00),
Interval:new(0.25, 0xFF8C00, " DANGER ", 0x8B0000),
Interval:new(0.1, 0x8B0000)
}

hot_coolant_control = {
Interval:new(1, 0x8B0000, " DANGER "),
Interval:new(0.9, 0xFF8C00, "OVERFLOW"),
Interval:new(0.6, 0x006400, "LOW LEVEL", 0xFF8C00),
Interval:new(0.1, 0xFF8C00)
}
