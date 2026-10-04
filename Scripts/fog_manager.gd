extends Node3D
class_name FogManager

@onready var fog_color_rect: ColorRect = $"../CanvasLayer/ColorRect"

@export_category("Fog Density")
@export_range(0.0, 1.0) var fog_density_enabled: float = 0.7
@export_range(0.0, 1.0) var fog_density_disabled: float = 0.0

@export_category("Transition")
@export var fog_transition_duration: float = 1.0

@export_category("Fog")
@export var fog_color: Color = Color(0.5, 0.6, 0.7, 1.0)
@export_range(0.0, 1.0) var noise_strength: float = 0.2
@export_range(0.0, 5.0) var noise_speed: float = 0.2

var fog_material: ShaderMaterial
var fog_tween: Tween


func _ready() -> void:
	fog_material = fog_color_rect.material as ShaderMaterial

	set_fog_density(fog_density_disabled)
	set_fog_color(fog_color)
	set_noise_strength(noise_strength)
	set_noise_speed(noise_speed)


func set_fog_density(value: float) -> void:
	fog_material.set_shader_parameter("fog_density", value)


func set_fog_color(color: Color) -> void:
	fog_material.set_shader_parameter("fog_color", color)


func set_noise_strength(value: float) -> void:
	fog_material.set_shader_parameter("noise_strength", value)


func set_noise_speed(value: float) -> void:
	fog_material.set_shader_parameter("noise_speed", value)


func set_fog_enabled(enabled: bool) -> void:
	if fog_tween:
		fog_tween.kill()

	var target_density := fog_density_enabled if enabled else fog_density_disabled
	var current_density: float = fog_material.get_shader_parameter("fog_density")

	fog_tween = create_tween()

	fog_tween.tween_method(
		set_fog_density,
		current_density,
		target_density,
		fog_transition_duration
	)
