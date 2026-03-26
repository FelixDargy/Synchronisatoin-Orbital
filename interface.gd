extends Control

class_name Interface

@export var slider_vitesse: HSlider
@export var lune : lunes
var slider : float
func _ready() -> void:
	slider_vitesse.value = 10
	slider_vitesse.value_changed.connect(changement)

func _process(_delta: float) -> void:
	pass

func changement(value:float):
	lune.vitesse_simulation = slider_vitesse.value
	#print(slider_vitesse.value)
func slide_value() -> float:
	
	slider = slider_vitesse.value
	return slider
