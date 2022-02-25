extends Camera2D


# if player is on floor, move camera smoothly
func _on_player_grounded_updated(is_grounded):
	drag_margin_v_enabled = !is_grounded
