extends RigidBody3D

#
@export var lune: RigidBody3D

# constante fournie en lien avec Jupiter
const masse_jupiter: float = 1.989e27  # kg

# constante fournie en lien avec Europe
const masse_europe: float = 4.8e22     # kg
const periapside: float = 664862e3     # m (converti de km)
const vitesse_periapside: float = 14193.0  # m/s (converti de km/s)
const periode_orbitale: float = 299819.0        # s

# constante fournie d'Élasticité et de dissipation

const elasticite_Europe: float = 1e14      # N/m
const distance_equilibre: float = 24.97e6  # m
const coefficient_dissipation: float = 4e16   

# exporter une variable pour pouvoir choisir le nombre de calcul par delta
@export_group("Paramètres de la méthode d'Euler")
@export var etapes_calcul_par_ecran : int

#variable ajustable dans l'Inspecteur pour passer des valeurs réelles à celles utilisées pour la simulation
@export_group("Paramètre de conversion simulation")
@export var min_distance_simulee : float
@export var max_distance_simulee : float
@export var min_distance_reelle : float
@export var max_distance_reelle : float

#variable ajustable dans l'Inspecteur pour la période orbitale des lunes
@export_group("Paramètre de simulation")
@export var periode_relative : float

const G : float = 6.673e-11
const masse: float= masse_europe/2

# Initialisation des variables qui vont changer tout au long de la simulation

var r1: Vector3
var r2: Vector3
var r1_2: Vector3
var v1: Vector3
var v2: Vector3
var a1: Vector3
var a2: Vector3

var f_g1: Vector3
var f_g2: Vector3

var fres_1: Vector3 
var fres_2: Vector3

var ffrot_1: Vector3
var ffrot_2: Vector3
# temps pour arrêter la simulation après 20 périodes
var temps_ecoule : float = 0.0
func _ready() -> void:
	"""
	Faire tous les calculs nécessaires pour commencer la simulation
	dans la fonction ready car celle-ci s'éxécute avant le commencement 
	de la simulation pour que les lunes commencent avec la bonne vitesse
	et bien positionnée
	""" 

	
	
	r1= Vector3(periapside-(distance_equilibre/2.0),0,0)
	r2= Vector3(periapside+(distance_equilibre/2.0),0,0)
	r1_2= r2-r1
	
	v1= Vector3(0,0,3.0/4.0*vitesse_periapside)
	v2= Vector3(0,0,5.0/4.0*vitesse_periapside)
	
	f_g1 = -G*((masse*masse_jupiter)/r1.length()**3)*r1
	f_g2 = -G*((masse*masse_jupiter)/r2.length()**3)*r2
	
	fres_1= elasticite_Europe*(r1_2.length()-distance_equilibre)*r1_2.normalized()
	fres_2=-fres_1
	
	ffrot_1= coefficient_dissipation*(v2-v1)
	ffrot_2= -ffrot_1
	
	a1=(f_g1+fres_1+ffrot_1)/masse
	a2=(f_g2+fres_2+ffrot_2)/masse
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	temps_ecoule += delta * (periode_orbitale / periode_relative)
	if temps_ecoule >= 20.0 * periode_orbitale:
		return
	
	appliquer_euler(delta)
	lune.global_position = conv_position_reelle_a_simulee(r1)
	global_position = conv_position_reelle_a_simulee(r2)

func conv_position_reelle_a_simulee(position_reelle : Vector3) -> Vector3:
	var distance_reelle = position_reelle.length()
	if distance_reelle == 0:
		return Vector3.ZERO
	var ratio_distance = inverse_lerp(min_distance_reelle, max_distance_reelle, distance_reelle)
	
	var facteur_distance_simulee = lerp(min_distance_simulee, max_distance_simulee, ratio_distance)
	return position_reelle.normalized() * facteur_distance_simulee
func appliquer_euler(temps_dernier_ecran : float) -> void:
	
	var nb_periode = temps_dernier_ecran * periode_orbitale / periode_relative
	var h = nb_periode / etapes_calcul_par_ecran
	
	for i in range(etapes_calcul_par_ecran):
		r1_2 = r2 - r1
		f_g1 = -G*((masse*masse_jupiter)/r1.length()**3)*r1
		f_g2 = -G*((masse*masse_jupiter)/r2.length()**3)*r2
		fres_1 = elasticite_Europe*(r1_2.length()-distance_equilibre)*r1_2.normalized()
		fres_2 = -fres_1
		ffrot_1 = coefficient_dissipation*(v2-v1)
		ffrot_2 = -ffrot_1
		a1 = (f_g1+fres_1+ffrot_1)/masse
		a2 = (f_g2+fres_2+ffrot_2)/masse

# 2. Euler symplectique
		v1 = v1 + h * a1
		v2 = v2 + h * a2
		r1 = r1 + h * v1
		r2 = r2 + h * v2
