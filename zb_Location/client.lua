ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)


Config              = {}
Config.DrawDistance = 100
Config.Size         = {x = 5.0, y = 5.0, z = 1.0}
Config.Color        = {r = 255, g = 255, b = 255}
Config.Type         = -1

local position = {
        {x = -1015.77,   y = -2694.06,  z = 13.98},        
}  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < Config.DrawDistance) then
                DrawMarker(Config.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

RMenu.Add('location', 'main', RageUI.CreateMenu("~b~SIXT", "~o~Séléctionne un véhicule de location !"))


Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('location', 'main'), true, true, true, function()

            RageUI.Button("~y~Renault Clio 4", nil, {RightLabel = "~g~300€"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('zebee:vehicule', 650)
                spawnCar("17cliofl")
                RageUI.CloseAll()
            end
            end)

                       RageUI.Button("~r~Yamaha Booster MBK", nil, {RightLabel = "~g~150€"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('zebee:vehicule', 75)
                spawnCar("faggio3")
                RageUI.CloseAll()
            end
            end)


        end, function()
        end)

        Citizen.Wait(0)
    end
end)



Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            for k in pairs(position) do
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
    
                if dist <= 1.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à la location de véhicule.")
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(RMenu:Get('location', 'main'), not RageUI.Visible(RMenu:Get('location', 'main')))
                    end   
                end
            end
        end
    end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, -1006.16, -2675.48, 13.98, 329.469, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "LOCATION"
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end

------------------------------------------------------------------------------ PED ----------------------------------------------------------------

DecorRegister("Caui", 4)
pedHash = "a_m_y_business_03"
zone = vector3(-1015.66, -2692.6, 12.98)
Heading = 174.38
Ped = nil
HeadingSpawn = 174.38

Citizen.CreateThread(function()
    LoadModel(pedHash)
    Ped = CreatePed(2, GetHashKey(pedHash), zone, Heading, 0, 0)
    DecorSetInt(Ped, "Caui", 5431)
    FreezeEntityPosition(Ped, 1)
    TaskStartScenarioInPlace(Ped, "a_m_y_business_03", 0, false)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, 1)
---------------------------------------------------------------------------------- Blip --------------------------------------------------------------
    local blip = AddBlipForCoord(zone)
    SetBlipSprite(blip, 464)
    SetBlipScale(blip, 0.7)
    SetBlipShrink(blip, true)
    SetBlipColour(blip, 11)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location")
    EndTextCommandSetBlipName(blip)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end
