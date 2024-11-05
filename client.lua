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

local function WeedDestroy(plantId)
    if not WeedPlants[plantId] then return end

    lib.callback('snaily_weed:checkLighter', false, function(hasLighter, error)
        if not hasLighter then
            lib.notify({
                type = 'error',
                title = 'Błąd',
                description = error or 'Potrzebujesz zapalniczki!'
            })
            return
        end

        local plantCoords = WeedPlants[plantId].coords

        PlayAnim(Config.Animations.Destroying)
        if lib.progressBar({
            duration = Config.Progress.Destroying.duration,
            label = Config.Progress.Destroying.label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            }
        }) then
            lib.callback('snaily_weed:checkLighter', false, function(stillHasLighter)
                if not stillHasLighter then
                    lib.notify({
                        type = 'error',
                        title = 'Błąd',
                        description = 'Potrzebujesz zapalniczki!'
                    })
                    ClearPedTasks(PlayerPedId())
                    return
                end

                RequestNamedPtfxAsset(Config.DestroyEffect.dict)
                while not HasNamedPtfxAssetLoaded(Config.DestroyEffect.dict) do
                    Wait(0)
                end

                UseParticleFxAssetNextCall(Config.DestroyEffect.dict)
                local fire = StartParticleFxLoopedAtCoord(
                    Config.DestroyEffect.name,
                    plantCoords.x + Config.DestroyEffect.offset.x,
                    plantCoords.y + Config.DestroyEffect.offset.y,
                    plantCoords.z + Config.DestroyEffect.offset.z,
                    0.0, 0.0, 0.0,
                    Config.DestroyEffect.scale,
                    false, false, false
                )

                Wait(math.floor(Config.DestroyEffect.duration * 0.66))

                lib.callback('snaily_weed:WeedDestroy', false, function(success)
                    if success then
                        Wait(math.floor(Config.DestroyEffect.duration * 0.34))
                        StopParticleFxLooped(fire, 0)
                        RemoveNamedPtfxAsset(Config.DestroyEffect.dict)
                        lib.notify(Config.Notify.Success.Destroyed)
                    end
                end, plantId)
            end)
        end
        ClearPedTasks(PlayerPedId())
    end)
end

local function WeedMenu(plantId)
    local plant = WeedPlants[plantId]
    if not plant then return end

    local options = {
        {
            title = 'Wzrost rośliny',
            description = ('Aktualny poziom wzrostu: %d%%'):format(math.floor(plant.growth or 0)),
            progress = math.floor(plant.growth or 0),
            colorScheme = 'green',
            icon = 'arrow-up'
        },
        {
            title = 'Podlej roślinę',
            description = ('Poziom wody: %d%%'):format(math.floor(plant.water or 0)),
            progress = math.floor(plant.water or 0),
            colorScheme = 'green',
            icon = 'droplet',
            onSelect = function()
                lib.callback('snaily_weed:waterPlant', false, function(success)
                    if success then
                        PlayAnim(Config.Animations.Watering)
                        lib.progressBar(Config.Progress.Watering)
                        ClearPedTasks(PlayerPedId())
                    end
                end, plantId)
            end
        },
        {
            title = 'Dodaj nawóz',
            description = ('Poziom nawozu: %d%%'):format(math.floor(plant.fertilizer or 0)),
            progress = math.floor(plant.fertilizer or 0),
            colorScheme = 'green',
            icon = 'seedling',
            onSelect = function()
                lib.callback('snaily_weed:fertilizePlant', false, function(success)
                    if success then
                        PlayAnim(Config.Animations.Fertilizing)
                        lib.progressBar(Config.Progress.Fertilizing)
                        ClearPedTasks(PlayerPedId())
                    end
                end, plantId)
            end
        },
        {
            title = 'Jakość rośliny',
            description = ('Aktualna jakość: %d%%'):format(math.floor(plant.quality or 0)),
            progress = math.floor(plant.quality or 0),
            colorScheme = 'green',
            icon = 'star'
        },
        {
            title = 'Zniszcz roślinę',
            description = 'Spal roślinę',
            icon = 'fire',
            onSelect = function()
                WeedDestroy(plantId)
            end
        },
        {
            title = 'Zbierz roślinę',
            description = math.floor(plant.growth or 0) >= 100 and 'Roślina gotowa do zbioru' or 'Roślina nie jest jeszcze gotowa',
            icon = 'cannabis',
            disabled = math.floor(plant.growth or 0) < 100,
            onSelect = function()
                if math.floor(plant.growth or 0) >= 100 then
                    PlayAnim(Config.Animations.Harvesting)
                    lib.progressBar(Config.Progress.Harvesting)
                    ClearPedTasks(PlayerPedId())

                    lib.callback('snaily_weed:harvestPlant', false, function(success)
                        if success then
                            lib.notify(Config.Notify.Success.Harvested)
                        end
                    end, plantId)
                end
            end
        }
    }

    lib.registerContext({
        id = 'plant_menu',
        title = 'Stan rośliny',
        options = options
    })

    lib.showContext('plant_menu')
end

RegisterNetEvent('snaily_weed:useSeed', function()
    PlayAnim(Config.Animations.Planting)

    if lib.progressBar(Config.Progress.Planting) then
        ClearPedTasks(PlayerPedId())
        local coords = GetEntityCoords(PlayerPedId())

        lib.callback('snaily_weed:plantSeed', false, function(success)
            if success then
                lib.notify(Config.Notify.Success.Planted)
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
