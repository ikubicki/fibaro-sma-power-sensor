--[[
SMA power sensor
@author ikubicki
]]

function QuickApp:onInit()
    self.config = Config:new(self)
    self.sma = SMA:new(self.config)

    self.i18n = i18n:new(api.get("/settings/info").defaultLanguage)
    self:trace('')
    self:trace(self.i18n:get('name'))
    self:updateProperty('manufacturer', 'SMA')
    self:updateProperty('manufacturer', 'Power sensor')
    self:updateView("button1", "text", self.i18n:get('refresh'))
    self:run()
end

function QuickApp:run()
    self:pullDataFromInverter()
    local interval = self.config:getTimeoutInterval()
    if (interval > 0) then
        fibaro.setTimeout(interval, function() self:run() end)
    end
end

function QuickApp:button1Event()
    self:pullDataFromInverter()
end

function QuickApp:pullDataFromInverter()
    self:updateView("button1", "text", self.i18n:get('please-wait'))
    local sid = false
    local errorCallback = function(error)
        self:updateView("button1", "text", self.i18n:get('refresh'))
        QuickApp:error(json.encode(error))
    end
    local logoutCallback = function()
        self:updateView("label1", "text", string.format(self.i18n:get('last-update'), os.date('%Y-%m-%d %H:%M:%S')))
        self:updateView("button1", "text", self.i18n:get('refresh'))
        self:trace(self.i18n:get('device-updated'))
    end
    local valuesCallback = function(res)
        if res and res.result then
            for _, device in pairs(res.result) do
                local power = device[SMA.POWER_CURRENT]["1"][1]['val']
                self:updatePower(power)
            end
        end
        self.sma:logout(sid, logoutCallback, errorCallback)
    end
    local loginCallback = function(sessionId)
        sid = sessionId
        self.sma:getValues(sid, {SMA.POWER_CURRENT}, valuesCallback, errorCallback)
    end
    self.sma:login(loginCallback, errorCallback)
end

function QuickApp:updatePower(power)
    if power > 1000 then
        self:updateProperty("value", power / 1000) 
        self:updateProperty("unit", "KW") 
    else
        self:updateProperty("value", power) 
        self:updateProperty("unit", "W") 
    end
    self:updateProperty("power", power)
end