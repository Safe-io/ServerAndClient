extends Area2D

const whiten_duration = 0.1
export(ShaderMaterial) var whiten_material

func _on_Area2D_area_entered(area):
	whiten_material.set_shader_param("whiten", true)
	yield(get_tree().create_timer(whiten_duration), "timeout")
	whiten_material.set_shader_param("whiten", false)
