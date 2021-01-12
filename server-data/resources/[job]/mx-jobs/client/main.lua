local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

ESX = nil

local sleep = 1000

local blipstatus = false

local textstatus = true

TriggerEvent("esx:getSharedObject", function(library) 
    ESX = library 
end)

Citizen.CreateThread(function()
    while ESX.PlayerData == nil do
        Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()

    if blipstatus == false then
        CreateBlip()
    end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
        perform = true
        local ped = PlayerPedId()
        local pedcoords = GetEntityCoords(ped)
        for _,v in pairs(MX) do
            for i = 1, #v.inform, 1 do
               local dst = GetDistanceBetweenCoords(pedcoords, v.inform[i].pos.x, v.inform[i].pos.y, v.inform[i].pos.z, true)
               if textstatus == true then
               if dst <= 8 then
                    if v.inform.jobRequired then
                        if ESX.PlayerData.job and ESX.PlayerData.job.name == v.inform.job then
                            perform = false
                            DrawText3DMX(v.inform[i].pos.x, v.inform[i].pos.y, v.inform[i].pos.z, v.inform[i].DrawText)
                        end
                    else
                    perform = false
                    DrawText3DMX(v.inform[i].pos.x, v.inform[i].pos.y, v.inform[i].pos.z, v.inform[i].DrawText)
                  end
                end
               if dst <= 2 and IsControlJustPressed(0, Keys["E"]) then
                textstatus = false
                    if v.inform[i].Type == "collection" then
                        if v.inform.job == "kasap" then
                        eatprop = CreateObject(GetHashKey('prop_cs_steak'),pedcoords.x, pedcoords.y,pedcoords.z, true, true, true)
                        AttachEntityToEntity(eatprop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                        karton = CreateObject(GetHashKey('prop_cs_clothes_box'),pedcoords.x, pedcoords.y,pedcoords.z, true, true, true)
                        AttachEntityToEntity(karton, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
                        LoadDict("anim@heists@ornate_bank@grab_cash_heels")
                        TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
                        FreezeEntityPosition(PlayerPedId(), true)
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "mx-jobs",
                            duration = v.inform[i].Progressbar.duration,
                            label = v.inform[i].Progressbar.text,
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "",
                                anim = "",
                            },
                            prop = {
                                model = "",
                            }
                        }, function(status)
                            if not status then
                                TriggerServerEvent("mx-jobs:takeitem", v.inform.olditem, v.inform[i].addItemCount, false) 
                                ClearPedTasks(ped)
                                DeleteEntity(karton)
                                DeleteEntity(eatprop)
                                FreezeEntityPosition(ped, false)
                                textstatus = true
                            end
                        end)
                    elseif v.inform.job == "maden" then
                        RequestAnimDict("melee@large_wpn@streamed_core")
                            Citizen.Wait(100)
                            -- TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
                            TaskPlayAnim(PlayerPedId(), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 8.0, -8.0, -1, 1, 0, false, false, false)
                            SetEntityHeading(ped, 270.0)
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
                            pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                            AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "mx-jobs",
                                duration = v.inform[i].Progressbar.duration,
                                label = v.inform[i].Progressbar.text,
                                useWhileDead = false,
                                canCancel = false,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = "",
                                    anim = "",
                                },
                                prop = {
                                    model = "",
                                }
                            }, function(status)
                                if not status then
                                    ClearPedTasks(ped)
                                    DetachEntity(pickaxe, 1, true)
                                    DeleteEntity(pickaxe)
                                    DeleteObject(pickaxe)
                                    textstatus = true
                                         local luck = math.random(1, 250)
                                if luck < 40 then
                                    TriggerServerEvent("mx-jobs:takeitem", v.inform.item[1], v.inform[i].addItemCount, false) 
                                elseif luck > 50 and luck < 100 then
                                    TriggerServerEvent("mx-jobs:takeitem", v.inform.item[2], v.inform[i].addItemCount, false) 
                                elseif luck > 150 and luck < 220 then
                                    TriggerServerEvent("mx-jobs:takeitem", v.inform.item[3], v.inform[i].addItemCount, false) 
                                else
                                    ESX.ShowNotification("Herhangi birşey çıkaramadın !")
                                end
                                end
                            end)
                        else
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "mx-jobs",
                                duration = v.inform[i].Progressbar.duration,
                                label = v.inform[i].Progressbar.text,
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = v.inform[i].Progressbar.animDict,
                                    anim = v.inform[i].Progressbar.anim,
                                },
                                prop = {
                                    model = "",
                                }
                            }, function(status)
                                if not status then
                                    TriggerServerEvent("mx-jobs:takeitem", v.inform.olditem, v.inform[i].addItemCount, false) 
                                    ClearPedTasks(ped)
                                    textstatus = true
                            end
                        end) 
                     end
                    elseif v.inform[i].Type == "progress" then
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "mx-jobs",
                                duration = v.inform[i].Progressbar.duration,
                                label = v.inform[i].Progressbar.text,
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = v.inform[i].Progressbar.animDict,
                                    anim = v.inform[i].Progressbar.anim,
                                },
                                prop = {
                                    model = "",
                                }
                            }, function(status)
                                if not status then
                                TriggerServerEvent("mx-jobs:takeitem", v.inform.item, v.inform[i].addItemCount, true, v.inform.olditem, v.inform.AmountRequired)
                                ClearPedTasks(ped)
                                textstatus = true
                            end
                            
                        end)  
                    elseif v.inform[i].Type == "selling" then
                        if v.inform.job == "maden" then
                            madenselling()
                        else
                        TriggerServerEvent('mx-jobs:selling', v.inform.item, v.inform.price)
                    end
                    end
               end
            end
        end
    end
        if perform then
            sleep = 1000
        end
        if not perform then
            sleep = 7
        end
    end
