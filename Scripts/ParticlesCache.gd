extends CanvasLayer

var materials = [
	preload("res://Particles/Drop.tres")
]

func _ready():
    for material in materials:
        var particles_instance = Particles2D.new()
        particles_instance.set_process_material(material)
        particles_instance.set_one_shot(true)
        particles_instance.set_emitting(true)
        self.add_child(particles_instance)
