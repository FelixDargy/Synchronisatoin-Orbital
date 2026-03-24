extends Control
class_name Interface

@export var slider_vitesse: HSlider
@export var r_1 : lunes
@export var r_2 : lunes

func _ready() -> void:
	print("slider =", slider_vitesse)

	if slider_vitesse == null:
		push_error("Slider introuvable.")
		return

	slider_vitesse.min_value = 1
	slider_vitesse.max_value = 50
	slider_vitesse.step = 1
	slider_vitesse.value = 10

func afficher_distance(r_1:r_2) -> void:
	var delta_distance : float
	delta_distance = abs(r_1 - r_2)
func afficher_plus_proche(nom_lune: String) -> void:
	if r_1 > r_2:
		print(Europe1)
	else:
		print(Europe2)
	
