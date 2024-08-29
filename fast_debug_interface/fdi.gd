##### HOW TO USE THE FAST DEBUG INTERFACE #####
#
# SETUP
# 1A. If you want global access to all settings, make an autoload of the SCENE with name "FDI".
# 1B. If you want a UI per scene, just add the prefab to your scenes, but you will need to use
#     signals/global variables if you want to send the settings to your game.
# 2.  Configure the user interface to your liking by editing the UI scene (.tscn) file.
#
# FEATURES:
# The following features are present:
# - 3D Camera Swapping:
#      You can swap between any camera in the group given by variable camera_group_name.
#      By default, this value is set to "game_camera". Add all the camera's you wish to index
#      to this group. They will show up in the list.
#      
#      You can swap camera's by clicking the camera in the list OR by pressing the cycling
#      shortcut given by the event camera_cycle_event (default CTRL+C).
#      The same system can work for 2D camera's if you switch Camera3D variables to Camera2D.
# 
# - Boolean Flag Inspector:
#      The boolean flag inspector shows boolean values that can both be toggled from the UI
#      as well as code. Use the functions:
#         - SetFlag(...)
#         - GetFlag(...)
#       to work with the flags. Any non-existent flag will be created automatically.
#
# - In-game Editor Console:
#      The in-game editor console captures ANY printing you perform with regular print()
#      statements and displays them in a scrollable console.
#      To enable the editor console, you must enable file logging in the project settings.
#      You can configure the update interval of the console.
# 
# - Time plotter:
#      The time plotter allows you to plot any variable over time by calling
#         - SetPlotSample(...)
#      You can plot multiple values in a single plot, with multiple colors. 
#      Plots are automatically created when setting samples for new plots.
#      The only thing you have to do, is call SetPlotSample(...) anywhere in your code.
#      You can configure the time span and update interval of the plots.
#
# - Value sliders:
#      The final system is the value system. This system allows you to set/get float values
#      either from code or by using the sliders.
#      The two functions to use are:
#         - SetValue(...)
#         - GetValue(...)
#         - SetValueRange(...)
#      As usual, any non-existent sliders are created when they are used. Just make sure 
#      to set initial values when first calling (default values are 0).
#      Range and step for the slider can be set with SetValueRange(...), default (0-100 with step 0.1).
#      The slider's min and max values are adjusted automatically. To enforce a specific range,
#      clamp your input values and set the min/max values once.
#
# This entire interface can be accessed by pressing the event given by toggle_interface_event.
# By default, this is configured to ESC.
#
# You can also quit the game fast by pressing exit_game_event, default CTRL-Z.
# The UI buttons Return/Exit Game function the same way.
#
# The latest version of this script is always available at:
# https://github.com/arceryz/godot-fast-debug-interface
#
# Enjoy your software.
#
extends CanvasLayer

##### Signals #####
signal FlagChanged(flag: String, value: bool)

##### MainButtons #####
@onready var Logo: TextureRect = %Logo
@onready var MouseBlocker: Control = %MouseBlocker
@onready var MainButtons: Control = %MainButtons
@onready var ReturnButton: Button = %ReturnButton
@onready var ExitGameButton: Button = %ExitGameButton

##### Cameras #####
@onready var Cameras: Control = %Cameras
@onready var CameraList: ItemList = %CameraList
@onready var CamerasAlwaysVisibleCheckBox = %CamerasAlwaysVisibleCheckBox

##### Flags #####
@onready var Flags: Control = %Flags
@onready var FlagContainer: VBoxContainer = %FlagContainer
@onready var FlagTemplate: Control = %FlagTemplate
@onready var FlagsAlwaysVisibleCheckBox: CheckBox = %FlagsAlwaysVisibleCheckBox

##### Plots #####
@onready var PlotTemplate: Control = %PlotTemplate
@onready var PlotsContainer: VBoxContainer = %PlotsContainer
@onready var PlotsAlwaysVisibleCheckBox: CheckBox = %PlotsAlwaysVisibleCheckBox
@onready var Plots: Control = %Plots

