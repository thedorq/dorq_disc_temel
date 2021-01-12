ESX = nil
ESXLoaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(1000)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(1000)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerEvent('disc-inventoryhud:refreshInventory')
end)



RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local dropSecondaryInventory = {
    type = 'drop',
    owner = 'x123y123z123'
}

local isInInventory = false

RegisterNUICallback('NUIFocusOff', function(data)
    closeInventory()
end)

RegisterCommand('closeinv', function(source, args, raw)
    closeInventory()
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 1000 )
    end
end 

function playerAnim()
	loadAnimDict('pickup_object')
    TaskPlayAnim(PlayerPedId(), 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            local _, floorZ = GetGroundZFor_3dCoord(x, y, z)
            dropSecondaryInventory.owner = getOwnerFromCoords(vector3(x, y, floorZ))
            openInventory(dropSecondaryInventory)
            Citizen.Wait(300)
            playerAnim()
           -- TriggerScreenblurFadeIn(0)
        end
    end
end
)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        closeInventory()
        TriggerScreenblurFadeOut(0)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        closeInventory()
    end
end)