end)

madenselling = function ()
    ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'selling',
            {
                title    = 'Satış Menüsü',
                elements = {
                    {label = "Elmas", value = "elmas"},
                    {label = "Altın", value = "altin"},
                    {label = "Demir", value = "demir"} 
                }
            },
            function(data, menu)
                if data.current.value == "elmas" then
                    TriggerServerEvent('mx-jobs:selling', "elmas", 5000, "mainjob")
                elseif data.current.value == 'demir' then
                    TriggerServerEvent('mx-jobs:selling', "demir", 1000, "mainjob")
                elseif data.current.value == 'altin' then
                    TriggerServerEvent('mx-jobs:selling', "altin", 4000, "mainjob")
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
end

CreateBlip = function()
    for _,v in pairs(MX) do
        for i = 1, #v.inform, 1 do
            v.inform.bb = AddBlipForCoord(v.inform[i].blip.coords)
            SetBlipSprite(v.inform.bb, v.inform[i].blip.sprite)
            SetBlipColour(v.inform.bb, v.inform[i].blip.color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.inform[i].blip.name)
            EndTextCommandSetBlipName(v.inform.bb)
            SetBlipAsShortRange(v.inform.bb, true)
            blipstatus = true
        end
    end
end

RegisterNetEvent('textstatus')
AddEventHandler("textstatus", function(changethis)
    textstatus = changethis
end)

if Cfg.npc then
Citizen.CreateThread(function()
    for k,v in pairs(Cfg.peds) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do
            Wait(1)
        end

        local seller = CreatePed(1, v.ped, v.x, v.y, v.z - 1, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(seller, true)
        SetPedDiesWhenInjured(seller, false)
        SetPedCanPlayAmbientAnims(seller, true)
        SetPedCanRagdollFromPlayerImpact(seller, false)
        SetEntityInvincible(seller, true)
        FreezeEntityPosition(seller, true)
    end
end)
end

function DrawText3DMX(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end 

