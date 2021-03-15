Config                            = {}

Config.DrawDistance               = 20.0

Config.Marker                     = {type = 22, x = 0.5, y = 0.5, z = 0.5, r = 255, g = 0, b = 0, a = 100, false, rotate = true, false, true, true, true, true}

Config.ReviveReward               = 400
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)

Config.Locale                     = 'fr'

Config.EarlyRespawnTimer          = 60000 * 5  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 5 -- time til the player bleeds out

Config.EnablePlayerManagement     = true -- Enable society managing (If you are using esx_society).

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

--Laissez le joueur payer pour réapparaître tôt, seulement s'il peut se le permettre.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 4000

Config.RespawnPoint = {coords = vector3(363.39, -593.09, 43.28), heading = 61.23}

Config.Hospitals = {
	CentralLosSantos = {
		AmbulanceActions = {
			vector3(298.90, -598.48, 43.28)
		},
		Boss = {
			vector3(334.56, -593.70, 43.28)
		},
		Pharmacies = {
			vector3(306.60, -601.46, 43.28)
		},
		Vehicles = {
			vector3(333.91, -561.94, 28.74)
		},
		Helicopters = {
			vector3(339.94, -580.14, 74.1655)
		},
        Deleter = {
            vector3(351.272, -588.910, 74.165),
			vector3(340.84, -562.39, 28.743)
        },
	}
}

Cloak = {
	clothes = {
        specials = {
            [0] = {
                label = "Tenue Civil",
                minimum_grade = 0,
                variations = {male = {}, female = {}},
                onEquip = function()
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) TriggerEvent('skinchanger:loadSkin', skin) end)
                    SetPedArmour(PlayerPedId(), 0)
                end
            },
            [1] = {
                minimum_grade = 3,
                label = "Tenue de Directeur",
                variations = {
                male = {
                    tshirt_1 = 46,  tshirt_2 = 0,
                    torso_1 = 29,   torso_2 = 5,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 6,
                    pants_1 = 8,   pants_2 = 14,
                    shoes_1 = 8,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = 34,    chain_2 = 2,
                    ears_1 = 0,     ears_2 = 0
                },
                female = {
                    tshirt_1 = 36,  tshirt_2 = 1,
                    torso_1 = 48,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 44,
                    pants_1 = 34,   pants_2 = 0,
                    shoes_1 = 27,   shoes_2 = 0,
                    helmet_1 = 45,  helmet_2 = 0,
                    chain_1 = 0,    chain_2 = 0,
                    ears_1 = 2,     ears_2 = 0
                }
            },
            onEquip = function()  
            end
            }
        },
        grades = {
            -- @label = Le nom affiché de la tenue de grade
            -- @male = Les composants skinchanger pour les hommes
            -- @female = Les composants skinchanger pour les femmes
            [0] = {
                label = "Tenue d'Ambulancier",
                minimum_grade = 0,
                variations = {
                male = {
                    bags_1 = 0, bags_2 = 0,
                    tshirt_1 = 129, tshirt_2 = 0,
                    torso_1 = 75, torso_2 = 6,
                    arms = 86,
                    pants_1 = 33, pants_2 = 0,
                    shoes_1 = 25, shoes_2 = 0,
                    mask_1 = 0, mask_2 = 0,
                    bproof_1 = 14, bproof_2 = 0,
                    helmet_1 = -1, helmet_2 = 0,
                    chain_1 = 0, chain_2 = 0,
                    decals_1 = 0, decals_2 = 0,
                },
                female = {
                    bags_1 = 0, bags_2 = 0,
                    tshirt_1 = 129, tshirt_2 = 0,
                    torso_1 = 75, torso_2 = 6,
                    arms = 86,
                    pants_1 = 33, pants_2 = 0,
                    shoes_1 = 25, shoes_2 = 0,
                    mask_1 = 0, mask_2 = 0,
                    bproof_1 = 14, bproof_2 = 0,
                    helmet_1 = -1, helmet_2 = 0,
                    chain_1 = 0, chain_2 = 0,
                    decals_1 = 0, decals_2 = 0
                }
            },
            onEquip = function()
            end
        },
            [1] = {
                minimum_grade = 0,
                label = "Tenue Médecin",
                variations = {
                male = {
                    tshirt_1 = 59,  tshirt_2 = 1,
                    torso_1 = 55,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 41,
                    pants_1 = 25,   pants_2 = 0,
                    shoes_1 = 25,   shoes_2 = 0,
                    helmet_1 = 46,  helmet_2 = 0,
                    chain_1 = 0,    chain_2 = 0,
                    ears_1 = 2,     ears_2 = 0
                },
                female = {
                    tshirt_1 = 36,  tshirt_2 = 1,
                    torso_1 = 48,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 44,
                    pants_1 = 34,   pants_2 = 0,
                    shoes_1 = 27,   shoes_2 = 0,
                    helmet_1 = 45,  helmet_2 = 0,
                    chain_1 = 0,    chain_2 = 0,
                    ears_1 = 2,     ears_2 = 0
                }
            },
            onEquip = function()
                
            end
        },
    }
    },
    vehicles = {
        car = {
            {category = "↓ ~b~Véhicules Normaux ~s~↓"},
            {model = "ambulance", label = "Ambulance", minimum_grade = 0},
            {category = "↓ ~b~Véhicules spéciaux ~s~↓"},
            {model = "policet", label = "Dodge EMS", minimum_grade = 2},
            {model = "riot", label = "voiture", minimum_grade = 2}
        },
    },
    helico = {
        car = {
            {category = "↓ ~b~Véhicules Normaux ~s~↓"},
            {model = "polmav", label = "Helicoptère", minimum_grade = 2}
        },
    }
}