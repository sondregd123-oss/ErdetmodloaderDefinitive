# Lage mods til ErdetModLoader

Dette er den raske måten å komme i gang på. Du trenger Godot 4.6 og en utviklingskopi av Erdetspill 1.1.2-prosjektet.

## 1. Skaff modloader-filene

Den enkleste løsningen er å åpne ErdetModLoader-ZIP-en og kopiere disse mappene inn i Godot-prosjektet ditt:

```
addons/mod_loader
addons/JSON_Schema_Validator
```

Du kan også hente Godot Mod Loader fra `https://github.com/GodotModding/godot-mod-loader` og bruke `4.x-dev`-versjonen. JSON Schema Validator må være med, ellers starter ikke loaderen.

Åpne prosjektet i Godot og gå til **Project → Project Settings → Globals → Autoload**. Legg dem til i denne rekkefølgen:

1. `res://addons/mod_loader/mod_loader_store.gd` med navnet `ModLoaderStore`
2. `res://addons/mod_loader/mod_loader.gd` med navnet `ModLoader`

De bør ligge øverst i autoload-lista.

## 2. Lag mod-mappa

Lag denne mappestrukturen i prosjektet:

```
mods-unpacked/
  DittNavn-EksempelMod/
    manifest.json
    mod_main.gd
```

`DittNavn` er namespace-et ditt. Bruk utviklernavnet eller teamnavnet ditt. To utviklere kan bruke samme modnavn så lenge namespace-et er forskjellig.

## 3. Lag en enkel eksempelmod

Legg dette i `manifest.json`:

```json
{
  "name": "EksempelMod",
  "namespace": "DittNavn",
  "version_number": "1.0.0",
  "description": "Viser en liten tekst på skjermen.",
  "website_url": "",
  "dependencies": [],
  "extra": {
    "godot": {
      "authors": ["DittNavn"],
      "tags": ["example"],
      "description_rich": "",
      "optional_dependencies": [],
      "load_before": [],
      "incompatibilities": [],
      "compatible_mod_loader_version": ["7.0.1"],
      "compatible_game_version": [],
      "config_schema": {}
    }
  }
}
```

La `compatible_game_version` være tom hvis modden ikke er låst til en bestemt spillversjon. Skriv inn versjoner der bare hvis du vet at modden trenger akkurat de versjonene.

Legg dette i `mod_main.gd`:

```gdscript
extends Node

func _ready() -> void:
	var label := Label.new()
	label.text = "Eksempelmodden virker!"
	label.position = Vector2(16, 16)
	label.add_theme_font_size_override("font_size", 20)
	add_child(label)
```

Start prosjektet i Godot. Hvis alt er riktig, finner loaderen `DittNavn-EksempelMod`, og teksten dukker opp øverst til venstre.

## 4. Pakk modden som ZIP

ZIP-en må inneholde `mods-unpacked` helt øverst. Den skal se sånn ut:

```
DittNavn-EksempelMod-1.0.0.zip
  mods-unpacked/
    DittNavn-EksempelMod/
      manifest.json
      mod_main.gd
```

På Windows kan du åpne Terminal i prosjektmappa og kjøre:

```text
tar -a -c -f DittNavn-EksempelMod-1.0.0.zip mods-unpacked/DittNavn-EksempelMod
```

Legg ZIP-en i `mods` ved siden av `erdetspill.exe` og start spillet. Ikke pakk ut ZIP-en i spillmappa.

## Endre et eksisterende script

Hvis du vil endre et script fra spillet, lager du samme filsti under `extensions`:

```
mods-unpacked/
  DittNavn-MinMod/
    manifest.json
    mod_main.gd
    extensions/
      scenes/
        ui/
          pause_menu.gd
```

`mod_main.gd` laster inn extension-fila:

```gdscript
extends Node

const MOD_ID := "DittNavn-MinMod"

func _init() -> void:
	var path := ModLoaderMod.get_unpacked_dir().path_join(MOD_ID).path_join("extensions/scenes/ui/pause_menu.gd")
	ModLoaderMod.install_script_extension(path)
```

Extension-fila arver originalen:

```gdscript
extends "res://scenes/ui/pause_menu.gd"
```

Hvis du overskriver en original funksjon, bruker du vanligvis `super()` så originalkoden fortsatt kjører.

## Flere mods samtidig

Forskjellige mods fungerer vanligvis sammen når de har unike namespace og ikke prøver å erstatte samme ting på helt forskjellige måter.

Bruk disse feltene i `manifest.json` når mods må lastes i en bestemt rekkefølge eller ikke fungerer sammen:

- `dependencies`
- `optional_dependencies`
- `load_before`
- `incompatibilities`

Test alltid modden både alene og sammen med mods som endrer de samme scenene eller scriptene.
