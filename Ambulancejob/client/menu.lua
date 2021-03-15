ESX = nil

local blips = {}
local AppelPris = false
local AppelCoords = nil
local tableBlip = {}
pris = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    PlayerLoaded = true
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent("AppelemsGetCoords")
AddEventHandler("AppelemsGetCoords", function()
     ped = GetPlayerPed(-1)
     GetPed(ped)
	coords = GetEntityCoords(ped, true)
	idJoueur = GetPlayerServerId(PlayerId())
	print(idJoueur)
	TriggerServerEvent("Server:emsAppel", coords, idJoueur)
end)

RegisterNetEvent("AppelemsTropBien")
AddEventHandler("AppelemsTropBien", function(coords, id)
	AppelEnAttente = true
	AppelCoords = coords
	AppelID = id
	ESX.ShowAdvancedNotification("EMS", "~b~Demande d'EMS", "Quelqu'un à besoin d'un ems ! Ouvrez votre menu [F6] pour intervenir", "CHAR_CALL911", 8)
end)



reportlistesql = {}


local Menu = {
    check = false,
    checkbox = 1,
}

local ambuservice = false
local ambulance = false

RMenu.Add('ambulance', 'main', RageUI.CreateMenu("Ambulance", "", 10,80))
RMenu:Get('ambulance', 'main'):SetSubtitle("~b~Menu Interactions")
RMenu.Add('ambulance', 'citoyens', RageUI.CreateSubMenu(RMenu:Get('ambulance', 'main'), "Interactions", "~b~Interactions"))
RMenu.Add('ambulance', 'lister', RageUI.CreateSubMenu(RMenu:Get('ambulance', 'main'), "Liste des appels", nil))
RMenu.Add('ambulance', 'gestr', RageUI.CreateSubMenu(RMenu:Get('ambulance', 'lister'), "Gestion des appels", nil))
RMenu:Get('ambulance', 'main'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('ambulance', 'citoyens'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('ambulance', 'lister'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('ambulance', 'gestr'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('ambulance', 'main').Closed = function()

	ambulance = false
end

function openMenuf6ambulance()
	if not ambulance then
		ambulance = true
        RageUI.Visible(RMenu:Get("ambulance", "main"), true)
            CreateThread(function()
                while ambulance do
                Wait(1)
				RageUI.IsVisible(RMenu:Get('ambulance', 'main'), true, true, true, function()
					RageUI.Checkbox("Prendre/Quitter son service", nil, ambuservice, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
						ambuservice = Checked;
					end, function()
						ambuservice = true
					end, function()
						ambuservice = false
					end)
	
						if ambuservice then
			
							RageUI.Separator("~s~↓ ~b~Interaction et facturation ~s~↓")
							
							RageUI.ButtonWithStyle("Intéraction citoyens", nil, {RightLabel = "~b~Intéragir ~s~→→"}, true, function(Hovered, Active, Selected)
							end, RMenu:Get('ambulance', 'citoyens'))

											
							RageUI.ButtonWithStyle("Intéraction Appels", nil, {RightLabel = "~b~Intéragir ~s~→→"}, true, function(Hovered, Active, Selected)
							ESX.TriggerServerCallback('ems:afficheappels', function(keys)
							reportlistesql = keys
							end)
							end, RMenu:Get('ambulance', 'lister'))
							
				
							RageUI.ButtonWithStyle("Donner une facture",nil, {RightLabel = "~b~Facturer~s~ →→"}, true, function(_,_,s)
								local player, distance = ESX.Game.GetClosestPlayer()
								if s then
									local raison = ""
									local montant = 0
									AddTextEntry("FMMC_MPM_NA", "Raison de la facture")
									DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez une raison de la facture:", "", "", "", "", 30)
									while (UpdateOnscreenKeyboard() == 0) do
										DisableAllControlActions(0)
										Wait(0)
									end
									if (GetOnscreenKeyboardResult()) then
										local result = GetOnscreenKeyboardResult()
										if result then
											raison = result
											result = nil
											AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
											DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le montant de la facture:", "", "", "", "", 30)
											while (UpdateOnscreenKeyboard() == 0) do
												DisableAllControlActions(0)
												Wait(0)
											end
											if (GetOnscreenKeyboardResult()) then
												result = GetOnscreenKeyboardResult()
												if result then
													montant = result
													result = nil
													if player ~= -1 and distance <= 3.0 then
														TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ('ambulance'), montant)
														TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Banque', 'Facture envoyée : ', 'Vous avez envoyé une facture de : ~b~'..montant.. ' $ ~s~pour : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
													else
														ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
													end
												end
											end
											
									  --  end
									end
									end
								end
							end)
							
							RageUI.Separator("~s~↓ ~b~Annonces EMS ~s~↓")
							RageUI.ButtonWithStyle("[~y~annonce~s~] :~g~ disponible", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
								if (Selected) then
									TriggerServerEvent('EMS:Ouvert')
								end
							end)
				
							RageUI.ButtonWithStyle("[~y~annonce~s~] :~r~ non disponible", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
								if (Selected) then
									TriggerServerEvent('EMS:Fermer')
								end
							end)
			
						end					
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('ambulance', 'citoyens'), true, true, true, function()
            
					RageUI.ButtonWithStyle("Réanimer la Personne", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)
						if Selected then 
							revivePlayer(closestPlayer)    
						end
					end)
		
					RageUI.ButtonWithStyle("Soigner une petite blessure", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)
						if (Selected) then 
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 1.0 then
								ESX.ShowNotification('Aucune Personne à Proximité')
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_bandage'))
									end
								end, 'bandage')
							end
						end
					end)
		
					RageUI.ButtonWithStyle("Soigner une plus grande blessure", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, function(Hovered, Active, Selected)
						if (Selected) then 
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 1.0 then
								ESX.ShowNotification('Aucune Personne à Proximité')
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
							end
						end
					end)
				end)

				RageUI.IsVisible(RMenu:Get('ambulance', 'lister'), true, true, true, function()
					RageUI.Separator('↓ ~b~Autres ↓')
					RageUI.ButtonWithStyle("Effacer les appels en cours", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
						if Selected then
							TriggerEvent("EMS:ClearAppel")
						end
					end)
					RageUI.Separator('↓ ~b~Appels ↓')
					for numreport = 1, #reportlistesql, 1 do
					  RageUI.ButtonWithStyle("[~y~Patient ~s~: "..reportlistesql[numreport].reporteur.."~s~] - ~b~Numéro ~s~: "..reportlistesql[numreport].id, nil, { RightLabel = "~r~En ATTENTE"}, true, function(Hovered, Active, Selected)
						  if (Selected) then
							  typereport = reportlistesql[numreport].type
							  reportjoueur = reportlistesql[numreport].reporteur
							  raisonreport = reportlistesql[numreport].raison
							  joueurreporter = reportlistesql[numreport].nomreporter
							  supprimer = reportlistesql[numreport].id
						  end
					  end, RMenu:Get('ambulance', 'gestr'))
		end
			 end, function()
			  end)

			end
		end)
	end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
       RageUI.IsVisible(RMenu:Get('ambulance', 'gestr'), true, true, true, function()
        RageUI.Separator("~y~Type~s~ : Demande d'EMS")
        RageUI.Separator("~b~Nom du Patient~s~ : ".. reportjoueur)
       
        RageUI.CenterButton("~g~Accepter ~s~l'appel", nil, {}, true, function(Hovered, Active, Selected)
			if Selected then
				pris = true
                TriggerServerEvent('EMS:PriseAppelServeur')
                TriggerServerEvent("EMS:AjoutAppelTotalServeur")
                TriggerEvent('emsAppelPris', AppelID, AppelCoords)
				TriggerServerEvent('ems:supprimeappels', supprimer)
				TriggerServerEvent('Ambulance:AppelNotifs', supprimer)
            end
        end) 
        RageUI.CenterButton("~r~Refuser ~s~l'appel~s~ ~b~N°".. supprimer, nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				pris = false
                ESX.ShowAdvancedNotification("ems", "~b~Demande de ems", "Vous avez refuser l'appel.", "CHAR_CALL911", 8)
                TriggerServerEvent('ems:supprimeappels', supprimer)
            end
        end)
       end, function()
        end)
    end
