local WeedPlants = {}
local PlantObjects = {}

local function PlayAnim(animData)
    if not animData or not animData.dict or not animData.anim then return end

    RequestAnimDict(animData.dict)
    while not HasAnimDictLoaded(animData.dict) do
        Wait(10)
    end

    TaskPlayAnim(PlayerPedId(), animData.dict, animData.anim, 8.0, -8.0, -1, animData.flag or 1, 0, false, false, false)
end

local function CleanupPlantObjects()
    for _, object in pairs(PlantObjects) do
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
    end
    PlantObjects = {}
end

local function WeedMenu(plantId)
    local plant = WeedPlants[plantId]
    if not plant then return end

    local menuOpen = true

    local options = {
        {
            title = 'Wzrost rośliny',
            description = ('Aktualny poziom wzrostu: %d%%'):format(math.floor(plant.growth or 0)),
            progress = math.floor(plant.growth or 0),
            colorScheme = 'green',
            icon = 'arrow-up'
        },
        {
            title = ' ',
            description = ' ',
            disabled = true
        },
        {
            title = 'Podlej roślinę',
            description = ('Poziom wody: %d%%\nPodlewanie zwiększy jakość rośliny'):format(math.floor(plant.water or 0)),
            progress = math.floor(plant.water or 0),
            colorScheme = 'green',
            icon = 'droplet',
            onSelect = function()
                lib.callback('snaily_weed:waterPlant', false, function(success)
                    if success then
                        PlayAnim(Config.Animations.Watering)
                        if lib.progressBar({
                                duration = Config.Progress.Watering.duration,
                                label = Config.Progress.Watering.label,
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                }
                            }) then
                            ClearPedTasks(PlayerPedId())
                        else
                            ClearPedTasks(PlayerPedId())
                        end
                    end
                end, plantId)
            end
        },
        {
            title = 'Dodaj nawóz',
            description = ('Poziom nawozu: %d%%\nNawożenie zwiększy jakość rośliny'):format(math.floor(plant.fertilizer or
                0)),
            progress = math.floor(plant.fertilizer or 0),
            colorScheme = 'green',
            icon = 'seedling',
            onSelect = function()
                lib.callback('snaily_weed:fertilizePlant', false, function(success)
                    if success then
                        PlayAnim(Config.Animations.Fertilizing)
                        if lib.progressBar({
                                duration = Config.Progress.Fertilizing.duration,
                                label = Config.Progress.Fertilizing.label,
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                }
                            }) then
                            ClearPedTasks(PlayerPedId())
                        else
                            ClearPedTasks(PlayerPedId())
                        end
                    end
                end, plantId)
            end
        },
        {
            title = 'Jakość rośliny',
            description = ('Aktualna jakość rośliny: %d%%'):format(math.floor(plant.quality or 0)),
            progress = math.floor(plant.quality or 0),
            colorScheme = 'green',
            icon = 'star'
        },
        {
            title = ' ',
            description = ' ',
            disabled = true
        },
        {
            title = 'Zniszcz roślinę',
            description = 'Usuń roślinę',
            icon = 'trash',
            onSelect = function()
                PlayAnim(Config.Animations.Harvesting)
                if lib.progressBar({
                        duration = Config.Progress.Destroying.duration,
                        label = Config.Progress.Destroying.label,
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true,
                        }
                    }) then
                    ClearPedTasks(PlayerPedId())
                    lib.callback('snaily_weed:destroyPlant', false, function(success)
                        if success then
                            menuOpen = false
                            lib.notify({
                                title = Config.Notify.Success.Destroyed.title,
                                description = Config.Notify.Success.Destroyed.description,
                                type = 'success'
                            })
                        end
                    end, plantId)
                else
                    ClearPedTasks(PlayerPedId())
                end
            end
        },
        {
            title = 'Zbierz roślinę',
            description = math.floor(plant.growth or 0) >= 100 and 'Roślina gotowa do zbioru' or
                'Roślina nie jest jeszcze gotowa do zbioru',
            icon = 'cannabis',
            disabled = math.floor(plant.growth or 0) < 100,
            onSelect = function()
                if math.floor(plant.growth or 0) >= 100 then
                    PlayAnim(Config.Animations.Harvesting)
                    if lib.progressBar({
                            duration = Config.Progress.Harvesting.duration,
                            label = Config.Progress.Harvesting.label,
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                            }
                        }) then
                        ClearPedTasks(PlayerPedId())
                        lib.callback('snaily_weed:harvestPlant', false, function(success)
                            if success then
                                menuOpen = false
                                lib.notify({
                                    title = Config.Notify.Success.Harvested.title,
                                    description = Config.Notify.Success.Harvested.description,
                                    type = 'success'
                                })
                            end
                        end, plantId)
                    else
                        ClearPedTasks(PlayerPedId())
                    end
                end
            end
        }
    }

    lib.registerContext({
        id = 'plant_menu',
        title = 'Stan rośliny',
        options = options,
        onExit = function()
            menuOpen = false
        end
    })

    lib.showContext('plant_menu')
end

RegisterNetEvent('snaily_weed:useSeed', function()
    PlayAnim(Config.Animations.Planting)
    if lib.progressBar({
            duration = Config.Progress.Planting.duration,
            label = Config.Progress.Planting.label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            }
        }) then
        ClearPedTasks(PlayerPedId())
        local coords = GetEntityCoords(PlayerPedId())
        lib.callback('snaily_weed:plantSeed', false, function(success)
            if success then
                lib.notify({
                    title = Config.Notify.Success.Planted.title,
                    description = Config.Notify.Success.Planted.description,
                    type = 'success'
                })
            end
        end, coords)
    else
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('snaily_weed:syncPlants', function(serverPlants)
    CleanupPlantObjects()

    WeedPlants = serverPlants

    for plantId, plant in pairs(WeedPlants) do
        local object = CreateObject(Config.Plant.Model, plant.coords.x, plant.coords.y,
            plant.coords.z + Config.Plant.ZOffset, false, false, false)
        FreezeEntityPosition(object, true)
        plant.object = object
        table.insert(PlantObjects, object)

        exports.ox_target:addLocalEntity(object, {
            {
                name = 'check_plant',
                icon = Config.Target.icon,
                label = Config.Target.label,
                distance = Config.Target.distance,
                onSelect = function()
                    WeedMenu(plantId)
                end
            }
        })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    CleanupPlantObjects()
end)
