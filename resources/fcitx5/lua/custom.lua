--
-- Custom fcitx5 imeapi extension (loaded by luaaddonloader).
-- Adds a calculator and a weekday command on top of the built-in sj/rq/fh.
-- Invoke via the QuickPhrase trigger (in 中文 mode: ';' then the command).
--
local fcitx = require("fcitx")

-- Calculator:  js<expr>   e.g.  js(1+2)*3  ->  9     js2^10  ->  1024
function custom_calc(input)
    if input == nil or #input == 0 then
        return nil
    end
    -- Only allow safe arithmetic characters (no code injection).
    if string.find(input, "[^0-9%.%+%-%*/%%%^%(%) ]") then
        return nil
    end
    local chunk = load("return " .. input)
    if not chunk then
        return nil
    end
    local ok, res = pcall(chunk)
    if not ok or res == nil then
        return nil
    end
    if type(res) == "number" then
        if res == math.floor(res) and math.abs(res) < 1e15 then
            res = string.format("%d", res)
        else
            res = string.format("%.10g", res)
        end
    end
    return { tostring(res) }
end

-- Weekday:  xq  ->  星期X  (+ dated form)
local _WD = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }
function custom_weekday(input)
    local w = tonumber(os.date("%w")) + 1
    return { _WD[w], os.date("%Y-%m-%d ") .. _WD[w] }
end

ime.register_command("js", "custom_calc", "计算器", "none", "输入算式，例如 js (1+2)*3")
ime.register_command("xq", "custom_weekday", "星期", "alpha", "显示今天星期几")
