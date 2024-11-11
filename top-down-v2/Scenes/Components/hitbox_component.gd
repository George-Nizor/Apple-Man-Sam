class_name Hitboxcomponent extends Area2D

@export var health_component: Healthcomponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
