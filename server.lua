local WeedPlants = {}

lib.callback.register('snaily_weed:plantSeed', function(source, coords)
    local hasSeeds = exports.ox_inventory:GetItem(source, Config.Items.Seed, 1)

    if hasSeeds then
        exports.ox_inventory:RemoveItem(source, Config.Items.Seed, 1)
        local plantId = #WeedPlants + 1
        WeedPlants[plantId] = {
            coords = coords,
            growth = 0,
            water = Config.Plant.StartingValues.Water,
            fertilizer = Config.Plant.StartingValues.Fertilizer,
            quality = Config.Plant.StartingValues.Quality
        }
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:waterPlant', function(source, plantId)
    local hasWater = exports.ox_inventory:GetItem(source, Config.Items.Water, 1)

    if hasWater and WeedPlants[plantId] then
        exports.ox_inventory:RemoveItem(source, Config.Items.Water, 1)
        WeedPlants[plantId].water = Config.Plant.StartingValues.Water
        WeedPlants[plantId].quality = math.min(100, WeedPlants[plantId].quality + Config.Plant.QualityIncrease)
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:fertilizePlant', function(source, plantId)
    local hasFertilizer = exports.ox_inventory:GetItem(source, Config.Items.Fertilizer, 1)

    if hasFertilizer and WeedPlants[plantId] then
        exports.ox_inventory:RemoveItem(source, Config.Items.Fertilizer, 1)
        WeedPlants[plantId].fertilizer = Config.Plant.StartingValues.Fertilizer
        WeedPlants[plantId].quality = math.min(100, WeedPlants[plantId].quality + Config.Plant.QualityIncrease)
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:harvestPlant', function(source, plantId)
    if WeedPlants[plantId] and WeedPlants[plantId].growth >= 100 then
        local amount = math.random(Config.Harvest.Min, Config.Harvest.Max)
        if Config.Harvest.QualityMultiplier then
            amount = math.ceil(amount * (WeedPlants[plantId].quality / 100))
        end

        exports.ox_inventory:AddItem(source, Config.Items.Weed, amount)
        WeedPlants[plantId] = nil
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

lib.callback.register('snaily_weed:destroyPlant', function(source, plantId)
    if WeedPlants[plantId] then
        WeedPlants[plantId] = nil
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
        return true
    end
    return false
end)

CreateThread(function()
    while true do
        Wait(1000)
        for plantId, plant in pairs(WeedPlants) do
            plant.water = math.max(0, plant.water - Config.Plant.WaterDecrease)
            plant.fertilizer = math.max(0, plant.fertilizer - Config.Plant.FertilizerDecrease)

            if plant.water > 0 and plant.fertilizer > 0 then
                plant.growth = math.min(100, plant.growth + (100 / (Config.Plant.GrowthTime * 60)))
            end

            if plant.water == 0 or plant.fertilizer == 0 then
                plant.quality = math.max(0, plant.quality - 1)
            end
        end
        TriggerClientEvent('snaily_weed:syncPlants', -1, WeedPlants)
    end
end)
