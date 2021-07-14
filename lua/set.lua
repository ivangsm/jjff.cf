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

local length = 4

function short(url)
    local code = ngx.md5(url):sub(1, length)
    return code
end


ngx.req.read_body()
local res = ngx.req.get_body_data()

local cjson = require "cjson"
cjson.encode_escape_forward_slash(false)                                                                
local json = cjson.decode(res)

if not json['url'] then
    ngx.status = 400
    ngx.say(cjson.encode({ error = "the url field is needed"}))
    return
end

local url = json['url']
if not url:match("^http[s]?://") then
    ngx.status = 400
    ngx.say(cjson.encode({ error = "invalid url" }))
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
ngx.say(cjson.encode({ url = host .. code }))



-- keepalive
local ok, err = red:set_keepalive(0, 100)
if not ok then
    ngx.log("failed to set keepalive: ", err)
    return
end
