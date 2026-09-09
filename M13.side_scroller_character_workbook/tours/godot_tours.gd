@tool
extends "res://addons/godot_tours/gdtour_metadata.gd"


func _define() -> void:
	auto_open_tour_list = true

	title = tr("Welcome to GDTours")
	subtitle = tr("Frame by Frame: Flipbook Animation")
	description.push_back("[center]" + tr("In this series of guided tours, you learn to set up flipbook-style animations for a 2D side-scroller character using the AnimatedSprite2D node and SpriteFrames editor.") + "[/center]")

	register_tour(
		"101_overview_animated_sprite_editor",
		"101",
		tr("Overview of the animated sprite editor"),
		9,
		"res://tours/101_animated_sprites_overview/101_animated_sprites_overview.gd",
	)
	register_tour(
		"102_creating_animation",
		"102",
		tr("Creating an animation"),
		12,
		"res://tours/102_creating_animation/102_creating_animation.gd",
	)
	register_tour(
		"103_manipulating_animation_frames",
		"103",
		tr("Manipulating animation frames"),
		15,
		"res://tours/103_manipulating_frames/103_manipulating_frames.gd",
	)
