extends Control

class_name Interface

@export var slider_vitesse: HSlider
@export var lune : lunes

func _ready() -> void:
	slider_vitesse.value = 10

func _process(_delta: float) -> void:
	pass
func slider_value(slider_vitesse: float) -> float:
	print("slider =", slider_vitesse)
	if slider_vitesse == null:
		push_error("Slider introuvable.")
		
	
	return slider_vitesse
	
