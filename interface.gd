extends Control

class_name Interface

@export_group("Connection avec les autres noeuds et script") 
@export var slider_vitesse: HSlider
@export var lune : lunes
@export var label_proche : Label
@export var label_distance : Label

var slider : float
func _ready() -> void:
	slider_vitesse.value = 3
	slider_vitesse.value_changed.connect(changement)

func _process(_delta: float) -> void:
	label_distance.text = format_scientifique(lune.position_entre_lunes().length()) + " m"
	label_proche.text = lune.lune_plus_proche()
	
	
	
"""2 fonction qui s'utilisent ensemble pour pouvoir transmettre la valeur du slider dans un autre script en l'appelant"""
func changement(value:float):
	lune.vitesse_simulation = slider_vitesse.value
func slide_value() -> float:
	
	slider = slider_vitesse.value
	return slider

func format_scientifique(valeur: float) -> String:
	"""fonction qui prend un nombre et le renvoie en notation scientifique"""
	if valeur == 0.0:
		return "0.000e0"
	var signe = "-" if valeur < 0 else ""
	valeur = abs(valeur)
	var exposant = int(floor(log(valeur) / log(10)))
	var mantisse = valeur / pow(10, exposant)
	return signe + "%.3f" % mantisse + "e" + "%d" % exposant