##### Console #####
@onready var ConsoleText: RichTextLabel = %ConsoleText
@onready var ConsoleScrollContainer: ScrollContainer = %ConsoleScrollContainer
@onready var ConsoleScrollCheckBox: CheckBox = %ConsoleScrollCheckBox
@onready var ConsoleAlwaysVisibleCheckBox: CheckBox = %ConsoleAlwaysVisibleCheckBox
@onready var ConsoleClearButton: Button = %ConsoleClearButton
@onready var Console: Control = %Console

##### Values ######
@onready var Values: Control = %Values
@onready var ValuesAlwaysVisibleCheckBox: CheckBox = %ValuesAlwaysVisibleCheckBox
@onready var ValueContainer: GridContainer = %ValueContainer
@onready var ValueLabelTemplate: Label = %ValueLabelTemplate
@onready var ValueNumberTemplate: Label = %ValueNumberTemplate
@onready var ValueSliderTemplate: HSlider = %ValueSliderTemplate

##### Exports #####
@export var camera_group_name: String = "game_camera"
@export var console_update_interval: float = 0.1
@export var plot_time_range: float = 60.0
@export var plot_update_interval: float = 0.1

##### Events ######
@export var camera_cycle_event: InputEvent
@export var toggle_interface_event: InputEvent
@export var exit_game_event: InputEvent

