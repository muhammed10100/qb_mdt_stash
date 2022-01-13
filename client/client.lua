QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
	QBCore.PlayerData = QBCore.Functions.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		MenzilDeMi = false
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(Config.StashKordinat) do
			if #(coords - Config.StashKordinat[k].Kordinat) < 3.0 then
				MenzilDeMi = true
				DrawText3D(Config.StashKordinat[k].Kordinat.x, Config.StashKordinat[k].Kordinat.y, Config.StashKordinat[k].Kordinat.z, Config.StashKordinat[k].DrawTxtIsim)
				if IsControlJustPressed(0, 38) and #Config.StashKordinat[k].Meslek == 0 then
					TriggerEvent("inventory:client:SetCurrentStash", Config.StashKordinat[k].Baslik)
					TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.StashKordinat[k].Baslik, { maxweight = Config.StashKordinat[k].MaxAgirlik, slots = Config.StashKordinat[k].MaxSlot	})
				elseif IsControlJustPressed(0, 38) and #Config.StashKordinat[k].Meslek ~= 0 then
					if isAuthorized(QBCore.Functions.GetPlayerData().job.name, k) then
						TriggerEvent("inventory:client:SetCurrentStash", Config.StashKordinat[k].Baslik)
						TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.StashKordinat[k].Baslik, { maxweight = Config.StashKordinat[k].MaxAgirlik, slots = Config.StashKordinat[k].MaxSlot })
					else
						QBCore.Functions.Notify("Yetkin olması lazım.", "error")
					end
				end
			end
		end
		if not MenzilDeMi then
			Citizen.Wait(3000)
		end
	end
end)

function isAuthorized(Meslek, icindenevar)
	for bak = 1, #Config.StashKordinat[icindenevar].Meslek do
		
		if Meslek == Config.StashKordinat[icindenevar].Meslek[bak] then
			return true
		end
	end
	return false
end

-- By MDT YAZILIM
-- Target sistemi için hazırlandı.
RegisterNetEvent("client:setDepo")
AddEventHandler("client:setDepo", function(ParaMetre)
	for k, v in pairs(Config.StashKordinat) do
		TriggerEvent("inventory:client:SetCurrentStash", ParaMetre.Baslik)
		TriggerServerEvent("inventory:server:OpenInventory", "stash", ParaMetre.Baslik, {
			maxweight = Config.StashKordinat[k].MaxAgirlik,
			slots = Config.StashKordinat[k].MaxSlot, -- olmasa
		})
	end
end)

function DrawText3D(x, y, z, text)
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
