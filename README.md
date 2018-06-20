# Whistle Stop Factories
Factorio mod that spawns massive furnances and assembly machines around the map to make the game all about trains.

## Build Instructions

### Configuration
In `config/buildinfo.json` change the value of `output_directory` to point to the `/mods` folder of the Factorio installation you wish to target.

### Windows Build
In Powershell, run `build.ps1`. This will clean out the old mod folder and copy the necessary files to a new mod folder in your specefied factorio installation. It takes care of giving it the proper version suffix to match the `info.json`.

### Windows Deploy
In Powershell reun `deplpy.ps1 -Tag [Tag Name]`. This will checkout the specified Tag (if it exists) and create a zip package ready to drop into a mods folder. The tag name is identical to the version number built.


### Thank You

Thank you to users DellAquila, Daedeross, Gangsir, and Bilka for their contributions to this mod