##### Icons ######
const CAMERA3D_ICON := "/H9/APx/fwD8f38A/H9/APyAgAD8gIAA/ICAAPyAgAD8f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/ICAAPyAgAD8gIAA/H9/APx/fwD8f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/ICAAPx/fwD8gIAH/ICAjvx/f+n8f3/r/H9/i/x/fwT8f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/H9/APyAgAD8f38A/H9/j/x/f//8f3///H9///x/f//8f3+J/H9/APx/fwD8f38A/H9/APyAgAD8f38K/H9/mfx/f/P8gIDw/H9/j/yAgOz8f3///H9///x/f//8f3///H9/5/x/fwD8f38A/H9/AP1/fwD8gIAA/ICAnPx/f//8f3///H9///x/f//8f3///H9///x/f//8f3///H9///x/f+f8f38A/H9/AP1/fwD9f38A/ICAAPyAgPb8f3///H9///x/f//8f3///H9///x/f//8f3///H9///x/f//8f3+H/H9/AP1/fwD9f38A/X9/APx/fwH8f3/z/H9///x/f//8f3///H9///x/f//8f3///H9///x/f//8f3///H9/BP+GhhX9f3+r/X9/AP1/fwD8gIAA/ICAlPx/f//8f3///H9///x/f//8f3///H9///x/f//8f3///H9///yBgVX8gIDq/H9///x/fwD8f38A/ICAAPyAgAX8gICO/H9///x/f//8f3///H9///x/f//8f3///H9///x/f//8f3///H9///x/f//8f38A/H9/APyAgAD8gIAA/ICAA/x/f//8f3///H9///x/f//8f3///H9///x/f//8f3///H9///x/f//8f3///H9/APx/fwD8gIAA/H9/APx/fwD8f3///H9///x/f//8f3///H9///x/f//8f3///H9///yBgVX8gIDq/H9///x/fwD8f38A/X9/AP1/fwD9f38A/X9/tfx/f//8f3///H9///x/f//8f3///H9///2AgLT8gYEA/4aGFfyAgKr8gIAA/ICAAP1/fwD9f38A/X9/AP1/fwD8f38A/H9/APx/fwD8f38A/H9/APx/fwD9gIAA/YCAAP+GhgD8gIAA/ICAAPyAgAD9f38A/X9/AP1/fwD9f38A/H9/APx/fwD8f38A/H9/APx/fwD8f38A/YCAAP2AgAD/hoYA/ICAAPyAgAD8gIAA/X9/AP1/fwD9f38A/X9/APx/fwD8f38A/H9/APx/fwD8f38A/H9/AP2AgAD9gIAA/4aGAPyAgAD8gIAA/ICAAA=="
var camera3d_icon := ImageTexture.create_from_image(Image.create_from_data(16, 16, false, Image.FORMAT_RGBA8, Marshalls.base64_to_raw(CAMERA3D_ICON)))
const LOGO := "Ha7/AB2u/wAdrv8AHaz/AB2s/wAerf8AHa7/AByx/wEcsf8kHa//UByt/20drf+GHK//oh2u/7kdr//LHa7/1Ryu/+Adrv/uHa7/8R2u//8drv//Ha7//x2u//8drv//Ha7/8x2u/+4drv/uHa7/3R2u/9Qdrv/EHK7/tB6u/6Qdrv+UHa7/hB2u/3Qcrf9kHK3/URyw/zcfrf8ZH63/AR2t/wAdrv8AHK//AB2v/wAerv8AHq7/AB6u/wAasf8AGrH/ABqx/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AB2x/wAdrv8AHa7/AB2s/wAdrP80Hq3/iR2u/8Idrv/xHa7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//kdrf/eHa7/wRyv/6Idr/98Hq7/TB6u/wsasf8AGrH/ABqx/wAasf8A////AP///wD///8A////AP///wD///8A////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdsf8AHa7/CB2u/3Qdrf/bHa7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//x2u//8drv//Ha7//B2u/+wdrv/dHa7/zR2u/78drv+xHq7/ox2t/5Mdr/+CHa7/cR6u/14asf8nGrH/ABqx/wAasf8AGrH/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AHa7/AB2u/wAfrP8AH6z/AB+s/wAerv8AHq7/AB6w/wAesP8AHK3/Ah2u/2Idrv/mHa7//x2u//8drv+2Ia3/HyGt/wAerv8AG67/ABuu/wAbrv8AF67/ABeu/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wAfrP8AH6z/AB+s/wAfrP8AHq7/AB6w/wAesP8AHrD/AB2u/wAdrv8AHa7/Ch6u/3cerv/yHa7//x2u//Uerv93Hq7/Axuu/wAbrv8AF67/ABeu/wAXrv8AF67/AB2w/wAdsP8AHbD/AB2w/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wAerv8AHq7/AB6w/wAesP8AHrD/AB2u/wAdrv8AHa7/AB6u/wAerv8AHbH/Ghyt/5kdrv/8Ha7//x2u/80brv85G67/ABeu/wAXrv8AF67/AB2u/wAdsP8AHbD/AB2w/wAdsP8AHq7/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AB6w/wAesP8AHrD/AB6w/wAdrv8AHa7/AB6u/wAerv8AHbH/AB2x/wAcrf8AHrD/Khyv/6Idrv/7Ha7//hyv/6IXrv8WF67/AB2u/wAdsP8AHbD/AB2w/wAdsP8AHq7/AB6u/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AB2u/wAdrv8AHa7/AB2u/wAerv8AHbH/AB2x/wAdsf8AHrD/AB6w/wAcr/8AHLH/JB2u/50drv/6Ha7/7h2u/2sdrv8DHbD/AB2w/wAdsP8AHq7/AB6u/wAerv8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AB6u/wAerv8AHbH/AB2x/wAdsf8AHrD/AB6w/wAesP8AHLH/AByx/wAdrv8AG63/HB6t/4Adrv/jHa7/0B2w/z0dsP8AHq7/AB6u/wAerv8AHq7/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AHbH/AB2x/wAdsf8AHbH/AB6w/wAesP8AHLH/AByx/wAcsf8AG63/ABut/wAerf8AHa7/Ax2t/04drv+dHq7/ih6u/wwerv8AHq7/AB6u/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A"
var logo := ImageTexture.create_from_image(Image.create_from_data(79, 30, false, Image.FORMAT_RGBA8, Marshalls.base64_to_raw(LOGO)))

##### Variables #####
var cameras: Array[Camera3D] = []

class Flag extends RefCounted:
	var value: bool = false
	var root: Control 
	var checkbox: CheckBox

var flags: Dictionary
var logfile: FileAccess

class Plot extends RefCounted:
	var root: Control
	var min_value: float = INF
	var max_value: float = -INF
	var colors: Array[Color] = []
	var data: Array[PackedFloat32Array] = []
	var next_values: Array[float] = []

@onready var plot_sample_count: int = int(plot_time_range / plot_update_interval)
var plots := {}
var plot_time := 0.0

class ValueSlider extends RefCounted:
	var label: Label
	var slider: HSlider
	var number: Label
	
