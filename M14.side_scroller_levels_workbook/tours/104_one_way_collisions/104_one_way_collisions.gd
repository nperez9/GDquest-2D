@tool
extends "res://tours/tileset_tours_base.gd"

const UID_TEXTURE_MUSHROOM = "uid://cdq1w4b0c0y4g"
const TEXTURE_MUSHROOM = preload(UID_TEXTURE_MUSHROOM)

const TILE_ATLAS_COORDS_MUSHROOM_CAPS: Array[Vector2i] = [
	# Blue mushroom cap
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0),
	# Orange mushroom cap
	Vector2i(4, 0),
	Vector2i(5, 0),
	Vector2i(6, 0),
	Vector2i(7, 0),
]

const TILE_ATLAS_COORDS_MUSHROOM_STEMS: Array[Vector2i] = [
	# Blue mushroom stem
	Vector2i(1, 1),
	Vector2i(2, 1),
	Vector2i(1, 2),
	Vector2i(2, 2),
	Vector2i(1, 3),
	Vector2i(2, 3),
	# Orange mushroom stem
	Vector2i(5, 1),
	Vector2i(6, 1),
	Vector2i(5, 2),
	Vector2i(6, 2),
	Vector2i(5, 3),
	Vector2i(6, 3),
]

const TILE_ATLAS_COORDS_MUSHROOM_ALL: Array[Vector2i] = TILE_ATLAS_COORDS_MUSHROOM_CAPS + TILE_ATLAS_COORDS_MUSHROOM_STEMS

enum MushroomCaps {
	BLUE,
	ORANGE,
}


func _build() -> void:
	set_command_context(CommandContext.WELCOME_BOOKEND)
	steps_welcome()
	set_command_context(CommandContext.TOUR_STEP)
	part_010_start()
	set_command_context(CommandContext.FINALE_BOOKEND)
	steps_finale()


