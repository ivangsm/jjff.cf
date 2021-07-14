local redis = require "resty.redis"
local red = redis:new()
local server = "redisdb"
local host = "jjff.cf/"

-- connect
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(server, 6379)
if not ok then
    ngx.log(ngx.INFO, "Redis connection failed: ", err)
    ngx.say("Redis connection failed: ", err)
    return
end

local length = 4

function short(url)
    local code = ngx.md5(url):sub(1, length)
    return code
end

local args = ngx.req.get_uri_args()
if not args["url"] then
    ngx.status = 400
    ngx.say("I don't get any URL ¯\\_(ツ)_/¯")
    return
end

local url = args["url"]
if not url:match("^http[s]?://") then
    ngx.status = 400
    ngx.say("That's not a valid URL")
    return
end

local code
local req_code = url
while not code do
    code = short(req_code)
    local res = red:get(code)
    if res == ngx.null then
        red:set(code, url)
        break
    elseif res == url then
        break
    end
    req_code = req_code .. "X"
    code = nil
    return
end

ngx.status = 200
ngx.say(host .. code)

-- keepalive
local ok, err = red:set_keepalive(0, 100)
if not ok then
    ngx.log("failed to set keepalive: ", err)
    return
end
