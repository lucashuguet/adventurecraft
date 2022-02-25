extends Node

var main = preload("res://world/Main.tscn")
var singleplayer = preload("res://world/world.tscn")
var multiplayer_s = preload("res://world/Multiplayer.tscn")
var transition_node = preload("res://gui/TransitionScene.tscn")


# change scene with a transition
func change_scene(next_scene):
	var root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	root_scene.add_child(transition_node.instance())
	
	var trans = root_scene.get_node("TransitionScene")
	trans.get_node("AnimationPlayer").play("forwards")
	yield(trans.get_node("AnimationPlayer"), "animation_finished")
	
	root_scene.queue_free()
	get_tree().get_root().add_child(next_scene.instance())
