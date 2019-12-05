ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            Citizen.Wait(500)
           -- TriggerServerEvent("kashactersS:SetupCharacters")
			TriggerEvent("kashactersC:WelcomePage")
            TriggerEvent("kashactersC:SetupCharacters")
            return -- break the loop
        end
    end
end)

local IsChoosing = true
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if IsChoosing then
            DisplayHud(false)
            DisplayRadar(false)
        end
    end
end)
local cam = nil
local cam2 = nil
RegisterNetEvent('kashactersC:SetupCharacters')
AddEventHandler('kashactersC:SetupCharacters', function()
    SetTimecycleModifier('hud_def_blur')
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 256.32,-1055.71,369.89, 300.00,0.00,0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)

RegisterNetEvent('kashactersC:WelcomePage')
AddEventHandler('kashactersC:WelcomePage', function()
    SetNuiFocus(true, true)
	SendNUIMessage({
        action = "openwelcome"
    })
end)

RegisterNetEvent('kashactersC:SetupUI')
AddEventHandler('kashactersC:SetupUI', function(Characters)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        characters = Characters,
    })
end)

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(spawn, isnew)
		TriggerServerEvent('es:firstJoinProper')
		TriggerEvent('es:allowedToSpawn')
	if isnew then
		TriggerEvent('esx_identity:showRegisterIdentity')
		SendNUIMessage({
        action = "displayback"
		})
		SetTimecycleModifier('hud_def_blur')
		FreezeEntityPosition(GetPlayerPed(-1), true)
		cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 256.32,-1055.71,369.89, 300.00,0.00,0.00, 100.00, false, 0)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 1, true, true)
	else
		SetTimecycleModifier('default')
		local pos = spawn
		SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
		cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 256.32,-1055.71,369.89, 300.00,0.00,0.00, 100.00, false, 0)
		PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
		SetCamActiveWithInterp(cam2, cam, 900, true, true)
		Citizen.Wait(900)
		exports.spawnmanager:setAutoSpawn(false)
		TriggerEvent('esx_ambulancejob:multicharacter', source)
		

		cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
		PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
		SetCamActiveWithInterp(cam, cam2, 3700, true, true)
		Citizen.Wait(3700)
		PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
		RenderScriptCams(false, true, 500, true, true)
		PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		Citizen.Wait(500)
		SetCamActive(cam, false)
		DestroyCam(cam, true)
		IsChoosing = false
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0})
					TriggerEvent('esx_skin:openSaveableMenu')
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
		end)
		DisplayHud(true)
		DisplayRadar(true)	
	end
end)

RegisterNetEvent('kashactersC:ReloadCharacters')
AddEventHandler('kashactersC:ReloadCharacters', function()
    TriggerServerEvent("kashactersS:SetupCharacters")
    TriggerEvent("kashactersC:SetupCharacters")
end)

RegisterNUICallback("CharacterChosen", function(data, cb)
    SetNuiFocus(false,false)
    TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar, data.spawnid or "1")
    cb("ok")
end)
RegisterNUICallback("DeleteCharacter", function(data, cb)
    SetNuiFocus(false,false)
    TriggerServerEvent('kashactersS:DeleteCharacter', data.charid)
    cb("ok")
end)
RegisterNUICallback("ShowSelection", function(data, cb)
	TriggerServerEvent("kashactersS:SetupCharacters")
end)
