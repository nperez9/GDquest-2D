@tool
extends "res://addons/godot_tours/gdtour_metadata.gd"


func _define() -> void:
	auto_open_tour_list = true

	title = tr("Welcome to GDTours")
	subtitle = tr("Tile by Tile: Setting up a Pixel Art Tileset")
	description.push_back("[center]" + tr("In this series of guided workshops, you learn to set up tilesets in Godot: you create tile sources, add collision shapes, and configure one-way platforms.") + "[/center]")

	register_tour(
		"101_overview_of_tileset_and_tilemap_editors",
		"101",
		tr("Intro to tilesets and tilemaps in Godot"),
		13,
		"res://tours/101_overview/101_overview.gd",
	)

	register_tour(
		"102_your_first_tileset",
		"102",
		tr("Your first tileset"),
		21,
		"res://tours/102_your_first_tileset/102_your_first_tileset.gd",
	)

	register_tour(
		"103_adding_collision_shapes",
		"103",
		tr("Adding collision shapes"),
		17,
		"res://tours/103_adding_collision_shapes/103_adding_collision_shapes.gd",
	)

	register_tour(
		"104_one_way_collisions",
		"104",
		tr("One way collisions"),
		7,
		"res://tours/104_one_way_collisions/104_one_way_collisions.gd",
	)