end)

local Garage = false
RMenu.Add('Voiture', 'main', RageUI.CreateMenu("~b~Garage", "", 10,80))
RMenu:Get('Voiture', 'main'):SetSubtitle("~b~Liste des voitures")
RMenu:Get('Voiture', 'main'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('Voiture', 'main').EnableMouse = false
RMenu:Get('Voiture', 'main').Closed = function()
	Garage = false
end

function openGarageEMS()
	if not Garage then
		Garage = true
		RageUI.Visible(RMenu:Get('Voiture', 'main'), true)
	Citizen.CreateThread(function()
		while Garage do
			Citizen.Wait(1)
					RageUI.IsVisible(RMenu:Get('Voiture', 'main'), true, true, true, function()
						local pCo = GetEntityCoords(PlayerPedId())
	
						for index,infos in pairs(Cloak.vehicles.car) do
							if infos.category ~= nil then 
								RageUI.Separator(""..infos.category)
							else 
								RageUI.ButtonWithStyle(infos.label,nil, {RightBadge = RageUI.BadgeStyle.Car}, ESX.PlayerData.job.grade >= infos.minimum_grade, function(_,_,s)
									if s then
										Citizen.CreateThread(function()
											local model = GetHashKey(infos.model)
											RequestModel(model)
											while not HasModelLoaded(model) do Citizen.Wait(1) end
											local vehicle = CreateVehicle(model, 326.52, -556.6248, 28.7434, 242.3 ,true, false)
											SetModelAsNoLongerNeeded(model)
											SetVehicleEngineOn(vehicle, true, true, false)
											TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
										end)
									end
								end)
							end
						end
					end, function()    
				end, 1)
			end
		end)
	end
end

-- Garage Hélicoptère 
local Helico = false
RMenu.Add('Helico', 'main', RageUI.CreateMenu("~b~Helicoptère", "", 10,80))
RMenu:Get('Helico', 'main'):SetSubtitle("~b~Liste des helicoptères")
RMenu:Get('Helico', 'main'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('Helico', 'main').EnableMouse = false
RMenu:Get('Helico', 'main').Closed = function()
	Helico = false
end

function openHeli()
	if not Helico then
		Helico = true
		RageUI.Visible(RMenu:Get('Helico', 'main'), true)
	Citizen.CreateThread(function()
		while Helico do
			Citizen.Wait(1)
					RageUI.IsVisible(RMenu:Get('Helico', 'main'), true, true, true, function()
						local pCo = GetEntityCoords(PlayerPedId())
	
						for index,infos in pairs(Cloak.helico.car) do
							if infos.category ~= nil then 
								RageUI.Separator(""..infos.category)
							else 
								RageUI.ButtonWithStyle(infos.label,nil, {RightBadge = RageUI.BadgeStyle.Car}, ESX.PlayerData.job.grade >= infos.minimum_grade, function(_,_,s)
									if s then
										Citizen.CreateThread(function()
											local model = GetHashKey(infos.model)
											RequestModel(model)
											while not HasModelLoaded(model) do Citizen.Wait(1) end
											local vehicle = CreateVehicle(model, 350.88, -588.020, 74.1655, 64.61,true, false)
											SetModelAsNoLongerNeeded(model)
											SetVehicleEngineOn(vehicle, true, true, false)
										end)
									end
								end)
							end
						end
					end, function()    
					end, 1)
				end
			end)
		end
	end

-- Cloakroom
function applySkinSpecific(infos)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject
		if skin.sex == 0 then
			uniformObject = infos.variations.male
		else
			uniformObject = infos.variations..female
		end
		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
		end

		infos.onEquip()
	end)
end

local cloakroom = false
RMenu.Add('cloakroom', 'main', RageUI.CreateMenu("~b~Vestiaires", "", 0,0))
RMenu:Get('cloakroom', 'main'):SetSubtitle("~b~Vestiaires")
RMenu:Get('cloakroom', 'main'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('cloakroom', 'main').EnableMouse = false
RMenu:Get('cloakroom', 'main').Closed = function()
	cloakroom = false
end

function openClo()
	if not cloakroom then
		cloakroom = true
		RageUI.CloseAll()
		RageUI.Visible(RMenu:Get('cloakroom', 'main'), true)
	Citizen.CreateThread(function()
		while cloakroom do
			Citizen.Wait(1)
				local pCo = GetEntityCoords(PlayerPedId())
				RageUI.IsVisible(RMenu:Get('cloakroom', 'main'), true, true, true, function()

					RageUI.Separator("↓ ~b~Tenues spéciales ~s~↓")
			
						for index,infos in pairs(Cloak.clothes.specials) do
							RageUI.ButtonWithStyle(infos.label,"Vous permets d'équiper: "..infos.label, {RightBadge = RageUI.BadgeStyle.Clothes}, ESX.PlayerData.job.grade >= infos.minimum_grade, function(_,_,s)
								if s then
									ExecuteCommand("e me")
									Citizen.Wait(1400)
									applySkinSpecific(infos)
								end
							end)
						end

						RageUI.Separator("↓ ~b~Tenues de service ~s~↓")
						for index,infos in pairs(Cloak.clothes.grades) do
							RageUI.ButtonWithStyle(infos.label,"Vous permets d'équiper: "..infos.label, {RightBadge = RageUI.BadgeStyle.Clothes}, ESX.PlayerData.job.grade >= infos.minimum_grade, function(_,_,s)
							if s then
								ExecuteCommand("e me")
								Citizen.Wait(1400)
								applySkinSpecific(infos)
							end
						end)
					end
				end)
			end
		end)
	end
end

-- PHARMACIE

local Pharma = false
RMenu.Add('pharma', 'main', RageUI.CreateMenu("~b~Pharmacie", "", 0,0))
RMenu:Get('pharma', 'main'):SetSubtitle("~b~Equipe Toi ")
RMenu:Get('pharma', 'main'):SetRectangleBanner(0, 0, 0, 255)
RMenu:Get('pharma', 'main').EnableMouse = false
RMenu:Get('pharma', 'main').Closed = function()
	Pharma = false
end

function openPharma()
	if not Pharma then
		Pharma = true
		RageUI.CloseAll()
		RageUI.Visible(RMenu:Get('pharma', 'main'), true)
	Citizen.CreateThread(function()
		while Pharma do
			Citizen.Wait(1)
				local pCo = GetEntityCoords(PlayerPedId())
				RageUI.IsVisible(RMenu:Get('pharma', 'main'), true, true, true, function()
					RageUI.Separator("↓ ~o~Blessure Graves ~s~↓")
						for index,infos in pairs(Config.Hospitals.CentralLosSantos.Pharmacies) do
							RageUI.ButtonWithStyle("Medikit ~b~(x1)", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(_,_,s)
								if s then
									TriggerServerEvent('Pharmacy:giveItemm', 'medikit')
								end
							end)
						end
						RageUI.Separator("↓ ~b~Petites Blessure ~s~↓")
						for index,infos in pairs(Config.Hospitals.CentralLosSantos.Pharmacies) do
							RageUI.ButtonWithStyle("Bandages ~b~(x1)", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(_,_,s)
								if s then
									TriggerServerEvent('Pharmacy:giveItem', 'bandage')
								end
							end)
						end
						end)
					end
				end)
			end
		end


		function GetPed(ped)
			PedARevive = ped
		end
		
		RegisterNetEvent("emsAppelPris")
		AddEventHandler("emsAppelPris", function(Xid, XAppelCoords)
			ESX.ShowAdvancedNotification("EMS", "~b~Demande d'EMS", "Vous avez pris l'appel, ~y~Dirigez-vous là-bas ~s~via votre GPS !", "CHAR_CALL911", 2)   
			afficherTextVolant(XAppelCoords, Xid)
		end)
		
		function afficherTextVolant(XAcoords, XAid)
			 emsBlip = AddBlipForCoord(XAcoords)
			--SetBlipSprite(emsBlip, 353)
			SetBlipShrink(emsBlip, true)
			SetBlipScale(emsBlip, 0.9)
			SetBlipPriority(emsBlio, 150)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName("~b~[EMS] Appel en cours")
			EndTextCommandSetBlipName(emsBlip)
			 SetBlipRoute(emsBlip, true)
			 SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
			 table.insert(tableBlip, emsBlip)
			 rea = true
			 while rea do
			 if GetDistanceBetweenCoords(XAcoords, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
				ESX.ShowAdvancedNotification("EMS", "~b~GPS d'EMS", "Vous êtes arrivé !", "CHAR_CALL911", 2)   
				TriggerEvent("EMS:ClearAppel")
		end
		Wait(1)
		end
		end
		
		
		RegisterNetEvent("EMS:ClearAppel")
		AddEventHandler("EMS:ClearAppel", function()
			for k, v in pairs(tableBlip) do
				RemoveBlip(v)
			end
			rea = false
			tableBlip = {}
		end)
		
		function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
			 local px,py,pz=table.unpack(GetGameplayCamCoords())
			 local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
			 local scale = (1/dist)*20
			 local fov = (1/GetGameplayCamFov())*100
			 local scale = scale*fov   
			 SetTextScale(scaleX*scale, scaleY*scale)
			 SetTextFont(fontId)
			 SetTextProportional(1)
			 SetTextColour(250, 250, 250, 255)		-- You can change the text color here
			 SetTextDropshadow(1, 1, 1, 1, 255)
			 SetTextEdge(2, 0, 0, 0, 150)
			 SetTextDropShadow()
			 SetTextOutline()
			 SetTextEntry("STRING")
			 SetTextCentre(1)
			 AddTextComponentString(textInput)
			 SetDrawOrigin(x,y,z+2, 0)
			 DrawText(0.0, 0.0)
			 ClearDrawOrigin()
		end
		
		local AppelTotal = 0
		local NomAppel = "~r~personne"
		local enService = false
		
		RegisterNetEvent("EMS:AjoutUnAppel")
		AddEventHandler("EMS:AjoutUnAppel", function(Appel)
			AppelTotal = Appel
		end)
		
		
		RegisterNetEvent("EMS:PriseDeService")
		AddEventHandler("EMS:PriseDeService", function(service)
			enService = service
		end)
		
		RegisterNetEvent("EMS:DernierAppel")
		AddEventHandler("EMS:DernierAppel", function(Appel)
			NomAppel = Appel
		end)
		
		function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
			SetTextFont(font)
			SetTextProportional(0)
			SetTextScale(sc, sc)
			N_0x4e096588b13ffeca(jus)
			SetTextColour(r, g, b, a)
			SetTextDropShadow(0, 0, 0, 0,255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(x - 0.1+w, y - 0.02+h)
		end
		
		Citizen.CreateThread( function()	
			while true do
				Wait(1)
				if enService then
					DrawRect(0.888, 0.254, 0.196, 0.116, 0, 0, 0, 50)
					DrawAdvancedText(0.984, 0.214, 0.008, 0.0028, 0.4, "Dernière prise d'appel:", 0, 191, 255, 255, 6, 0)
					DrawAdvancedText(0.988, 0.236, 0.005, 0.0028, 0.4, "~b~"..NomAppel.." ~w~à pris le dernier appel EMS", 255, 255, 255, 255, 6, 0)
					DrawAdvancedText(0.984, 0.274, 0.008, 0.0028, 0.4, "Total d'appel prise en compte", 0, 191, 255, 255, 6, 0)
					DrawAdvancedText(0.988, 0.294, 0.005, 0.0028, 0.4, AppelTotal, 255, 255, 255, 255, 6, 0)
				end
			end
		end)
		
		
		RegisterNetEvent("EMS:ClearAppel")
		AddEventHandler("EMS:ClearAppel", function()
			for k, v in pairs(tableBlip) do
				RemoveBlip(v)
			end
			rea = false
			tableBlip = {}
		end)
		
		
		RegisterNetEvent('openappels')
		AddEventHandler('openappels', function()
			ESX.TriggerServerCallback('ems:afficheappels', function(keys)
				reportlistesql = keys
				end)
			  RageUI.Visible(RMenu:Get('appels', 'main'), not RageUI.Visible(RMenu:Get('appels', 'main')))
		end)


function revivePlayer(closestPlayer)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
          ESX.ShowNotification(_U('no_players'))
        else
		ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
		if qtty > 0 then
		local closestPlayerPed = GetPlayerPed(closestPlayer)
		local health = GetEntityHealth(closestPlayerPed)
		if health == 0 then
		local playerPed = GetPlayerPed(-1)
		Citizen.CreateThread(function()
		ESX.ShowNotification(_U('revive_inprogress'))
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		Wait(10000)
		ClearPedTasks(playerPed)
		if GetEntityHealth(closestPlayerPed) == 0 then
		TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
		TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
		else
		ESX.ShowNotification(_U('isdead'))
		end
	   end)
		else
			ESX.ShowNotification(_U('unconscious'))
		end
		 else
        ESX.ShowNotification(_U('not_enough_medikit'))
        end
       end, 'medikit')
	end
end

AddEventHandler("onResourceStart", function()
	TriggerServerEvent('emssapl:deleteallappels', supprimer)
end)
