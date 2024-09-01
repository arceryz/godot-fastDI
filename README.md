# Fast Debug Interface for Godot4+

![fastDI](/fastDI.png)

A single scene, single script debug interface for Godot 4+. *Designed to just copy paste*. Just copy paste and get a basic debug menu for your games.

# Features

All these features are in-game:
- **Camera Swapping** with cameras in group `game_camera` and shortcut `CTRL-C`.
- **Flag Setting/Getting** with `GetFlag` and `SetFlag`.
- **True Editor Console** (works with `print()` statements).
- **Time Plotter** with colors and multiple graphs per plot using the `SetPlotSample` function.
- **Value Sliders** for float values using the `SetValue`, `GetValue` and `SetValueRange` functions.
- **Pause Menu + Exit Game Button**

Everything is centered on the two files `fastDI.gd` and `fastDI.tscn`. The
full documentation is present in the GDscript file.

The UI layout can be modified by changing the scene.

# Installation

To install, simply download the two files
- [fastDI.gd](/fastDI/fastDI.gd)
- [fastDI.tscn](/fastDI/fastDI.tscn)

and put them anywhere in your project. Then either add the `fastDI.tscn` as an autoload for global access,
or place it locally in the scene where you want to use the UI (but you will not get glboal access).

# Demo

A demo scene is included with a player controller. The plots are driven from the file [scn_test.gd](/scn_test.gd). Refer to the demo and the UI script [fastDI.gd](/fastDI/fastDI.gd) if you need information!

![fastDI_demo](/demo.gif)
