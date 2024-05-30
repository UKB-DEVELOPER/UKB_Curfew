local __internal_perform = PerformHttpRequest
local __external_perform = function(url, cb, ...)
    icb = function(_, ...)
        cb(200, ...)
    end
    __internal_perform(url, icb, ...)
end
PerformHttpRequest = __external_perform

ESX = nil
TriggerEvent(Base.ServerEvent, function(obj)
    ESX = obj
end)
local ResourceName = GetCurrentResourceName()
scriptId = "6655eafdba80a3ae43dc08f0"

Staus = function(errNum, data)

    Status = false

    if (errNum == 200 and data == scriptId) then
        print("\n")
        print("^2##############################################")
        print("^2## ^5Thank you for purchasing RyShop - Script ^2##")
        print("^2##        ^5https://discord.gg/wThmKHSFQb  ^2   ##")
        print("^2##############################################")
        Status = true
        GlobalState.Ry_CurfewCheckLicense = true
        Reply(Status)
    else
        print("\n")
        print("^1###########################################")
        print("^1##   ^RyShop - Script ^1 License inavlid ^1  ##")
        print("^1##     ^5https://discord.gg/wThmKHSFQb     ^1##")
        print("^1###########################################")
        GlobalState.Ry_CurfewCheckLicense = false
        StopResource(GetCurrentResourceName())
    end

end

Connect = function()

    PerformHttpRequest("https://api.unknowkubbrother.net/checkLicense",
        function(errorCode, resultData, resultHeaders, errorData)
            Staus(errorCode, resultData)
        end, "POST", json.encode(Ry), {
            ["Content-Type"] = "application/json"
        })

end

Connect()

Reply = function(Status)
    if Status then

        local zone = {}
        local id = 0

        local ResourceName = GetCurrentResourceName()
        RegisterServerEvent(ResourceName .. ':send')
        AddEventHandler(ResourceName .. ':send', function(type, title)
            TriggerClientEvent(ResourceName .. ":setposition", source, type, title)
        end)

        RegisterServerEvent(ResourceName .. ':stop')
        AddEventHandler(ResourceName .. ':stop', function(index)
            -- table.remove(zone, index)
            zone[index] = nil
            TriggerClientEvent(ResourceName .. ":stopredzone", -1, index)
        end)

        RegisterServerEvent(ResourceName .. ':sentlocation')
        AddEventHandler(ResourceName .. ':sentlocation', function(x, y, z, type, title)
            id = id + 1
            zone[id] = {
                x = x,
                y = y,
                z = z,
                type = type,
                title = title,
                id = id
            }
            TriggerClientEvent(ResourceName .. ':createForAll', -1, x, y, z, type, title, id)
        end)

        RegisterServerEvent(ResourceName .. ':firstSpawn')
        AddEventHandler(ResourceName .. ':firstSpawn', function()
            if next(zone) ~= nil then
                for k, v in pairs(zone) do
                    TriggerClientEvent(ResourceName .. ':createForAll', source, v.x, v.y, v.z, v.type, v.title, v.id)
                end
            end
        end)

    end
end
