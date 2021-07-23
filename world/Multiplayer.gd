extends CenterContainer

var main = Scene.main

func _init():
	add_child(Scene.transition_node.instance())
	var anim = get_node("TransitionScene").get_node("AnimationPlayer")
	anim.play("backwards")
	yield(anim, "animation_finished")
	get_node("TransitionScene").queue_free()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		get_parent().add_child(main.instance())
		queue_free()
