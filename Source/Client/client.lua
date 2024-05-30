ESX = nil
local PlayerData = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Base.ClientEvent, function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)
local ResourceName = GetCurrentResourceName()


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    TriggerServerEvent(ResourceName .. ':firstSpawn')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

if Curfew.KeyOpenMenu then
    RegisterKeyMapping('startCurfew', 'Start Cur few', 'keyboard', Curfew.keybind)

    RegisterCommand('startCurfew', function()
        if ESX.PlayerData.job ~= nil then
            StartCurfew()
        end
    end, false)
end

StartCurfew = function()
    if checkjob(ESX.PlayerData.job.name) and GlobalState.Ry_CurfewCheckLicense then
        TriggerScreenblurFadeIn(true)
        SetNuiFocus(true, true)
        SendNUIMessage({
            showBoxAnnounce = true,
            type = 'curfew'
        })
    end
end

exports('StartCurfew', StartCurfew)

checkjob = function(job)
    for k, v in pairs(Curfew.job) do
        if v == job then
            return true
        end
    end
    return false
end

RegisterNUICallback('CloseUI', function(data, cb)
    TriggerScreenblurFadeOut(true)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback('AddAnnounceCurfew', function(data, cb)
    TriggerScreenblurFadeOut(true)
    SetNuiFocus(false, false)
    TriggerServerEvent(ResourceName .. ':send', data.type, data.title)
    cb("ok")
end)

RegisterNUICallback('Notify', function(data, cb)
    Notify.NotifyClient(data.type, data.message)
    cb("ok")
end)

RegisterNUICallback('RemoveAnnounceCurfew', function(data, cb)
    TriggerServerEvent(ResourceName .. ':stop', data.index)
    cb("ok")
end)

AddEventHandler('onResourceStop', function(resource)
    TriggerScreenblurFadeOut(true)
    SetNuiFocus(false, false)
end)

-- Redzone -----------------------------------------------------------------------------
local location = {}
RegisterNetEvent(ResourceName .. ':setposition')
AddEventHandler(ResourceName .. ':setposition', function(type, title)
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    TriggerServerEvent(ResourceName .. ':sentlocation', x, y, z, type, title)
end)

RegisterNetEvent(ResourceName .. ':stopredzone')
AddEventHandler(ResourceName .. ':stopredzone', function(index)
    if next(location) ~= nil then
        SendNUIMessage({
            action = 'removeAnn',
            index = index
        })
        RemoveBlip(location[index].blip)
        location[index] = nil
    end
end)

RegisterNetEvent(ResourceName .. ':createForAll')
AddEventHandler(ResourceName .. ':createForAll', function(x, y, z, type, title, id)
    local zones = {
        ['AIRP'] = "Los Santos International Airport",
        ['ALAMO'] = "Alamo Sea",
        ['ALTA'] = "Alta",
        ['ARMYB'] = "Fort Zancudo",
        ['BANHAMC'] = "Banham Canyon Dr",
        ['BANNING'] = "Banning",
        ['BEACH'] = "Vespucci Beach",
        ['BHAMCA'] = "Banham Canyon",
        ['BRADP'] = "Braddock Pass",
        ['BRADT'] = "Braddock Tunnel",
        ['BURTON'] = "Burton",
        ['CALAFB'] = "Calafia Bridge",
        ['CANNY'] = "Raton Canyon",
        ['CCREAK'] = "Cassidy Creek",
        ['CHAMH'] = "Chamberlain Hills",
        ['CHIL'] = "Vinewood Hills",
        ['CHU'] = "Chumash",
        ['CMSW'] = "Chiliad Mountain State Wilderness",
        ['CYPRE'] = "Cypress Flats",
        ['DAVIS'] = "Davis",
        ['DELBE'] = "Del Perro Beach",
        ['DELPE'] = "Del Perro",
        ['DELSOL'] = "La Puerta",
        ['DESRT'] = "Grand Senora Desert",
        ['DOWNT'] = "Downtown",
        ['DTVINE'] = "Downtown Vinewood",
        ['EAST_V'] = "East Vinewood",
        ['EBURO'] = "El Burro Heights",
        ['ELGORL'] = "El Gordo Lighthouse",
        ['ELYSIAN'] = "Elysian Island",
        ['GALFISH'] = "Galilee",
        ['GOLF'] = "GWC and Golfing Society",
        ['GRAPES'] = "Grapeseed",
        ['GREATC'] = "Great Chaparral",
        ['HARMO'] = "Harmony",
        ['HAWICK'] = "Hawick",
        ['HORS'] = "Vinewood Racetrack",
        ['HUMLAB'] = "Humane Labs and Research",
        ['JAIL'] = "Bolingbroke Penitentiary",
        ['KOREAT'] = "Little Seoul",
        ['LACT'] = "Land Act Reservoir",
        ['LAGO'] = "Lago Zancudo",
        ['LDAM'] = "Land Act Dam",
        ['LEGSQU'] = "Legion Square",
        ['LMESA'] = "La Mesa",
        ['LOSPUER'] = "La Puerta",
        ['MIRR'] = "Mirror Park",
        ['MORN'] = "Morningwood",
        ['MOVIE'] = "Richards Majestic",
        ['MTCHIL'] = "Mount Chiliad",
        ['MTGORDO'] = "Mount Gordo",
        ['MTJOSE'] = "Mount Josiah",
        ['MURRI'] = "Murrieta Heights",
        ['NCHU'] = "North Chumash",
        ['NOOSE'] = "N.O.O.S.E",
        ['OCEANA'] = "Pacific Ocean",
        ['PALCOV'] = "Paleto Cove",
        ['PALETO'] = "Paleto Bay",
        ['PALFOR'] = "Paleto Forest",
        ['PALHIGH'] = "Palomino Highlands",
        ['PALMPOW'] = "Palmer-Taylor Power Station",
        ['PBLUFF'] = "Pacific Bluffs",
        ['PBOX'] = "Pillbox Hill",
        ['PROCOB'] = "Procopio Beach",
        ['RANCHO'] = "Rancho",
        ['RGLEN'] = "Richman Glen",
        ['RICHM'] = "Richman",
        ['ROCKF'] = "Rockford Hills",
        ['RTRAK'] = "Redwood Lights Track",
        ['SANAND'] = "San Andreas",
        ['SANCHIA'] = "San Chianski Mountain Range",
        ['SANDY'] = "Sandy Shores",
        ['SKID'] = "Mission Row",
        ['SLAB'] = "Stab City",
        ['STAD'] = "Maze Bank Arena",
        ['STRAW'] = "Strawberry",
        ['TATAMO'] = "Tataviam Mountains",
        ['TERMINA'] = "Terminal",
        ['TEXTI'] = "Textile City",
        ['TONGVAH'] = "Tongva Hills",
        ['TONGVAV'] = "Tongva Valley",
        ['VCANA'] = "Vespucci Canals",
        ['VESP'] = "Vespucci",
        ['VINE'] = "Vinewood",
        ['WINDF'] = "Ron Alternates Wind Farm",
        ['WVINE'] = "West Vinewood",
        ['ZANCUDO'] = "Zancudo River",
        ['ZP_ORT'] = "Port of South Los Santos",
        ['ZQ_UAR'] = "Davis Quartz"
    }
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]
    if tostring(GetStreetNameFromHashKey(var2)) == "" then
        location[id] = {
            x = x,
            y = y,
            z = z - 220.0,
            streetname = tostring(GetStreetNameFromHashKey(var1)),
            zone = current_zone
        }
        location[id].blip = AddBlipForRadius(x, y, z, 100.0)
        SetBlipColour(location[id].blip, 1)
        SetBlipAlpha(location[id].blip, 100)
    else
        location[id] = {
            x = x,
            y = y,
            z = z - 220.0,
            streetname = tostring(GetStreetNameFromHashKey(var1)),
            zone = current_zone
        }
        location[id].blip = AddBlipForRadius(x, y, z, 100.0)
        SetBlipColour(location[id].blip, 1)
        SetBlipAlpha(location[id].blip, 100)
    end
    SendNUIMessage({
        action = 'addAnn',
        type = type,
        title = title,
        id = id
    })
end)

-- Draw zone
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if next(location) ~=nil then
            local playerped = PlayerPedId()
		    local coords = GetEntityCoords(playerped)
            for k, pos in pairs(location) do
                local mx = Vdist(coords.x, coords.y, coords.z, pos.x, pos.y, coords.z)
                if mx < 100.0 then
                    sleep = 1
                    rgb = RGBRainbow(1)
                    DrawMarker(1, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 100.0001, 100.0001, 400.0001, 1000, 0, 0, rgb.r, rgb.g,
                        rgb.b, 0.4, 0)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function RGBRainbow(frequency)
    local result = {}
    local curtime = GetGameTimer() / 1000

    result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return result
end
