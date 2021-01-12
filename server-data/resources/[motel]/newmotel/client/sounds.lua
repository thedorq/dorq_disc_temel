local cd = 0 -- cooldown to prevent spam
local startCooldown = function()
    Citizen.CreateThread(function()
        cd = Config.doorspam
        repeat
            Citizen.Wait(1000)
            cd = cd - 1
        until cd == 0
    end)
end

RegisterCommand(Config.knockcommand, function()
    if cd == 0 then
        startCooldown()
        local pcoords = GetEntityCoords(PlayerPedId())

        for i = 1, #UTK, 1 do
            if GetDistanceBetweenCoords(pcoords, UTK[i].info.coords, pcoords, true) <= 75.0 then
                for r = 1, #UTK[i].rooms, 1 do
                    if GetDistanceBetweenCoords(pcoords, UTK[i].rooms[r].door, true) <= 1.0 then
                        RequestAnimDict("timetable@jimmy@doorknock@")
                        while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do
                            Citizen.Wait(1)
                        end
                        TaskPlayAnim(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, 3000, 1, 1, 0, 0, 0)
                        Citizen.Wait(500)
                        TriggerServerEvent("utk_motels:soundRequest", UTK[i].rooms[r].door, "knock")
                        return
                    end
                end
            end
        end
    end
end)

RegisterCommand(Config.buzzcommand, function()
    if cd == 0 then
        startCooldown()
        local pcoords = GetEntityCoords(PlayerPedId())

        for i = 1, #UTK, 1 do
            if GetDistanceBetweenCoords(pcoords, UTK[i].info.coords, pcoords, false) <= 75.0 then
                if UTK[i].info.buzz == true then
                    for r = 1, #UTK[i].rooms, 1 do
                        if GetDistanceBetweenCoords(pcoords, UTK[i].rooms[r].door, true) <= 1.0 then
                            RequestAnimDict("anim@apt_trans@buzzer")
                            while not HasAnimDictLoaded("anim@apt_trans@buzzer") do
                                Citizen.Wait(1)
                            end
                            TriggerServerEvent("utk_motels:soundRequest", UTK[i].rooms[r].door, "buzz")
                            TaskPlayAnim(PlayerPedId(), "anim@apt_trans@buzzer", "buzz_short", 8.0, 8.0, 3000, 1, 1, 0, 0, 0) -- This animation has its own sound
                            return
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("utk_motels:soundHandle")
AddEventHandler("utk_motels:soundHandle", function(coords, file)
    local pcoords = GetEntityCoords(PlayerPedId())
    local dst = GetDistanceBetweenCoords(pcoords, coords, true)

    if dst <= 7 then
        if dst < 1 then
            dst = 1
        end
        local volume = 1.0 / dst
        volume = tonumber(tostring(volume):sub(1, 3))
        SendNUIMessage({type = 'playSound', file = file, volume = volume})
    end
end)