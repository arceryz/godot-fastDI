# Fast Debug Interface for Godot4+

![fastDI](/fastDI.png)

A feature-rich yet simple debug UI that is fast to set up in your project. Only one [GDScript](/fastDI/fastDI.gd) and one [Scene](/fastDI/fastDI.tscn) file that you must include in your project. Access globally with autoload or locally with instantiation, as you prefer. FastDI strifes to be that simple solution to improve your quality-of-life when debugging.

# Demo

A demo scene is included with a player controller. All calls to the `FastDI` autoload are made from [scn_test.gd](/scn_test.gd).

![fastDI_demo](/demo.gif)

# Features

The debug interface supports all of the following features:
- **Camera Swapping** with cameras in group `game_camera` and shortcut `CTRL-C`.
- **Flag Setting/Getting** with `GetFlag` and `SetFlag`.
- **True Editor Console** (works with `print()` statements).
- **Time Plotter** with colors and multiple graphs per plot using the `SetPlotSample` function.
- **Value Sliders** for float values using the `SetValue`, `GetValue` and `SetValueRange` functions.
- **Pause Menu + Exit Game Button**

Everything is centered on the two files `fastDI.gd` and `fastDI.tscn`. The
full documentation is present in the GDscript file. You can disable features by not using the associated API functions. The UI can be tailored to your liking in the scene file [scn_test.tscn](/scn_test.tscn).

# Installation

To install, simply download the two files
- [fastDI.gd](/fastDI/fastDI.gd)
- [fastDI.tscn](/fastDI/fastDI.tscn)

and put them anywhere in your project. Then either add the `fastDI.tscn` as an autoload for global access,
or place it locally in the scene where you want to use the UI, but you will have to link signals manually.

# Contributing

If you find any bugs, or have suggestions for an improvement, please create an issue. I strife to maintain this debug interface to be accessible to anyone without bloat.