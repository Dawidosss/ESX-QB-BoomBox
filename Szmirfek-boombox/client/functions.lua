-----------------Discord Leaks Zapraszam----------------
----------------- https://discord.gg/TX3m4z3g9F ---------------
---------------------------------------------------------------
loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

hasBoomBox = function(radio)
    local equipRadio = true
    CreateThread(function()
        if Config.InstructionNotification then
            lib.notify({
                title = 'Instrukcja',
                description = 'Naciśnij E aby położyć boombox',
                type = 'success'
            })
        end
        while equipRadio do
            Wait(0)
            if IsControlJustReleased(0, 38) then
                equipRadio = false
				DetachEntity(radio)
				PlaceObjectOnGroundProperly(radio)
                FreezeEntityPosition(radio, true)
                boomboxPlaced(radio)
            end
        end
    end)
end


if Config.Framework == "ESX" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports.qtarget:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = 'Włącz',
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = 'Podnieś'
                            }
    
                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports.qtarget:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
elseif Config.Framework == "QB" then
    boomboxPlaced = function(obj)
        local coords = GetEntityCoords(obj)
        local heading = GetEntityHeading(obj)
        local targetPlaced = false
        CreateThread(function()
            while true do
                if DoesEntityExist(obj) and not targetPlaced then
                    exports['qb-target']:AddBoxZone("boomboxzone", coords, 1, 1, {
                        name="boomboxzone",
                        heading=heading,
                        debugPoly=false,
                        minZ=coords.z-0.9,
                        maxZ=coords.z+0.9
                    }, {
                        options = {
                            {
                                event = 'wasabi_boombox:interact',
                                icon = 'fas fa-hand-paper',
                                label = 'Włącz',
                            },
                            {
                                event = 'wasabi_boombox:pickup',
                                icon = 'fas fa-volume-up',
                                label = 'Podnieś'
                            }
    
                        },
                        job = 'all',
                        distance = 1.5
                    })
                    targetPlaced = true
                elseif not DoesEntityExist(obj) then
                    exports['qb-target']:RemoveZone('boomboxzone')
                    targetPlaced = false
                    break
                end
                Wait(1000)
            end
        end)
    end
end

interactBoombox = function(radio, radioCoords)
    if not activeRadios[radio] then
        activeRadios[radio] = {
            pos = radioCoords,
            data = {
                playing = false
            }
        }
    else
        activeRadios[radio].pos = radioCoords
    end
    TriggerServerEvent('wasabi_boombox:syncActive', activeRadios)
    if not activeRadios[radio].data.playing then
        lib.registerContext({
            id = 'boomboxFirst',
            title = 'Boombox',
            options = {
                {
                    title = 'Włącz Piosenke',
                    description = 'Włącz muzyke na boomboxie',
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = 'Zapisane Piosenki',
                    description = 'Piosenki które zapisałeś',
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                }
            }
        })
        lib.showContext('boomboxFirst')
    else
        lib.registerContext({
            id = 'boomboxSecond',
            title = 'Boombox',
            options = {
                {
                    title = 'Zmień Piosenke',
                    description = 'Zmień aktualną piosenke',
                    arrow = true,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'play', id = radio}
                },
                {
                    title = 'Zapisane Piosenki',
                    description = 'Piosenki które zapisałeś',
                    arrow = true,
                    event = 'wasabi_boombox:savedSongs',
                    args = {id = radio}
                },
                {
                    title = 'Wyłącz Muzyke',
                    description = 'Wyłącz aktualną piosenke',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'stop', id = radio}
                },
                {
                    title = 'Zmień Głośność',
                    description = 'Ustal głośność piosenki',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'volume', id = radio}
                },
                {
                    title = 'Zmień Dystans',
                    description = 'Ustaw dystans piosenki',
                    arrow = false,
                    event = 'wasabi_boombox:playMenu',
                    args = {type = 'distance', id = radio}
                }
            }
        })
        lib.showContext('boomboxSecond')
    end
end

selectSavedSong = function(data)
    lib.registerContext({
        id = 'selectSavedSong',
        title = 'Zarządzaj',
        options = {
            {
                title = 'Włącz Piosenke',
                description = 'Włącz tą piosenke',
                arrow = false,
                event = 'wasabi_boombox:playSavedSong',
                args = data
            },
            {
                title = 'Usuń Piosenke',
                description = 'Usuń tą piosenke',
                arrow = true,
                event = 'wasabi_boombox:deleteSong',
                args = data
            }
        }
    })
    lib.showContext('selectSavedSong')
end

if Config.Framework == "ESX" then
    savedSongsMenu = function(radio)
        ESX.TriggerServerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = 'Zapisz Piosenke',
                    description = 'Zapisz piosenke na później',
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = 'Boombox',
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
elseif Config.Framework == "QB" then
    savedSongsMenu = function(radio)
        QBCore.Functions.TriggerCallback('wasabi_boombox:getSavedSongs', function(cb)
            local radio = radio.id
            local Options = {
                {
                    title = 'Zapisz Piosenke',
                    description = 'Zapisz piosenke na później',
                    arrow = true,
                    event = 'wasabi_boombox:saveSong',
                    args = {id = radio}
                }
            }
            if cb then
                for i=1, #cb do
                    print(radio)
                    table.insert(Options, {
                        title = cb[i].label,
                        description = '',
                        arrow = true,
                        event = 'wasabi_boombox:selectSavedSong',
                        args = {id = radio, link = cb[i].link, label = cb[i].label}
                    })
                end
            end
            lib.registerContext({
                id = 'boomboxSaved',
                title = 'Boombox',
                options = Options
            })
            lib.showContext('boomboxSaved')
        end)
    end
end
