# Asset sources and licenses

Every asset in `game/assets/` is procedural (made in this repo) or CC0 (Poly Haven, Kenney, Quaternius).
Add one row per asset or asset pack when it lands (architecture.md §12.3, orchestrator call C1).

| Path | Source | Author | License | Notes |
|---|---|---|---|---|
| `game/spikes/hd2d/textures/ph/dark_wooden_planks/` | https://polyhaven.com/a/dark_wooden_planks | Poly Haven | CC0 1.0 | A09 HD-2D spike, 1k JPG (diff, nor_gl, rough, ao) |
| `game/spikes/hd2d/textures/ph/granite_tile/` | https://polyhaven.com/a/granite_tile | Poly Haven | CC0 1.0 | A09 spike: micro detail under the procedural carved floor |
| `game/spikes/hd2d/textures/ph/large_sandstone_blocks/` | https://polyhaven.com/a/large_sandstone_blocks | Poly Haven | CC0 1.0 | A09 spike: Karak Ostrel walls and pillars (tinted cold) |
| `game/spikes/hd2d/textures/ph/monastery_stone_floor/` | https://polyhaven.com/a/monastery_stone_floor | Poly Haven | CC0 1.0 | A09 spike: hearthstones |
| `game/spikes/hd2d/textures/ph/old_planks_02/` | https://polyhaven.com/a/old_planks_02 | Poly Haven | CC0 1.0 | A09 spike: tavern timber walls, shutters |
| `game/spikes/hd2d/textures/ph/rough_block_wall/` | https://polyhaven.com/a/rough_block_wall | Poly Haven | CC0 1.0 | A09 spike: tavern stone footing, hearth |
| `game/spikes/hd2d/textures/ph/rusty_metal_02/` | https://polyhaven.com/a/rusty_metal_02 | Poly Haven | CC0 1.0 | A09 spike: iron railings and the bulkhead (darkened) |
| `game/spikes/hd2d/textures/ph/seaworn_stone_tiles/` | https://polyhaven.com/a/seaworn_stone_tiles | Poly Haven | CC0 1.0 | A09 spike: tavern floor, quay |
| `game/spikes/hd2d/textures/ph/wood_table_worn/` | https://polyhaven.com/a/wood_table_worn | Poly Haven | CC0 1.0 | A09 spike: table tops, benches |
| `game/spikes/hd2d/textures/ph/quarry_wall/` | https://polyhaven.com/a/quarry_wall | Poly Haven | CC0 1.0 | A09 spike: 2k photo grain for the baked carved floors |
| `game/spikes/hd2d/kaykit/adventurers/` | https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Adventures-1.0 | Kay Lousberg | CC0 1.0 | A09 spike: rigged characters (3D-render sprite fallback); LICENSE.txt included |
| `game/spikes/hd2d/kaykit/skeletons/` | https://github.com/KayKit-Game-Assets/KayKit-Character-Pack-Skeletons-1.0 | Kay Lousberg | CC0 1.0 | A09 spike: LICENSE.txt included |
| `game/spikes/hd2d/kaykit/dungeon/` | https://github.com/KayKit-Game-Assets/KayKit-Dungeon-Remastered-1.0 | Kay Lousberg | CC0 1.0 | A09 spike: tables, stools, barrels, candles, torches, bottles; LICENSE.txt included |
| `game/spikes/hd2d/kaykit/recolor/` | derived from the KayKit atlases above by `art-src/recolor_kaykit.py` | A09 | CC0 1.0 (derivative) | role palette swaps |
| `game/spikes/hd2d/textures/baked/` | procedural, `art-src/bake_floors.py` (photo grain: Poly Haven quarry_wall) | A09 | CC0 1.0 | carved floor panels |
| `game/spikes/hd2d/sprites/` | procedural, hand-authored maps in `art-src/pixel/` | A09 | project-original | pixel sprites + generated normal maps |
| `game/spikes/hd2d/textures/ph/rough_wood/` | https://polyhaven.com/a/rough_wood | Poly Haven | CC0 1.0 | A10 Drowned Rat set: timbers, planks, bark (2k, also the floor-bake grain) |
| `game/spikes/hd2d/textures/ph/weathered_planks/` | https://polyhaven.com/a/weathered_planks | Poly Haven | CC0 1.0 | A10: downloaded as an alternative plank grain (2k) |
| `game/spikes/hd2d/textures/ph/clay_plaster/` | https://polyhaven.com/a/clay_plaster | Poly Haven | CC0 1.0 | A10: stoneware crock material |
| `game/spikes/hd2d/textures/ph/worn_cracked_plaster/` | https://polyhaven.com/a/worn_cracked_plaster | Poly Haven | CC0 1.0 | A10: plaster candidate (unused in the final shot) |
| `game/spikes/hd2d/textures/ph/rough_plaster_03/` | https://polyhaven.com/a/rough_plaster_03 | Poly Haven | CC0 1.0 | A10: lime-wash plaster infill |
| `game/spikes/hd2d/textures/ph/wood_planks_dirt/` | https://polyhaven.com/a/wood_planks_dirt | Poly Haven | CC0 1.0 | A10: plank candidate (unused in the final shot) |
| `game/spikes/hd2d/models/ph_src/<id>/` | https://polyhaven.com/a/<id> for wine_barrel_01, wooden_crate_01, wooden_crate_02, wooden_stool_02, folding_wooden_stool, wooden_picnic_table, wooden_bucket_01, wooden_bucket_02, wicker_basket_01, wooden_bowl_01, carved_wooden_plate, wooden_cutting_board, wooden_candlestick, wooden_lantern_01, wooden_broom, treasure_chest, street_rat, hamburger_buns, food_apple_01, yellow_onion, ceramic_pot, brass_pot_01, brass_pan_01, dutch_ship_medium, ship_pinnace, modular_wooden_pier, wooden_ladder, wooden_axe | Poly Haven | CC0 1.0 | A10 raw 1k glTF sources (`art-src/env/fetch_polyhaven.py`), `.gdignore`d; ~100 MB, re-downloadable, candidates for .gitignore |
| `game/spikes/hd2d/models/env/taproom_props.glb` | derived: the Poly Haven models above, decimated, textures at 512 px (`art-src/env/build_taproom.py`) | Poly Haven / A10 | CC0 1.0 (derivative) | Drowned Rat props |
| `game/spikes/hd2d/models/env/taproom_arch.glb`, `taproom_anchors.json` | procedural, `art-src/env/build_taproom.py` + `envlib.py` (Blender 5.3) | A10 | project-original | Drowned Rat architecture, set dressing, quay, light anchors |
| `game/spikes/hd2d/textures/baked/taproom_floor_*.png`, `taproom_rug_albedo.png` | procedural, `art-src/env/bake_taproom_floor.py`, `bake_rug.py` (grain: Poly Haven rough_wood) | A10 | CC0 1.0 | unique plank floor, woven rug |