func steps_welcome() -> void:
	bubble_set_bookend_title(atr("One-way collisions"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("If you haven't completed the previous tours in this series, quit to return to the menu and complete them in order to get the expected results.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you add a new tile source with one-way platforms to your tileset.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("You add mushroom platform tiles, set up their collision shapes, and enable one-way collision so the character can jump through them from below.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var layout_root: Control = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_ROOT)
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var run_bar_play_current_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON)

	var tileset_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_DOCK)
	var tilemap_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_DOCK)

	add_step_open_start_scene_conditionally()

	bubble_move_and_anchor(layout_root, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(atr("Adding more tile sources"))
	bubble_add_text(
		[
			atr("In the previous tours, you learned how to add a tile source and set up a physics layer with collision shapes on your tiles. You added collision shapes to every tile."),
			atr("You can add multiple tile sources to a tileset and add collision shapes and change their properties more selectively."),
			atr("Let's build upon what you learned and go one step further."),
		],
	)
	complete_step()

	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(atr("Challenge: add a mushroom tile source"))
	bubble_add_text(
		[
			atr("Your mission, if you accept it, is to add and configure a new tile source to your tile set: mushroom platforms with a cap that the player can jump through."),
			atr("This time, I will not guide you every step of the way. Instead, you will have to use what you learned in the previous tours to achieve this goal."),
			atr("To begin the challenge, let's make sure you have the [b]Ground[/b] node selected in the scene tree and open the [b]TileSet editor[/b]."),
		],
	)
	highlight_scene_nodes_by_path(["CreatingTilesets/Ground"])
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	highlight_dock_tab(tileset_dock)
	bubble_add_task_select_nodes_by_path(["CreatingTilesets/Ground"])
	bubble_add_task(
		atr("Open the TileSet editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tileset_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_move_and_anchor(layout_root, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(atr("Adding the mushroom tile source"))
	bubble_add_text(
		[
			atr("Your first task is to add the mushroom tile source to your tileset resource and create tiles for every part of the mushrooms."),
			atr("The editor can create tiles for you automatically by selecting [b]Yes[/b] in the dialog that appears when you add a tile source."),
		],
	)
	highlight_filesystem_paths(["res://assets/tilesets/dark_forest/mushrooms.png"])
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	bubble_add_task(
		atr("Add the [b]mushroom.png[/b] tile source to the tileset"),
		1,
		func(_task: Task) -> int:
			var ground := get_ground_node()
			if ground == null:
				return 0
			for index in ground.tile_set.get_source_count():
				var source_id := ground.tile_set.get_source_id(index)
				var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
				if source == null:
					continue
				if source.texture == TEXTURE_MUSHROOM:
					return 1
			return 0
	)
	bubble_add_task(
		atr("Create tiles for every part of the mushroom"),
		1,
		func(_task: Task) -> int:
			var ground := get_ground_node()
			if ground == null:
				return 0

			for index in ground.tile_set.get_source_count():
				var source_id := ground.tile_set.get_source_id(index)
				var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
				if source == null:
					continue
				if source.texture != TEXTURE_MUSHROOM:
					continue
				for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_ALL:
					if source.get_tile_at_coords(atlas_coords) == Vector2i(-1, -1):
						return 0
				return 1
			return 0
	)
	complete_step()

	bubble_move_and_anchor(layout_root, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(atr("Adding a collision shape to the mushroom cap tiles"))
	bubble_add_text(
		[
			atr("Great job! Now that you have added the mushroom tile source, it's time to add a collision shape to the mushroom cap tiles. The cap tiles are the top row of the mushroom tile source."),
			atr("Be sure to [b]only add the collision shape to the mushroom cap tiles[/b], not the stem!"),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	bubble_add_task(
		atr("Turn on the Select tool in the Tileset editor"),
		1,
		func(_task: Task) -> int:
			var select_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_BUTTON)
			return 1 if select_button.button_pressed else 0
	)
	bubble_add_task(
		atr("Add collision shapes to the mushroom cap tiles"),
		1,
		func(_task: Task) -> int:
			var ground := get_ground_node()
			if ground == null:
				return 0
			for index in ground.tile_set.get_source_count():
				var source_id := ground.tile_set.get_source_id(index)
				var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
				if source == null:
					continue
				if source.texture != TEXTURE_MUSHROOM:
					continue
				for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_CAPS:
					var tile_data := source.get_tile_data(atlas_coords, 0)
					if tile_data.get_collision_polygons_count(0) == 0:
						return 0
				for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_STEMS:
					var tile_data := source.get_tile_data(atlas_coords, 0)
					if tile_data.get_collision_polygons_count(0) > 0:
						return 0
				return 1
			return 0
	)
	complete_step()

	bubble_move_and_anchor(layout_root, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(atr("Setting up one-way collisions"))
	bubble_add_text(
		[
			atr("You now have a collision shape on the mushroom cap tiles, but by default it's solid and the player cannot jump through it from below."),
			atr("To set up one-way collisions, expand the [b]Polygon 0[/b] and turn on the one-way collision property. This will turn selected tiles into one-way platforms."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	bubble_add_task(
		atr("Set up one-way collisions on the mushroom cap tiles"),
		8,
		func(_task: Task) -> int:
			var ground := get_ground_node()
			if ground == null:
				return 0
			var completed_tiles := 0
			for index in ground.tile_set.get_source_count():
				var source_id := ground.tile_set.get_source_id(index)
				var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
				if source == null:
					continue
				if source.texture != TEXTURE_MUSHROOM:
					continue
				for atlas_coords in TILE_ATLAS_COORDS_MUSHROOM_CAPS:
					var tile_data := source.get_tile_data(atlas_coords, 0)
					if tile_data.is_collision_polygon_one_way(0, 0):
						completed_tiles += 1
			return completed_tiles
	)
	complete_step()

	bubble_move_and_anchor(layout_root, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(atr("Try it out!"))
	bubble_add_text(
		[
			atr("Try painting a mushroom cap tile above a platform in the viewport! Open the [b]TileMap editor[/b] and select the mushroom cap tile."),
			atr("In the TileMap editor, select the [b]Paint tool[/b] and click and drag over the mushroom tiles to select them all."),
			atr("Then, [b]Left-Click[/b] in the viewport to stamp the entire mushroom at once."),
			atr("Right-click in the viewport to erase tiles if you make a mistake."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.TILE_MAP_DOCK])
	highlight_dock_tab(tilemap_dock)
	bubble_add_task(
		atr("Open the TileMap editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tilemap_dock.is_visible_in_tree() else 0
	)

	bubble_add_task(
		atr("Paint a mushroom in the level"),
		1,
		func(_task: Task) -> int:
			var ground := get_ground_node()
			if ground == null:
				return 0

			for cap in [MushroomCaps.BLUE, MushroomCaps.ORANGE]:
				if is_mushroom_cap_complete(ground, cap):
					return 1
			return 0
	)
	complete_step()

	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(atr("Run the scene"))
	bubble_add_text(
		[
			atr("Give the scene a try! Press the [b]Play Current Scene[/b] button in the top right corner of the editor."),
			atr("You should be able to jump through the mushroom cap tiles from below and stand on them. If you misplaced the mushroom cap tiles and platforms, go back to the previous step and try again."),
			atr("Controls:"),
			"[ul]" +
			atr("Arrow Keys to move left and right") + "\n" +
			atr("C to jump") +
			"[/ul]",
		],
	)
	highlight_editor_nodes([EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON])
	bubble_add_task_press_button(run_bar_play_current_button, atr("Play Current Scene"))
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Amazing!"))
	bubble_add_bookend_text([
		"[center]" + atr("You can now add one-way collision platforms to a tileset that the player can jump through from below.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("Head back to GDSchool to continue with this module's lessons whenever you're ready.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))


# Helpers.

func get_ground_node() -> TileMapLayer:
	var scene_root := EditorInterface.get_edited_scene_root()
	return scene_root.find_child("Ground") as TileMapLayer


func get_mushroom_source_id() -> int:
	var ground := get_ground_node()
	if ground == null:
		return -1
	for index in ground.tile_set.get_source_count():
		var source_id := ground.tile_set.get_source_id(index)
		var source := ground.tile_set.get_source(source_id) as TileSetAtlasSource
		if source != null and source.texture == TEXTURE_MUSHROOM:
			return source_id
	return -1


func is_mushroom_cap_complete(ground: TileMapLayer, cap_type: MushroomCaps) -> bool:
	var start_x := 0 if cap_type == MushroomCaps.BLUE else 4
	var start_coords := Vector2i(start_x, 0)

	# NOTE: Errors here are also translated, because they provide user-facing information.

	var mushroom_source_id := get_mushroom_source_id()
	if mushroom_source_id == -1:
		printerr(atr("Mushroom tile source not found. Cannot check that the mushroom cap was drawn."))
		return false

	var cap_leftmost_cells := ground.get_used_cells_by_id(mushroom_source_id, start_coords)
	for current_cell in cap_leftmost_cells:
		var matched_cells := 0
		# Check if all 4 tiles of mushroom cap are present in sequence
		for i in range(4):
			var cell_to_check := current_cell + Vector2i(i, 0)
			print(atr("Checking cell: %s") % [cell_to_check])
			var tile_data := ground.get_cell_tile_data(cell_to_check)
			print(atr("Tile data for cell %s: %s") % [cell_to_check, tile_data])
			if tile_data == null:
				print(atr("No tile data found at %s") % [cell_to_check])
				continue

			var atlas_coords := ground.get_cell_atlas_coords(cell_to_check)
			print(atr("Atlas coords for cell %s: %s") % [cell_to_check, atlas_coords])
			if atlas_coords != Vector2i(start_x + i, 0):
				print(atr("Atlas coords don't match expected %s") % [Vector2i(start_x + i, 0)])
				continue

			matched_cells += 1

		if matched_cells == 4:
			print(atr("Mushroom cap complete at cell %s") % [current_cell])
			return true

	return false
