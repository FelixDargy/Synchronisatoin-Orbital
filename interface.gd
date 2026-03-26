extends Control
class_name Interface

@export var slider_vitesse: HSlider
@export var lune : lunes

func _ready() -> void:
	print("slider =", slider_vitesse)

	if slider_vitesse == null:
		push_error("Slider introuvable.")
		return

	slider_vitesse.min_value = 1
	slider_vitesse.max_value = 50
	slider_vitesse.step = 1
	slider_vitesse.value = 10

func afficher_distance(distance: String) -> void:
	distance = distance
	
func afficher_plus_proche(nom_lune: String) -> void:
	le_plus_proche = nom_lune
	
