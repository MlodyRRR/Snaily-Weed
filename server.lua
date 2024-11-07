local WeedPlants = {}

local function LoadPlants()
    local SaveFile = LoadResourceFile(GetCurrentResourceName(), "snaily-weedData.json")
    if SaveFile then
        WeedPlants = json.decode(SaveFile) or {}
    end
end

local function SavePlants()
    SaveResourceFile(GetCurrentResourceName(), "snaily-weedData.json", json.encode(WeedPlants), -1)
end

CreateThread(function()
    LoadPlants()
end)

local function IsInPlantingZone(coords)
    for _, zone in pairs(Config.PlantingZones) do
        if #(coords - zone.coords) <= zone.radius then
            return true
        end
    end
    return false
end

lib.callback.register('snaily_weed:plantSeed', function(source, coords)
    if not IsInPlantingZone(coords) then
        lib.notify(source, {
            type = 'error',
            description = 'Nie możesz tu sadzić!'
        })
        return false
    end

    if exports.ox_inventory:RemoveItem(source, Config.Items.Seed, 1) then
        local plantId = 1
        while WeedPlants[plantId] do
            plantId = plantId + 1
        end

        WeedPlants[plantId] = {
            coords = coords,
            growth = 0,
            water = Config.Plant.StartingValues.Water,
            fertilizer = Config.Plant.StartingValues.Fertilizer,
            quality = Config.Plant.StartingValues.Quality
        }
        SavePlants()
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:waterPlant', function(source, plantId)
    if not WeedPlants[plantId] then return false end

    if exports.ox_inventory:RemoveItem(source, Config.Items.Water, 1) then
        WeedPlants[plantId].water = Config.Plant.StartingValues.Water
        WeedPlants[plantId].quality = math.min(100, WeedPlants[plantId].quality + Config.Plant.QualityIncrease)
        SavePlants()
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:fertilizePlant', function(source, plantId)
    if not WeedPlants[plantId] then return false end

    if exports.ox_inventory:RemoveItem(source, Config.Items.Fertilizer, 1) then
        WeedPlants[plantId].fertilizer = Config.Plant.StartingValues.Fertilizer
        WeedPlants[plantId].quality = math.min(100, WeedPlants[plantId].quality + Config.Plant.QualityIncrease)
        SavePlants()
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:harvestPlant', function(source, plantId)
    if not WeedPlants[plantId] or WeedPlants[plantId].growth < 100 then return false end

    local amount = math.random(Config.Harvest.Min, Config.Harvest.Max)
    if Config.Harvest.QualityMultiplier then
        amount = math.ceil(amount * (WeedPlants[plantId].quality / 100))
    end

    if exports.ox_inventory:AddItem(source, Config.Items.Weed, amount) then
        WeedPlants[plantId] = nil
        SavePlants()
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:WeedDestroy', function(source, plantId)
    if not WeedPlants[plantId] then return false end

    WeedPlants[plantId] = nil
    SavePlants()
    TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
    return true
end)

CreateThread(function()
    while true do
        Wait(1000)
        local needsUpdate = false

        for plantId, plant in pairs(WeedPlants) do
            local oldGrowth = plant.growth
            plant.water = math.max(0, plant.water - Config.Plant.WaterDecrease)
            plant.fertilizer = math.max(0, plant.fertilizer - Config.Plant.FertilizerDecrease)

            if plant.water > 0 and plant.fertilizer > 0 then
                plant.growth = math.min(100, plant.growth + (100 / (Config.Plant.GrowthTime * 60)))
            end

            if plant.water == 0 or plant.fertilizer == 0 then
                plant.quality = math.max(0, plant.quality - 1)
            end

            if oldGrowth ~= plant.growth then
                needsUpdate = true
            end
        end

        if needsUpdate then
            SavePlants()
            TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        end
    end
end)
