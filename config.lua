Config = {}

Config = {
    Items = {
        Seed = 'weed_seed',
        Water = 'weed_water',
        Fertilizer = 'weed_fertilizer',
        Weed = 'weed',
        Lighter = 'lighter'
    },

    Plant = {
        GrowthTime = 3,
        WaterDecrease = 0.1,
        FertilizerDecrease = 0.05,
        QualityIncrease = 5,
        StartingValues = {
            Water = 100,
            Fertilizer = 100,
            Quality = 100
        }
    },

    PlantingZones = {
        {
            coords = vector3(2220.12, 5577.34, 53.84),
            radius = 50.0,
            name = "Pole 1"
        },
        {
            coords = vector3(2125.45, 5625.12, 54.20),
            radius = 30.0,
            name = "Pole 2"
        }
    },

    PlantModels = {
        [1] = {
            model = "bkr_prop_weed_01_small_01c",
            zOffset = -1.0
        },
        [2] = {
            model = "bkr_prop_weed_med_01a",
            zOffset = -1.0
        },
        [3] = {
            model = "bkr_prop_weed_lrg_01a",
            zOffset = -1.0
        }
    },

    Harvest = {
        Min = 1,
        Max = 3,
        QualityMultiplier = true
    },

    Animations = {
        Planting = { dict = "timetable@gardener@filling_can", anim = "gar_ig_5_filling_can", flag = 1 },
        Watering = { dict = "timetable@gardener@filling_can", anim = "gar_ig_5_filling_can", flag = 1 },
        Fertilizing = { dict = "timetable@gardener@filling_can", anim = "gar_ig_5_filling_can", flag = 1 },
        Harvesting = { dict = "mini@repair", anim = "fixing_a_player", flag = 1 },
        Destroying = { dict = "amb@world_human_stand_fire@male@base", anim = "base", flag = 49 }
    },

    Progress = {
        Planting = { label = 'Sadzenie rośliny...', duration = 7500 },
        Watering = { label = 'Podlewanie...', duration = 3000 },
        Fertilizing = { label = 'Nawożenie...', duration = 3000 },
        Harvesting = { label = 'Zbieranie...', duration = 5000 },
        Destroying = { label = 'Podpalanie rośliny...', duration = 5000 }
    },

    DestroyEffect = {
        dict = "core",
        name = "ent_sht_petrol_fire",
        scale = 2.0,
        duration = 3000,
        offset = vector3(0.0, 0.0, -0.5)
    },

    Target = {
        icon = 'fas fa-cannabis',
        label = 'Sprawdź roślinę',
        distance = 2.0
    }
}