var value_sliders: Dictionary


func _ready() -> void:
	##### MainButtons #####
	SetVisible(false)
	Logo.texture = logo
	ReturnButton.pressed.connect(_OnReturnButtonPressed)
	ExitGameButton.pressed.connect(_OnExitGameButtonPressed)

	##### Cameras #####
	CameraList.item_selected.connect(_OnCameraListItemSelected)
	LoadCameras()
	
	##### Flags ######
	FlagTemplate.hide()
	SetFlag("pause_game", false)
	SetFlag("show_collision_shapes", false)
	SetFlag("fullscreen", false)
	SetFlag("vsync", true)

	##### Console #####
	ConsoleText.clear()
	ConsoleScrollContainer.get_v_scroll_bar().changed.connect(_OnConsoleScrollChanged)
	ConsoleClearButton.pressed.connect(_OnConsoleClearPressed)
	var logging_enabled = ProjectSettings.get("debug/file_logging/enable_file_logging") or\
			ProjectSettings.get("debug/file_logging/enable_file_logging.pc")
	if logging_enabled:
		var log_path = ProjectSettings.get("debug/file_logging/log_path")
		logfile = FileAccess.open(log_path, FileAccess.READ)
		create_tween().set_loops().tween_callback(UpdateConsole).set_delay(console_update_interval)
	else:
		ConsoleText.text = "To use the UI console, set \"Enable File Logging\" or \"Enable File Logging.pc\" (Desktop) under \"Project/Project Settings/General/Debug/File Logging\""
	
	##### Plots #####
	create_tween().set_loops().tween_callback(AdvancePlots).set_delay(plot_update_interval)
	PlotTemplate.hide()
	
	##### Values #####
	ValueLabelTemplate.hide()
	ValueNumberTemplate.hide()
	ValueSliderTemplate.hide()


##### Core #####
func _input(event: InputEvent) -> void:
	if event.is_match(camera_cycle_event) and event.is_pressed():
		var ind := CameraList.get_selected_items()
		if (ind.size() == 0):
			return
		var new_index = (ind[0]+1) % CameraList.item_count
		CameraList.select(new_index)
		_OnCameraListItemSelected(new_index)
	
	elif event.is_match(toggle_interface_event) and event.is_pressed():
		SetVisible(!MainButtons.visible)
	elif event.is_match(exit_game_event) and event.is_pressed():
		_OnExitGameButtonPressed()

func SetVisible(_visible: bool):
	if _visible:
		LoadCameras()
	MouseBlocker.mouse_filter = Control.MOUSE_FILTER_STOP if _visible else Control.MOUSE_FILTER_IGNORE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if not _visible else Input.MOUSE_MODE_VISIBLE
	MainButtons.visible = _visible
	Cameras.visible = _visible or CamerasAlwaysVisibleCheckBox.button_pressed
	Flags.visible = _visible or FlagsAlwaysVisibleCheckBox.button_pressed
	Console.visible = _visible or ConsoleAlwaysVisibleCheckBox.button_pressed
	Plots.visible = _visible or PlotsAlwaysVisibleCheckBox.button_pressed
	Values.visible = _visible or ValuesAlwaysVisibleCheckBox.button_pressed
	Logo.visible = _visible


##### MainButtons #####
func _OnReturnButtonPressed():
	SetVisible(false)

func _OnExitGameButtonPressed():
	get_tree().quit()


##### Cameras #####
func _OnCameraListItemSelected(index: int):
	var camera := cameras[index]
	camera.make_current()

func LoadCameras():
	# Set up the camera item list.
	CameraList.clear()
	var camera_nodes := get_tree().get_nodes_in_group(camera_group_name)
	for i in range(camera_nodes.size()):
		var camera: Camera3D = camera_nodes[i]
		cameras.append(camera)
		CameraList.add_item(camera.name, camera3d_icon)
		if camera.current:
			CameraList.select(i)


##### Flags #####
func _OnFlagCheckboxToggled(enabled: bool, fname: String):
	flags[fname] = enabled
	FlagChanged.emit(fname, enabled)
	match fname:
		"show_collision_shapes":
			SetCollisionShapesVisible(enabled)
		"pause_game":
			get_tree().paused = enabled
		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED)
		"vsync":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED)
			
