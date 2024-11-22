class_name Score_Manager extends Node


func _update_score(score: int):
    GlobalStuff.SCORE = score

func add_score(score: int):
    GlobalStuff.SCORE += score

func subtract_score(score: int):
    GlobalStuff.SCORE -= score

func on_entity_death(entity: CharacterBody2D):
    if entity.has_method('Enemy'):
        add_score(1)
        if entity.has_method('Enemy2'):
            add_score(2) 
        if entity.has_method('Enemy3'):
            add_score(5)
