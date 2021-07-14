local redis = require "resty.redis"
local red = redis:new()
local server = "redisdb"

-- connect
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(server, 6379)
if not ok then
    ngx.log(ngx.INFO, "Redis connection failed: ", err)
    ngx.say("Redis connection failed: ", err)
    return
end

local code = ngx.var.uri:sub(2)

local res = red:get(code)
ngx.log(ngx.INFO, code)
if res == ngx.null then
    ngx.status = 200
    ngx.say([[
        jjff - FAST! URL Shortener
        
        Here's only 2 endpoints
            - '/set'
                example:
                    jjf.cf/set?url=https://url.com
            - '/'
                example:
                    jjff.cf/a0b1

        caution: the links are public and are not stored permanently
    ]])
else
    ngx.say(res)
end

-- keepalive
local ok, err = red:set_keepalive(0, 100)
if ok then
    ngx.log(ngx.INFO, "still alive", err)
else
    ngx.log(ngx.ERR, "it's dead", err)
end
