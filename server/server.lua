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

---------------------------------------------
-- send To Discord
-------------------------------------------
local function sendToDiscord(color, name, message, footer, type)
    local embed = {
            {
                ['color'] = color,
                ['title'] = '**'.. name ..'**',
                ['description'] = message,
                ['footer'] = {
                ['text'] = footer
            }
        }
    }
    if type == 'gatherer' then
    	PerformHttpRequest(Config['Webhooks']['gatherering'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterServerEvent('qc-gathering:server:giveitem')
AddEventHandler('qc-gathering:server:giveitem', function(item, count)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local coord = GetEntityCoords(GetPlayerPed(src))
    local coords = (coord.. '')
    if Player then
        Player.Functions.AddItem(item, count)
        sendToDiscord(16753920,	locale('qc_lang_9'), locale('qc_lang_10')..':** '..Player.PlayerData.citizenid..'\n**'..locale('qc_lang_11')..':** '..Player.PlayerData.cid.. '\n**'..locale('qc_lang_12')..':** '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname.. '\n**'..locale('qc_lang_13')..':** '.. coords .. '\n**'..locale('qc_lang_14')..':** '..count .. ' x '.. RSGCore.Shared.Items[item].label.. '** ',	locale('qc_lang_15'), 'ghaterer')
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
            for _, harvestConfig in pairs(Config.Gathering) do
                for _, gatherModel in pairs(harvestConfig.GatherModel[1]) do
                    if v.object == GetHashKey(gatherModel) then 
                        if v.time + harvestConfig.Time < os.time() then
                            v.timeshavested = v.timeshavested - 1
                            v.time = os.time()
                            SaveResourceFile(GetCurrentResourceName(), "gathering.json", json.encode(Harvested), -1)
                            TriggerEvent('qc-gathering:server:gatherload')
                        end
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

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Quantum-Projects-RedM/QC-VersionCheckers/master/QC-Gathering.txt', function(err, newestVersion, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        local resourceName = GetCurrentResourceName()
        local githubLink = GetResourceMetadata(resourceName, 'quantum_github') or "No GitHub URL provided"

        if not newestVersion then
            print("\n^1[Quantum Projects]^7 Unable to perform version check.\n")
            return
        end

        local isLatestVersion = newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "")
        if isLatestVersion then
            print(("^3[Quantum Projects]^7: You are running the latest version of ^2%s^7 (^2%s^7)."):format(resourceName, currentVersion))
        else
            print("\n^6========================================^7")
            print("^3[Quantum Projects]^7 Version Checker")
            print("")
            print(("^3Version Check^7:\n ^2Current^7: %s\n ^2Latest^7: %s\n"):format(currentVersion, newestVersion))
            print(("^1You are running an outdated version of %s.\n^6Repository: ^4%s^7\n"):format(resourceName, githubLink))
            print("^6========================================^7\n")
        end
    end)
end

CheckVersion()


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
