--------------------------------------------------------------------------------------------------------------
--------------------------- Quantum Projects Gathering ServerSide --------------------------------------------
--------------------------------------------------------------------------------------------------------------
----- This file only contains events to manage how many times gathered, dont judge im implementing a db ------
--------------------------------------------------------------------------------------------------------------
-------------------------------------- IK I SUCK -------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()
local Harvested = {}
local found = false

RegisterServerEvent('qc-gathering:server:giveitem')
AddEventHandler('qc-gathering:server:giveitem', function(item, count)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(item, count)
    end
end)

RegisterServerEvent('qc-gathering:server:harvestsave')
AddEventHandler('qc-gathering:server:harvestsave', function(harvested)
    local Harvested = {}
    Harvested = json.decode(LoadResourceFile(GetCurrentResourceName(), "gathering.json"))
    for k,v in pairs(Harvested) do
        local distancex = (harvested.coords.x - v.coords.x)
        local distancey = (harvested.coords.y - v.coords.y)
        local distance = math.sqrt(distancex * distancex + distancey * distancey)
        if distance < 1 then
            v.timeshavested = v.timeshavested + 1
            harvested.time = os.time()
            found = true
        end
    end
    if not found then
        local newData = {timeshavested = 1, coords = harvested.coords, time = os.time(), object = harvested.object}
        table.insert(Harvested, newData)
        found = false
    end
    SaveResourceFile(GetCurrentResourceName(), "gathering.json", json.encode(Harvested), -1)
    TriggerEvent('qc-gathering:server:gatherload')
    found = false
end)

lib.cron.new(Config.CronJob, function ()
        for k, v in pairs(Harvested) do
            if v.timeshavested > 0 then
                for j, item in pairs(Config.BushHarvest.Items) do
                    if v.object == item.Hash then
                        if v.time + item.Time < os.time() then
                            v.timeshavested = v.timeshavested - 1
                            v.time = os.time()
                            SaveResourceFile(GetCurrentResourceName(), "gathering.json", json.encode(Harvested), -1)
                            TriggerEvent('qc-gathering:server:gatherload')
                        end
                    end
                end
            end
            if v.timeshavested <= 0 then
                table.remove(Harvested, k)
                SaveResourceFile(GetCurrentResourceName(), "gathering.json", json.encode(Harvested), -1)
                TriggerEvent('qc-gathering:server:gatherload')
            end
        end
end)

RegisterServerEvent('qc-gathering:server:gatherload')
AddEventHandler('qc-gathering:server:gatherload', function()
    Harvested = json.decode(LoadResourceFile(GetCurrentResourceName(), "gathering.json"))
    TriggerClientEvent('qc-gathering:client:popgatheringhash', -1, Harvested)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        local emptyData = json.encode({})
        SaveResourceFile(GetCurrentResourceName(), "gathering.json", emptyData, -1)
    end
end)

---COMING SOON :)

--[[ -- Check for tool
RegisterServerEvent('qc-gathering:server:tool')
AddEventHandler('qc-gathering:server:tool', function(tool, nCoords, v, Hash)
    print(v)
    local _source = source
    local pcount = exports['rsg-inventory']:GetItemCount(source, tool)
    print("Checking for tool: ", tool)
    print("Player's tool count: ", pcount)
    if pcount > 0 then
        TriggerClientEvent('qc-gathering:client:neargather', _source, nCoords, v, Hash)
    else
        TriggerClientEvent('qc-gathering:client:finish', _source)
        TriggerClientEvent('ox_lib:notify', _source,{ title = locale('qc_lang_7'), position = 'top', type = 'error', icon = 'fa-solid fa-sickle', iconAnimation = 'beat', duration = 7000 })
    end
end) ]]
