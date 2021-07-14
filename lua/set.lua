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

LENGTH = 4

function Short(url)
    local short_url = ngx.md5(url):sub(1, LENGTH)
    return short_url
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

local short_url
local temp_url = url
while not short_url do
    short_url = Short(temp_url)
    local res = red:get(short_url)
    if res == ngx.null then
        red:set(short_url, url)
        break
    elseif res == url then
        break
    end
    temp_url = temp_url .. "X"
    short_url = nil
end

ngx.status = 200
ngx.say(host .. short_url)

-- keepalive
local ok, err = red:set_keepalive(0, 100)
if ok then
    ngx.log(ngx.INFO, "still alive", err)
else
    ngx.log(ngx.ERR, "it's dead", err)
end