func SetFlag(fname: String, enabled: bool):
	GetFlag(fname)
	var flag: Flag = flags[fname]
	flag.value = enabled
	flag.checkbox.button_pressed = enabled

func GetFlag(fname: String) -> bool:
	var flag: Flag
	if fname not in flags:
		flag = Flag.new()
		flag.root = FlagTemplate.duplicate()
		FlagContainer.add_child(flag.root)
		flag.root.show()

		var label: Label = flag.root.get_node("Label")
		label.text = fname
		flag.checkbox = flag.root.get_node("CheckBox")
		flag.checkbox.button_pressed = false
		flag.checkbox.toggled.connect(_OnFlagCheckboxToggled.bind(fname))
		flags[fname] = flag
	
	flag = flags[fname]
	return flag.value

func SetCollisionShapesVisible(enabled: bool):
	var tree: SceneTree = get_tree()
	tree.debug_collisions_hint = enabled
	var node_stack: Array[Node] = [tree.get_root()]
	while not node_stack.is_empty():
		var node: Node = node_stack.pop_back()
		if is_instance_valid(node):
			if   node is CollisionShape2D \
				or node is CollisionPolygon2D \
				or node is CollisionObject2D:
				# queue_redraw on instances of
				node.queue_redraw()
			elif node is TileMap:
				# use visibility mode to force redraw
				node.collision_visibility_mode = TileMap.VISIBILITY_MODE_FORCE_HIDE
				node.collision_visibility_mode = TileMap.VISIBILITY_MODE_DEFAULT
			elif node is RayCast3D \
				or node is CollisionShape3D \
				or node is CollisionPolygon3D \
				or node is CollisionObject3D \
				or node is GPUParticlesCollision3D \
				or node is GPUParticlesCollisionBox3D \
				or node is GPUParticlesCollisionHeightField3D \
				or node is GPUParticlesCollisionSDF3D \
				or node is GPUParticlesCollisionSphere3D:
				var parent: Node = node.get_parent()
				if parent:
					parent.remove_child(node)
					parent.add_child(node)
			node_stack.append_array(node.get_children())


##### Console #####
func _OnConsoleScrollChanged():
	if ConsoleScrollCheckBox.button_pressed:
		ConsoleScrollContainer.scroll_vertical = int(ConsoleScrollContainer.get_v_scroll_bar().max_value)

func _OnConsoleClearPressed():
	ConsoleText.clear()

func UpdateConsole():
	while logfile.get_position() < logfile.get_length():
		var line = logfile.get_line()
		ConsoleText.add_text(line + "\n")


##### Plots #####
func _OnPlotDraw(plot: Plot):
	var rect := plot.root.get_rect()

	var TICK_COLOR := Color.WHITE.darkened(0)
	const TICK_LENGTH: float = 4.0
	const FONT_SIZE: int = 8
	const ALIGNMENT := HORIZONTAL_ALIGNMENT_CENTER

	# Draw the ticks every second.
	for t in range(0, plot_time_range, 1):
		var ux = (t+fmod(plot_time, 1.0)) / plot_time_range
		var edgepoint = Vector2(ux*rect.size.x, rect.size.y)
		plot.root.draw_line(edgepoint-Vector2(0, TICK_LENGTH), edgepoint, TICK_COLOR)

	# Draw y ticks.
	var zero_uy: float = clamp(inverse_lerp(plot.min_value, plot.max_value, 0), 0, 1)
	var zero_point := Vector2(0, rect.size.y*zero_uy)
	plot.root.draw_line(zero_point, zero_point+Vector2(rect.size.x, 0), TICK_COLOR)

	# Draw bounds.
	plot.root.draw_string(ThemeDB.fallback_font, Vector2(1, 8), "%.2f" % plot.max_value, ALIGNMENT, -1, FONT_SIZE, TICK_COLOR)
	plot.root.draw_string(ThemeDB.fallback_font, Vector2(1, rect.size.y-2), "%.2f" % plot.min_value, ALIGNMENT, -1, FONT_SIZE, TICK_COLOR)

	# Draw every line as well as current value string.
	for k in range(len(plot.data)):
		var data := plot.data[k]
		var color := plot.colors[k]
		var points := PackedVector2Array()
		points.resize(plot_sample_count)

		# Current value.
		var next_value := plot.next_values[k]
		var current_uy: float = clamp(inverse_lerp(plot.min_value, plot.max_value, next_value), 0, 1)
		plot.root.draw_string(ThemeDB.fallback_font, Vector2(1, rect.size.y*(1-current_uy)), "%.2f" % next_value, ALIGNMENT, -1, FONT_SIZE, color)

		for i in range(plot_sample_count):
			var sample = data[i]
			var ux = clamp(float(i) / plot_sample_count, 0, 1)
			var uy = clamp(inverse_lerp(plot.min_value, plot.max_value, sample), 0, 1)
			points[i] = Vector2(ux*rect.size.x, (1.0-uy)*rect.size.y)

		plot.root.draw_polyline(points, color)
	
	# Draw time stamps every X seconds.
	for t in range(0, plot_time_range, 10):
		var ux = (t+fmod(plot_time, 10.0)) / plot_time_range
		var edgepoint = Vector2(ux*rect.size.x, rect.size.y)
		var current_time = floor(plot_time/10.0)*10.0-t
		plot.root.draw_string(ThemeDB.fallback_font, edgepoint-Vector2(0,TICK_LENGTH+2), str(int(current_time)), ALIGNMENT, -1, FONT_SIZE)

