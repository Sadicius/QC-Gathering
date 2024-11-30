-----------------------------------------------------------------------------------------------------------------
--------------------------- Quantum Projects Gathering ClientSide ------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
----- This file contains just animations and logic to read times gathered and such dont touch unless you know ---
-----------------------------------------------------------------------------------------------------------------
-------------------------------------- I think its good here ----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local Hash, Busy, gg, Harvested = nil, false, false, {}
local promptState = nil
local prompts = {}
local activeGroupIndex = 0
lib.locale()


local Animation = {
  [1] = {"mech_pickup@plant@berries", "base", 0, 4000}
}

Citizen.CreateThread(function()
  for _, bush in pairs(Config.BushHarvest.Items) do
      local propHash = GetHashKey(bush.Hash)
      local targetOptions = {
          {
              name = "harvest_" .. bush.Name,
              label = "Harvest " .. bush.Name,
              icon = "fa-solid fa-leaf",
              onSelect = function(entity)
                local entityId = entity.entity
                if entityId and DoesEntityExist(entityId) then
                    local bushCoords = GetEntityCoords(entityId)
                    TriggerEvent("qc-gathering:client:neargather", bushCoords, bush, nil)
                else
                    print("Invalid entity or entity does not exist.")
                end
            end,
              canInteract = function(_, distance)
                  return distance < 1.5 
              end
          }
      }
      exports.ox_target:addModel(propHash, targetOptions)
  end
end)


RegisterNetEvent('qc-gathering:client:neargather', function(Coords, Data, obj)
  TriggerServerEvent('qc-gathering:server:gatherload')
  local PedID = PlayerPedId()
  Wait(200)
  local canHarvest = true
  local foundHarvest = false
  for k, v in pairs(Harvested) do
      local dist = GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, v.coords.x, v.coords.y, v.coords.z, false)
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

function PickBushAnim()
  ClearPedTasks(PlayerPedId())
                  for i, anim in ipairs(Animation) do
                      RequestAnimDict(anim[1])
                      while not HasAnimDictLoaded(anim[1]) do Wait(0) end
                      TaskPlayAnim(PlayerPedId(), anim[1], anim[2], 1.0, 0.5, anim[4], tonumber(anim[3]), 0.0, 0, 0, 0)
                      Wait(anim[4])
                  end
end

function DoHarvest(PedID, v)
  Busy = true
  PickBushAnim()
  local rChance = math.random(0,10)
  local rAmount = math.random(v.Min, v.Max)
    if (rChance >= 8) then
        lib.notify({ title = locale('qc_lang_5'), position = 'top', type = 'error', icon = 'fa-solid fa-plant-wilt', iconAnimation = 'beat', duration = 7000 })
      Wait(1500)
      Busy = false
      return
    end
  TriggerServerEvent('qc-gathering:server:giveitem', v.Item, rAmount)
    lib.notify({ title = locale('qc_lang_2')..rAmount.." "..v.Item, position = 'top', type = 'success', icon = 'fa-solid fa-plant-wilt', iconAnimation = 'beat', duration = 7000 })
  Wait(1500)
  Busy = false
end

RegisterNetEvent('qc-gathering:client:popgatheringhash')
AddEventHandler('qc-gathering:client:popgatheringhash', function(new)
  Harvested = new
end)
