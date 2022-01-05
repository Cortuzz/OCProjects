Interval = {}

function Interval:new(border, color, upper_text)
    local data= {}
        data.border = border
        data.color = color
        data.text = upper_text

    function data:getColor()
        return self.color
    end

    function data:getText()
      return self.text
    end

    function data:getBorder()
      return self.border
    end

    setmetatable(data, self)
    self.__index = self; return data
end

temperature_control = {Interval:new(1, 0x8B0000, "AUTO OFF"), Interval:new(0.9, 0xFF8C00, "OVERHEAT"), Interval:new(0.65, 0x006400)}