func AdvancePlots():
	for plot_name in plots:
		var plot: Plot = plots[plot_name]

		for k in range(len(plot.data)):
			var data := plot.data[k]
			var next_value := plot.next_values[k]
			data.remove_at(len(data)-1)
			data.insert(0, next_value)
		plot.root.queue_redraw()
	plot_time += plot_update_interval

func SetPlotSample(plot_name: String, values: Array[float], colors: Array[Color]):
	var plot: Plot
	if plot_name not in plots:
		plot = Plot.new()
		plot.root = PlotTemplate.duplicate()
		plot.root.draw.connect(_OnPlotDraw.bind(plot))
		PlotsContainer.add_child(plot.root)
		plot.root.show()
		
		var title: Label = plot.root.get_node("Control/Title")
		title.text = plot_name
		plot.next_values.resize(len(values))

		plot.data.resize(len(values))
		for i in range(len(values)):
			plot.data[i].resize(plot_sample_count)
		plots[plot_name] = plot
	
	plot = plots[plot_name]
	plot.next_values = values
	plot.colors = colors
	plot.max_value = max(plot.max_value, values.max())
	plot.min_value = min(plot.min_value, values.min())


##### Value sliders #####
func _OnValueSliderChanged(val: float, vs: ValueSlider):
	vs.number.text = "= %.2f" % val 

func SetValue(vname: String, value: float):
	GetValue(vname)
	var vs: ValueSlider = value_sliders[vname]
	vs.slider.value = value
	_OnValueSliderChanged(value, vs)

func SetValueRange(vname: String, lower: float=0.0, upper: float=100.0, step: float=0.1):
	GetValue(vname)
	var vs: ValueSlider = value_sliders[vname]
	vs.slider.min_value = lower
	vs.slider.max_value = upper
	vs.slider.step = step
	_OnValueSliderChanged(vs.slider.value, vs)

func GetValue(vname: String) -> float:
	var vs: ValueSlider
	if vname not in value_sliders:
		vs = ValueSlider.new()
		vs.label = ValueLabelTemplate.duplicate()
		vs.label.text = vname
		vs.number = ValueNumberTemplate.duplicate()
		vs.slider = ValueSliderTemplate.duplicate()
		vs.slider.value = 0
		_OnValueSliderChanged(0, vs)
		ValueContainer.add_child(vs.label)
		ValueContainer.add_child(vs.number)
		ValueContainer.add_child(vs.slider)
		vs.label.show()
		vs.number.show()
		vs.slider.show()
		
		vs.slider.value_changed.connect(_OnValueSliderChanged.bind(vs))
		value_sliders[vname] = vs

	vs = value_sliders[vname]
	return vs.slider.value
