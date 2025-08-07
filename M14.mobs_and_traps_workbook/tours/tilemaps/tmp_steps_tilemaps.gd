extends "res://addons/godot_tours/tour.gd"

const TEXTURE_BUBBLE_BACKGROUND = preload("res://assets/bubble-background.png")
const TEXTURE_GDQUEST_LOGO = preload("res://assets/gdquest-logo.svg")
const CREDITS_FOOTER_GDQUEST = "Tour created by GDQuest."

func _build() -> void:
	# TODO: these steps were extracted from the 101_overview tour. Reuse them in the relevant tile map tours
	bubble_set_title("The tilemap structure")
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	scene_select_nodes_by_path(["Level/Ground", "Level/Mushrooms", "Level/Ivy"])
	highlight_scene_nodes_by_path(["Level/Ground", "Level/Mushrooms", "Level/Ivy"])
	bubble_add_text([
		"I've selected three [b]TileMapLayer[/b] nodes in the [b]Scene Dock[/b].",
		"Each TileMapLayer node represents a different layer in our 2D world:",
		"[ul]The [b]Ground[/b] layer is the main level structure\n" +
		"The [b]Mushrooms[/b] layer contains mushroom platforms\n" +
		"The [b]Ivy[/b] layer has vines drawn above walls[/ul]",
		"Each layer uses the same TileSet resource but displays different tiles."
	])
	complete_step()

	bubble_set_title("Selecting a tilemap layer")
	scene_select_nodes_by_path(["Level/Mushrooms"])
	highlight_scene_nodes_by_path(["Level/Mushrooms"])
	highlight_controls([interface.tilemap])
	bubble_add_text([
		"I just selected the [b]Mushrooms[/b] layer node in the [b]Scene Dock[/b].",
		"When selecting a [b]TileMapLayer[/b], Godot does two things:",
		"[ul]It shows the TileMap editor at the bottom of the screen\n" +
		"It highlights the selected layer in the viewport by making other layers semi-transparent (only if the \"Highlight Selected TileMap Layer\" button is turned on)[/ul]"
	])
	complete_step()

	bubble_set_title("The TileMap editor")
	highlight_controls([interface.tilemap])
	bubble_add_text([
		"The [b]TileMap[/b] editor at the bottom of the screen is where you'll paint tiles onto your map.",
		"This editor has several tabs and tools to help you work with tilemaps.",
		"It lets you select, edit, and paint tiles in your level."
	])
	complete_step()

	bubble_set_title("Exploring the tilemap painting tools")
	queue_command(func select_tiles_item():
		# TODO: Select the tiles item BigMushrooms in the TileMap editor
		# This would require finding the right item in the tilemap_tiles list
		pass
	)
	highlight_controls([interface.tilemap_tiles_toolbar])
	bubble_add_text([
		"The TileMap editor has a toolbar that offers several painting tools:",
		"[ul]%s [b]Paint Tool[/b]: Place individual tiles by clicking\n" % [bbcode_generate_icon_image_by_name("Edit")] +
		"%s [b]Line Tool[/b]: Draw lines of tiles\n" % [bbcode_generate_icon_image_by_name("Line")] +
		"%s [b]Rectangle Tool[/b]: Fill rectangular areas with tiles\n" % [bbcode_generate_icon_image_by_name("Rectangle")] +
		"%s [b]Bucket Tool[/b]: Fill connected areas with tiles\n" % [bbcode_generate_icon_image_by_name("Bucket")] +
		"%s [b]Selection Tool[/b]: Select, copy, and paste groups of tiles[/ul]" % [bbcode_generate_icon_image_by_name("ToolSelect")]
	])
	complete_step()

	bubble_set_title("Navigating between tilemap layers")
	highlight_scene_nodes_by_path(["Level/Ivy"])
	highlight_controls([interface.tilemap_previous_button, interface.tilemap_next_button])
	bubble_add_text([
		"Earlier, I mentioned how the tilemap is organized into layers, each with its own TileMapLayer node.",
		"You can use the [b]Previous Layer[/b] and [b]Next Layer[/b] buttons in the TileMap editor to select the [b]Ivy[/b] layer node in the [b]Scene Dock[/b].",
		"Organizing your map into multiple layers helps create visual depth and keeps your project organized.",
		"Try it out!"
	])
	bubble_add_task_select_nodes_by_path(["Level/Ivy"])
	complete_step()

	bubble_set_title("Introduction to Terrains")
	queue_command(func select_terrains_tab():
		tilemap_tabs_set_by_control(interface.tilemap_terrains_panel)
		# TODO: Select the terrain item Ivy in the TileMap editor
		# This would require finding the right item in the tilemap_terrains_tree
	)
	highlight_controls([interface.tilemap_tabs, interface.tilemap_terrains_tree])
	bubble_add_text([
		"I just switched to the [b]Terrains[/b] tab in the TileMap editor.",
		"[b]Terrains[/b] are a powerful feature that enables auto-connecting tiles.",
		"Instead of placing each tile individually, terrains let you define rules to select the right tile based on neighboring tiles.",
		"For example, the Ivy terrain knows which tile to use for corners, straight sections, and endpoints."
	])
	complete_step()

	bubble_set_title("Painting with Terrains")
	queue_command(func select_connect_mode():
		# Select the Connect Mode tool in the Terrains tab
		interface.tilemap_terrains_toolbar_paint_button.button_pressed = true
	)
	highlight_controls([interface.canvas_item_editor_viewport, interface.tilemap_terrains_toolbar_paint_button])
	bubble_add_text([
		"Try painting the Ivy terrain in the scene by Left Clicking on the tiles in the viewport. See how it connects to the other tiles automatically?",
		"You can delete tiles by Right clicking and dragging over them, and paint new tiles by Left clicking and dragging.",
		"This automatic connection works because the tileset defines which tiles should appear in which situation."
	])
	complete_step()

	bubble_set_title("Viewing options for tilemaps")
	highlight_controls([interface.canvas_item_editor_viewport, interface.tilemap_highlight_button, interface.tilemap_grid_button])
	bubble_add_text([
		"Lastly, the TileMap editor has useful view options. I used them earlier to highlight the selected layer and show the grid:",
		"[ul]The [b]Highlight selected tilemap layer[/b] button makes only the current layer fully visible\n" +
		"The [b]Toggle grid visibility[/b] button hides or shows the tile grid[/ul]",
		"Try toggling these options to see the difference."
	])
	complete_step()
