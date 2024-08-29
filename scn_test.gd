extends Node3D

func _ready() -> void:
	FDI.SetValueRange("enemy_agression", 0.0, 10.0, 0.1)
	create_tween().set_loops().tween_callback(DoPrint).set_delay(0.5)

func _process(_delta: float) -> void:
	var vec = get_viewport().get_mouse_position()
	var t = Time.get_ticks_msec()/1000.0
	var agression = FDI.GetValue("enemy_agression")

	FDI.SetPlotSample("randfn", [ randfn(0, 1) ], [ Color.GREEN ])
	FDI.SetPlotSample("cos&sin", [cos(t), sin(t)], [ Color.RED, Color.BLUE ])
	FDI.SetPlotSample("mouse xy", [vec.x, vec.y], [ Color.ORANGE, Color.AZURE ])
	FDI.SetPlotSample("enemy_agression", [ agression ], [ Color.BLUE ])

func DoPrint():
	print("agression: %.2f" % FDI.GetValue("enemy_agression"))
