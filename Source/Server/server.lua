ESX = nil
TriggerEvent(Base.ServerEvent, function(obj)
    ESX = obj
end)
local ResourceName = GetCurrentResourceName()

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
