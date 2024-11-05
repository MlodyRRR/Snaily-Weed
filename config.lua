Config = {}

Config.Items = {
    Seed = 'weed_seed',
    Water = 'weed_water',
    Fertilizer = 'weed_fertilizer',
    Weed = 'weed',
    Lighter = 'lighter'
}

Config.Plant = {
    GrowthTime = 0.5,          -- Czas w minutach do pełnego wzrostu
    WaterDecrease = 0.1,       -- Spadek wody na sekundę
    FertilizerDecrease = 0.05, -- Spadek nawozu na sekundę
    QualityIncrease = 5,       -- Wzrost jakości przy podlewaniu/nawożeniu
    StartingValues = {
        Water = 100,
        Fertilizer = 100,
        Quality = 100
    },
    Model = "prop_weed_02",
    ZOffset = -1.0
}

Config.Harvest = {
    Min = 1,
    Max = 3,
    QualityMultiplier = true
}

Config.Animations = {
    Planting = {
        dict = "timetable@gardener@filling_can",
        anim = "gar_ig_5_filling_can",
        flag = 1
    },
    Watering = {
        dict = "timetable@gardener@filling_can",
        anim = "gar_ig_5_filling_can",
        flag = 1
    },
    Fertilizing = {
        dict = "timetable@gardener@filling_can",
        anim = "gar_ig_5_filling_can",
        flag = 1
    },
    Harvesting = {
        dict = "mini@repair",
        anim = "fixing_a_player",
        flag = 1
    },
    Destroying = {
        dict = "amb@world_human_stand_fire@male@base",
        anim = "base",
        flag = 49
    }
}

Config.Progress = {
    Planting = {
        label = 'Sadzenie rośliny...',
        duration = 7500
    },
    Watering = {
        label = 'Podlewanie...',
        duration = 3000
    },
    Fertilizing = {
        label = 'Nawożenie...',
        duration = 3000
    },
    Harvesting = {
        label = 'Zbieranie...',
        duration = 5000
    },
    Destroying = {
        label = 'Podpalanie rośliny...',
        duration = 5000
    }
}

Config.DestroyEffect = {
    dict = "core",
    name = "ent_sht_petrol_fire",
    scale = 2.0,
    duration = 3000,
    offset = {
        x = 0.0,
        y = 0.0,
        z = -0.5
    }
}

Config.Notify = {
    Success = {
        Planted = {
            title = 'Sukces',
            description = 'Zasadzono roślinę'
        },
        Watered = {
            title = 'Sukces',
            description = 'Podlano roślinę'
        },
        Fertilized = {
            title = 'Sukces',
            description = 'Nawożono roślinę'
        },
        Harvested = {
            title = 'Sukces',
            description = 'Zebrano roślinę'
        },
        Destroyed = {
            title = 'Sukces',
            description = 'Zniszczono roślinę'
        }
    },
    Error = {
        NoLighter = {
            title = 'Błąd',
            description = 'Potrzebujesz zapalniczki!'
        }
    }
}

Config.Target = {
    icon = 'fas fa-cannabis',
    label = 'Sprawdź roślinę',
    distance = 2.0
}
