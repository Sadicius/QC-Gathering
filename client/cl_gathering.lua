-----------------------------------------------------------------------------------------------------------------
--------------------------- Quantum Projects Gathering ClientSide ------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
----- This file contains just animations and logic to read times gathered and such dont touch unless you know ---
-----------------------------------------------------------------------------------------------------------------
-------------------------------------- I think its good here ----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local Harvested = {}
lib.locale()


local Animation = {
  [1] = {"mech_pickup@plant@berries", "base", 0, 4000}
}

local function DoAnim(PedID)
  ClearPedTasks(PlayerPedId())
  SetCurrentPedWeapon(PedID, `WEAPON_UNARMED`, true)
    for i, anim in ipairs(Animation) do
      RequestAnimDict(anim[1])
        while not HasAnimDictLoaded(anim[1]) do Wait(0) end
          TaskPlayAnim(PlayerPedId(), anim[1], anim[2], 1.0, 0.5, anim[4], tonumber(anim[3]), 0.0, 0, 0, 0)
          Wait(anim[4])
      end
  end
  
local function DoHarvest(PedID, data)
    Busy = true
    DoAnim(PedID)
    local chance = math.random(0, 10)
    local amount = math.random(data.Min, data.Max)
    local randomitem = data.RewardItems[math.random(#data.RewardItems)]
    if (chance >= 8) then
      lib.notify({ title = locale('qc_lang_5'), position = 'top', type = 'error', icon = 'fa-solid fa-plant-wilt', iconAnimation = 'beat', duration = 7000 })
      Wait(1500)
      FreezeEntityPosition(PedID, false)
      Busy = false
  return
  end
    TriggerServerEvent('qc-gathering:server:giveitem', randomitem, amount)
  
    if Config.Skills then
      local xp = Config.SkillXP
      TriggerServerEvent('j-reputations:server:addrep', 'gathering', xp)
  end
      lib.notify({ title = locale('qc_lang_2')..amount.." "..randomitem, position = 'top', type = 'success', icon = 'fa-solid fa-plant-wilt', iconAnimation = 'beat', duration = 7000 })
    Wait(1500)
    Busy = false
end

Citizen.CreateThread(function()
  for _, harvestConfig in pairs(Config.Gathering) do
      for _, category in pairs(harvestConfig.GatherModel) do
          for _, gatherModel in pairs(category) do
              local propHash = GetHashKey(gatherModel)
              local targetOptions = {
                  {
                      name = 'gathering_' .. propHash,
                      label = locale('qc_lang_8')..harvestConfig.Name,
                      icon = harvestConfig.Icon,
                      onSelect = function(entity)
                          local entityId = entity.entity
                          if entityId and DoesEntityExist(entityId) then
                              local gatherCoords = GetEntityCoords(entityId)
                              TriggerEvent("qc-gathering:client:neargather", gatherCoords, harvestConfig, nil)
                          else
                              print(locale('cl_lang_2'))
                          end
                      end,
                      canInteract = function(_, distance)
                          return distance < 1.5
                      end
                  }
              }
              exports.ox_target:addModel(propHash, targetOptions)
          end
      end
  end
end)

RegisterNetEvent('qc-gathering:client:neargather', function(Coords, Data, obj)
  TriggerServerEvent('qc-gathering:server:gatherload')
  local PedID = PlayerPedId()
  Wait(200)
  local canHarvest = true
  local foundHarvest = false

  for k, v in pairs(Harvested) do
    local dist = #(vector3(Coords.x, Coords.y, Coords.z) - vector3(v.coords.x, v.coords.y, v.coords.z))
      if dist < 1 then
          foundHarvest = true
          if (v.timeshavested >= Data.MaxHarvest) then
              lib.notify({ title = locale('qc_lang_6'), type = 'error', position = 'top', icon = 'fa-solid fa-plant-wilt', iconAnimation = 'beat', duration = 7000 })
              canHarvest = false
              Wait(1500)
              Busy = false
              break
          end
      end
  end

  if canHarvest then
      if foundHarvest then
          for k, v in pairs(Harvested) do
              local dist = GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, v.coords.x, v.coords.y, v.coords.z, false)
              if dist < 1 then
                  v.timeshavested = v.timeshavested + 1
                  TriggerServerEvent('qc-gathering:server:harvestsave', v)
                  DoHarvest(PedID, Data)
                  return
              end
          end
      else
          DoHarvest(PedID, Data)
          local newHarvest = {
              timeshavested = 1,
              coords = { x = Coords.x, y = Coords.y, z = Coords.z },
              object = obj
          }
          TriggerServerEvent('qc-gathering:server:harvestsave', newHarvest)
      end
  end
end)

RegisterNetEvent('qc-gathering:client:popgatheringhash')
AddEventHandler('qc-gathering:client:popgatheringhash', function(new)
  Harvested = new
end)
