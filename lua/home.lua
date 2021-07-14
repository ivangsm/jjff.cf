local redis = require "resty.redis"
local red = redis:new()
local server = "redisdb"
local host = "https://jjff.cf/"

-- connect
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(server, 6379)
if not ok then
    ngx.log(ngx.INFO, "redis connection failed: ", err)
    ngx.say(cjson.encode({ error = err }))
    return
end

local code = ngx.var.uri:sub(2)
local cjson = require "cjson"
cjson.encode_escape_forward_slash(false)
local res = red:get(code)
ngx.log(ngx.INFO, code)
if res == ngx.null then
    ngx.status = 200
    
    local json = cjson.encode({
        title = "jjff - FAST! URL Shortener",
        endpoints = {
            get_example = "curlie " .. host .. "a0b1",
            set_example = "curlie POST " .. host .. "set url=https://jjff.cf"
        }
    }) 
    ngx.say(json)
    return
else
    ngx.say(cjson.encode({ url = res }))
    return
end

-- keepalive
local ok, err = red:set_keepalive(0, 100)
if not ok then
    ngx.log("failed to set keepalive: ", err)
    return
end
