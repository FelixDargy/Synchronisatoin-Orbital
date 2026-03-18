extends RigidBody3D

@export var centre_rotation : RigidBody3D

# Jupiter
var masse_jupiter: float = 1.989e27  # kg

# Europe
@export_group("Europe")
@export var masse_europe: float = 4.8e22     # kg
@export var periapside: float = 664862e3     # m (converti de km)
@export var vitesse_periapside: float = 14193.0  # m/s (converti de km/s)
@export var periode_orbitale: float = 299819.0        # s

# Élasticité et dissipation
@export_group("Élasticité")
@export var elasticite_Europe: float = 1e14      # N/m
@export var distance_equilibre: float = 249.7e6  # m
@export var coefficient_dissipation: float = 4e16   

@export_group("Paramètres de la méthode d'Euler")
@export var etapes_calcul_par_ecran : int

@export_group("Paramètre de conversion simulation")
@export var min_distance_simulee : float
@export var max_distance_simulee : float
@export var min_distance_reelle : float
@export var max_distance_reelle : float

@export_group("Paramètre de simulation")
@export var periode_relative : float
var G : float = 6.673e-11
var periode : float
var masse: float

var r1: Vector3
var r2: Vector3
var r1_2: Vector3
var r2_1: Vector3

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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	periode= periode_orbitale
	masse= masse_europe/2
	r1= Vector3(periapside-distance_equilibre/2,0,0)
	r2= Vector3(periapside+distance_equilibre/2,0,0)
	r1_2= r2-r1
	r2_1=r1-r2
	
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
	appliquer_euler(delta)
	
	global_position = centre_rotation.global_position + conv_position_reelle_a_simulee(r1)
func conv_position_reelle_a_simulee(position_reelle : Vector3) -> Vector3:
	var distance_reelle = position_reelle.length()
	if distance_reelle == 0:
		return Vector3.ZERO
	var ratio_distance = inverse_lerp(min_distance_reelle, max_distance_reelle, distance_reelle)
	var facteur_distance_simulee = lerp(min_distance_simulee, max_distance_simulee, ratio_distance)
	return position_reelle.normalized() * facteur_distance_simulee
func appliquer_euler(temps_dernier_ecran : float) -> void:
	var nb_periode = temps_dernier_ecran * periode / periode_relative
	var h = nb_periode / etapes_calcul_par_ecran
	for i in range(etapes_calcul_par_ecran):
		var r_1_plus_1 = r1 + h * v1
		var v_1_plus_1 = v1 + h * a1
		var r_2_plus_1 = r2 + h * v2
		var v_2_plus_1 = v2 + h * a2
		
		r1 = r_1_plus_1
		v1 = v_1_plus_1
		r2 = r_2_plus_1
		v2 = v_2_plus_1
		r1_2= r2-r1
		f_g1 = -G*((masse*masse_jupiter)/r1.length()**3)*r1
		f_g2 = -G*((masse*masse_jupiter)/r2.length()**3)*r2
		fres_1= elasticite_Europe*(r1_2.length()-distance_equilibre)*r1_2.normalized()
		fres_2=-fres_1
		ffrot_1= coefficient_dissipation*(v2-v1)
		ffrot_2= -ffrot_1
		a1=(f_g1+fres_1+ffrot_1)/masse
		a2=(f_g2+fres_2+ffrot_2)/masse
