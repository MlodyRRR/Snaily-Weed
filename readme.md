# 🌿 Snaily Weed

## Wymagania
- ox_lib
- ox_target
- ox_inventory

## Instalacja
1. Wrzuć folder `snaily-weed` do folderu `resources`
2. Dodaj `ensure snaily-weed` do server.cfg
3. Dodaj przedmioty do ox_inventory/data/items.lua:
```lua
['weed_seed'] = {
    label = 'Nasiona marihuany',
    weight = 50,
    stack = true,
    close = true,
    description = 'Nasiona do zasadzenia marihuany',
    client = {
        event = 'snaily_weed:useSeed',
    }
},
['weed_water'] = {
    label = 'Woda',
    weight = 500,
    stack = true,
    close = true,
},
['weed_fertilizer'] = {
    label = 'Nawóz',
    weight = 300,
    stack = true,
    close = true,
},
['weed'] = {
    label = 'Marihuana',
    weight = 100,
    stack = true,
    close = true,
},
['lighter'] = {
    label = 'Zapalniczka',
    weight = 50,
    stack = true,
    close = true,
}
```

## Konfiguracja
Wszystkie ustawienia znajdują się w pliku `config.lua`:
- Czasy wzrostu
- Ilość otrzymywanych przedmiotów
- Wpływ jakości na ilość
- Animacje
- Notyfikacje
- I wiele więcej!

## Używanie
1. Użyj nasion aby posadzić roślinę
2. Podlewaj i nawóź roślinę aby utrzymać jej jakość
3. Gdy roślina osiągnie 100% wzrostu, możesz ją zebrać
4. Ilość otrzymanej marihuany zależy od jakości rośliny

## Wsparcie
- Discord: [Snaily Development](https://discord.gg/KCykBSAPsY)

## Autor
- MlodyR
- [Snaily Development](https://discord.gg/KCykBSAPsY)

## Licencja
licencja MIT.

# 🌿 Snaily Weed

## Requirements
- ox_lib
- ox_target
- ox_inventory

## Installation
1. Put the `snaily-weed` folder in your `resources` folder
2. Add `ensure snaily-weed` to server.cfg
3. Add items to ox_inventory/data/items.lua:
```lua
['weed_seed'] = {
    label = 'Nasiona marihuany',
    weight = 50,
    stack = true,
    close = true,
    description = 'Nasiona do zasadzenia marihuany',
    client = {
        event = 'snaily_weed:useSeed',
        image = 'weed_seed.png',
    }
},
['weed_water'] = {
    label = 'Water',
    weight = 500,
    stack = true,
    close = true,
},
['weed_fertilizer'] = {
    label = 'Fertilizer',
    weight = 300,
    stack = true,
    close = true,
},
['weed'] = {
    label = 'Weed',
    weight = 100,
    stack = true,
    close = true,
},
['lighter'] = {
    label = 'Ligher',
    weight = 50,
    stack = true,
    close = true,
},
```

## Configuration
All settings can be found in `config.lua`:
- Growth times
- Item rewards
- Quality impact on quantity
- Animations
- Notifications
- And much more!

## Usage
1. Use seeds to plant
2. Water and fertilize the plant to maintain quality
3. When the plant reaches 100% growth, you can harvest it
4. The amount of weed received depends on plant quality

## Support
- Discord: [Snaily Development](https://discord.gg/KCykBSAPsY)

## Author
- MlodyR
- [Snaily Development](https://discord.gg/KCykBSAPsY)

## License
MIT License
