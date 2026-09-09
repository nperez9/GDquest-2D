@tool
extends "res://tours/tileset_tours_base.gd"

const SCREENSHOT_TERRAIN_CORNERS = preload("uid://cgww4chvrhdn3")
const SCREENSHOT_PLATFORM = preload("uid://bw11g7hg1pkhn")

const PATH_TILE_SOURCE = "res://assets/tilesets/ground_tileset.png"
var FILENAME_TILE_SOURCE = PATH_TILE_SOURCE.get_file()


func _build() -> void:
	set_command_context(CommandContext.WELCOME_BOOKEND)
	steps_welcome()
	set_command_context(CommandContext.TOUR_STEP)
	part_010_start()
	set_command_context(CommandContext.FINALE_BOOKEND)
	steps_finale()


func steps_welcome() -> void:
	bubble_set_bookend_title(atr("Your first tileset"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("If you haven't completed the previous tour in this series, quit to return to the menu and complete it first to get the expected results.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you create a tileset in Godot from scratch.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("You add a tile source, create tiles, and paint a simple platform in the level.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var layout_root: Control = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_ROOT)
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var canvas_item_editor_toolbar_select_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR_MAIN_TOOLBAR_SELECT_BUTTON)
	var filesystem_tree: Tree = EditorInterfaceAccess.get_node(EditorNodePoints.FILE_SYSTEM_TREE)

	var tileset_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_DOCK)
	var tileset_tiles_sources_list: Control = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_TILES_SOURCES_LIST)
	var tilemap_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_DOCK)
	var tilemap_tiles_paint_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_TILES_TOOLBAR_PAINT_BUTTON)

	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(atr("TileMapLayer and TileSet"))
	bubble_add_text(
		[
			atr("To draw tilemap-based levels, you need two components:"),
			"[ul]" +
			atr("A [b]TileSet[/b]. It's a resource that you assign to a [b]TileMapLayer[/b] node. It defines your available tiles and their properties.") + "\n" +
			atr("A [b]TileMapLayer[/b] node. This node creates a grid where you can draw tiles to create a level.") +
			"[/ul]",
			atr("Think of the [b]TileSet[/b] as a palette of stamps to paint with, and the [b]TileMapLayer[/b] node as your canvas."),
		],
	)
	complete_step()

	bubble_set_title(atr("Opening the starting scene"))
	bubble_add_text(
		[
			atr("Let's get ready to create the tileset. First, open the starting scene I've prepared: [b]creating_tilesets.tscn[/b]."),
			atr("This scene contains a playable character that can move and jump. We'll use this character to test our tileset once it's created."),
		],
	)
	bubble_add_task_open_scene("res://creating_tilesets.tscn")
	highlight_filesystem_paths(["res://creating_tilesets.tscn"])
	complete_step()

	bubble_set_title(atr("Creating the TileMapLayer node"))
	bubble_add_text(
		[
			atr("Let's create a [b]TileMapLayer[/b] node first. It allows us to easily create and test the [b]TileSet[/b] resource."),
		],
	)
	bubble_add_task(
		atr("Create a [b]TileMapLayer[/b] node as a child of the scene root node."),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0
			for child in scene_root.get_children():
				if child is TileMapLayer:
					return 1
			return 0
	)
	bubble_add_task(
		atr("Rename the new [b]TileMapLayer[/b] node to [b]Ground[/b]."),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0
			for child in scene_root.get_children():
				if child is TileMapLayer and child.name == "Ground":
					return 1
			return 0
	)
	highlight_editor_nodes([EditorNodePoints.SCENE_TREE_LOCAL_TREE, EditorNodePoints.SCENE_TREE_ADD_NODE_BUTTON])
	complete_step()

	bubble_set_title(atr("Creating a TileSet resource"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("You now have a [b]TileMapLayer[/b] node in your scene. The next step is to create a [b]TileSet[/b] resource that defines the tiles we can use in this layer."),
			atr("In the [b]Inspector[/b] dock, click the field next to the [b]Tile Set[/b] property and select [b]New TileSet[/b]."),
			atr("This creates an empty [b]TileSet[/b] resource that we'll configure in the next steps."),
		],
	)
	bubble_add_task(
		atr("Assign a [b]TileSet[/b] resource to the [b]Tile Set[/b] property."),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			var nodes := scene_root.find_children("*", "TileMapLayer")
			if nodes.is_empty():
				return 0
			var tile_map_layer := nodes.front() as TileMapLayer
			return 1 if tile_map_layer.tile_set != null else 0
	)
	scene_select_nodes_by_path(["CreatingTilesets/Ground"])
	highlight_inspector_properties(["tile_set"])
	complete_step()

	bubble_set_title(atr("Setting the tile size"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("The engine needs to know the size of individual tiles in the tileset to draw them correctly."),
			atr("The [b]TileSet[/b] resource's [b]Tile Size[/b] property controls the size of each tile in pixels. Its value should match the size of your tile art assets."),
			atr("Our artist drew tiles that are 16x16 pixels. Luckily for us, that's the default value when you create a [b]TileSet[/b] resource! We can use the default value."),
		],
	)
	expand_inspector_resource("tile_set")
	highlight_inspector_properties(["tile_size"])
	complete_step()

	bubble_set_title(atr("Opening the TileSet editor"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("When selecting a [b]TileMapLayer[/b] node, the editor reveals the [b]TileMap editor[/b]. This bottom panel allows you to draw tiles in the level."),
			atr("We don't have any tiles yet, so we cannot draw anything! Open the [b]TileSet editor[/b] so we can start adding tiles to the TileSet."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK, EditorNodePoints.TILE_MAP_DOCK])
	bubble_add_task(
		atr("Open the TileSet editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tileset_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_set_title(atr("The TileSet editor"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("The [b]TileSet editor[/b] is where we define our tiles and their properties."),
			atr("The [b]Tile Sources[/b] tab on the left lists textures containing multiple tiles that you add to the tileset."),
			atr("The empty area on the right allows you to select and change the properties of individual tiles in a tile source."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	complete_step()

	bubble_set_title(atr("Tile sources"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("We call the texture containing tiles a [b]Tile Source[/b]. It's a single image containing multiple tiles arranged in a grid."),
			atr("To define what tiles are available in the tileset, you add a tile source, and then you define which parts of the images should be usable as tiles."),
			atr("Our artist prepared tile sources for you to use in this module. We'll use this one to create our first tileset:"),
		],
	)
	bubble_add_texture(SCREENSHOT_TERRAIN_CORNERS, 480)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	complete_step()

	bubble_set_title(atr("Understanding tile creation options"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("There are two ways to create tiles from a source:"),
			"[ul]" +
			atr("[b]Automatically:[/b] Godot creates tiles for all non-transparent regions in the source for you. When you select [b]Yes[/b] in the popup, Godot uses this method.") + "\n" +
			atr("[b]Manually:[/b] You select and create individual tiles yourself.") +
			"[/ul]",
			atr("For now we will do this manually (note: A popup will appear in the next step to give you this choice. Remember to select \"No\")."),
		],
	)
	complete_step()

	bubble_set_title(atr("Adding the tile source"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's add our first tile source. In the [b]FileSystem[/b] dock, locate the image [b]%s[/b]. This image contains all the ground tiles we'll use in our level.") % [FILENAME_TILE_SOURCE],
			atr("Drag and drop it onto the tile source area in the TileSet editor."),
			atr("[b]Important:[/b] Remember to select [b]No[/b] in the popup that'll appear so we can create tiles manually."),
		],
	)
	highlight_filesystem_paths([PATH_TILE_SOURCE])
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_SOURCES_LIST])
	bubble_add_task(
		atr("Add the [b]%s[/b] file to the [b]TileSet[/b] resource.") % [FILENAME_TILE_SOURCE],
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			for child in scene_root.get_children():
				if child is TileMapLayer and child.tile_set != null:
					if child.tile_set.get_source_count() > 0:
						return 1
			return 0
	)
	mouse_click_drag_by_callable(
		func() -> Vector2: return get_tree_item_center_by_path(filesystem_tree, PATH_TILE_SOURCE),
		func() -> Vector2: return get_control_global_center(tileset_tiles_sources_list)
	)
	complete_step()

	bubble_set_title(atr("Naming the source"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's give our source a descriptive name to keep things organized. By default, the name is set to the file name, but we can change it to something simpler."),
			atr("In the middle column of the TileSet editor, set the [b]Name[/b] property to [b]Ground[/b]."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SETUP_PANEL])
	bubble_add_task(
		atr("Rename the tile source to [b]Ground[/b]."),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			for child in scene_root.get_children():
				if child is TileMapLayer and child.tile_set != null:
					if child.tile_set.get_source_count() > 0:
						var source_id = child.tile_set.get_source_id(0)
						var atlas = child.tile_set.get_source(source_id)
						if atlas.resource_name == "Ground":
							return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Creating your first tile manually"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Now that we have our source, let's create our first tile manually:"),
			"[ul]" +
			atr("Make sure the %s [b]Setup[/b] tool is active in the TileSet editor toolbar") % [bbcode_generate_icon_image_by_name("Tools")] + "\n" +
			atr("Click on a tile in the source image on the right (choose one of the ground tiles with grass on top)") +
			"[/ul]",
			atr("You'll see a highlighted border around the selected tile, which means it's now available to draw."),
		],
	)
	highlight_editor_nodes([
		EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SETUP_BUTTON,
		EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_ATLAS_VIEW
	])
	bubble_add_task(
		atr("Create at least one tile by clicking on a tile in the tile source."),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			for child in scene_root.get_children():
				if child is TileMapLayer and child.tile_set != null:
					if child.tile_set.get_source_count() > 0:
						var source_id: int = child.tile_set.get_source_id(0)
						var atlas: TileSetAtlasSource = child.tile_set.get_source(source_id)
						if atlas.get_tiles_count() > 0:
							return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Opening the TileMap editor"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("That's it! You've created your first tile."),
			atr("Let's switch to the [b]TileMap[/b] editor to start drawing with our tile."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_MAP_DOCK])
	highlight_dock_tab(tilemap_dock)
	bubble_add_task(
		atr("Open the TileMap editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tilemap_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_set_title(atr("Drawing your first tile"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's draw with our manually created tile. For that, you need to select the %s [b]Paint Tool[/b] in the TileMap editor toolbar:") % [bbcode_generate_icon_image_by_name("Edit")],
			atr("1. Make sure the %s [b]Paint Tool[/b] is selected") % [bbcode_generate_icon_image_by_name("Edit")],
			atr("2. Look at the tile palette on the right side of the editor. You should see your tile there"),
			atr("3. Click on this tile in the palette to select it"),
		],
	)
	highlight_editor_nodes([
		EditorNodePoints.TILE_MAP_TILES_TOOLBAR_PAINT_BUTTON,
		EditorNodePoints.TILE_MAP_TILES_ATLAS_VIEW,
	])
	context_set_2d()
	bubble_add_task_toggle_button(tilemap_tiles_paint_button, true, "Select the [b]Paint Tool[/b]")
	complete_step()

	bubble_set_title(atr("Placing the tile"))
	bubble_move_and_anchor(layout_root, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("With the %s paint tool and tile selected, you can now place it on the grid.") % [bbcode_generate_icon_image_by_name("Edit")],
			atr("Click in the 2D viewport to draw the tile. Place a tile right below the player character, so they can stand on it."),
			atr("If you're having trouble drawing:"),
			"[ul]" +
			atr("Make sure the %s [b]Select Mode[/b] is active in the viewport toolbar as other modes won't let you draw") % [bbcode_generate_icon_image_by_name("ToolSelect")] + "\n" +
			atr("Check that your tile is selected in the palette (it should have a highlighted border)") +
			"[/ul]",
		],
	)
	highlight_editor_nodes([
		EditorNodePoints.CANVAS_ITEM_EDITOR_MAIN_TOOLBAR_SELECT_BUTTON,
		EditorNodePoints.CANVAS_ITEM_EDITOR_VIEWPORT,
		EditorNodePoints.TILE_MAP_TILES_ATLAS_VIEW
	])
	bubble_add_task_toggle_button(canvas_item_editor_toolbar_select_button, true, atr("Select Mode"))
	bubble_add_task(
		atr("Place a ground tile below the player character."),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			var player = scene_root.find_child("Player")
			if player == null:
				return 0

			for child in scene_root.get_children():
				if child is not TileMapLayer:
					continue

				var used_cells: Array[Vector2i] = child.get_used_cells()
				for cell: Vector2i in used_cells:
					var tile_position_local: Vector2 = child.map_to_local(cell)
					var tile_position_global = child.to_global(tile_position_local)

					# Check if tile is below player (higher Y position) and roughly aligned horizontally
					if tile_position_global.y > player.global_position.y and abs(tile_position_global.x - player.global_position.x) < 16:
						return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Populating tiles automatically"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Instead of enabling tiles in a tile source manually, we can populate them all automatically."),
			atr("Let's return to the [b]TileSet editor[/b] and do that next."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	highlight_dock_tab(tileset_dock)
	bubble_add_task(
		atr("Open the TileSet editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tileset_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_set_title(atr("Using the auto-creation tool"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("You can use the auto-creation tool to add all remaining tiles from the tile source at any time:"),
			"[ul]" +
			atr("In the TileSet editor, click the [b]Three Dots[/b] button on the right of the tileset toolbar") + "\n" +
			atr("Select [b]Create Tiles in Non-Transparent Texture Regions[/b]") +
			"[/ul]",
			atr("All tiles from the tile source will be automatically detected and created!"),
		],
	)
	highlight_editor_nodes([
		EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SETUP_TOOLBAR_MENU_BUTTON,
		EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_ATLAS_VIEW,
	])
	complete_step()

	bubble_set_title(atr("Returning to the TileMap editor"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Now that we have all our tiles available, let's return to the TileMap editor and draw a few more tiles."),
			atr("Click the [b]TileMap button[/b] at the bottom of the editor."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.TILE_MAP_DOCK])
	highlight_dock_tab(tilemap_dock)
	bubble_add_task(
		atr("Open the TileMap editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tilemap_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_set_title(atr("Creating platforms"))
	bubble_move_and_anchor(layout_root, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("You now have all the tiles needed to create a platform for our character to stand on."),
			atr("In the tile palette on the right, select individual tiles and try to draw a small complete platform in the viewport using the %s [b]Paint Tool[/b].") % [bbcode_generate_icon_image_by_name("Edit")],
			atr("[b]Left Click[/b] to paint tiles in the viewport and [b]Right Click[/b] to erase them."),
			atr("Take as little or as much time as you'd like to create a platform. This is a moment for you to experiment with the tiles and see how they fit together."),
		],
	)
	highlight_editor_nodes([
		EditorNodePoints.CANVAS_ITEM_EDITOR_VIEWPORT,
		EditorNodePoints.TILE_MAP_TILES_TOOLBAR_PAINT_BUTTON,
		EditorNodePoints.TILE_MAP_TILES_ATLAS_VIEW
	])
	complete_step()

	const PATH_TILESET_RESOURCE = "new_tile_set.tres"
	bubble_set_title(atr("Saving the TileSet"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's save our [b]TileSet[/b] as a resource file so you can reuse it later:"),
			atr("1. In the [b]Inspector[/b], left-click the %s chevron at the right of the [b]Tile Set[/b] property") % [bbcode_generate_icon_image_by_name("GuiTreeArrowDown")],
			atr("2. Select [b]Save As...[/b] and save it to [b]%s[/b] (Godot will suggest this name by default)") % [PATH_TILESET_RESOURCE],
			atr("Saving your [b]TileSet[/b] as a separate resource means you can reuse it across multiple [b]TileMapLayer[/b] nodes and game levels without duplicating work."),
		],
	)
	highlight_inspector_properties(["tile_set"])
	bubble_add_task(
		atr("Save the TileSet resource as [b]%s[/b]") % [PATH_TILESET_RESOURCE.get_file()],
		1,
		func(_task: Task) -> int:
			if FileAccess.file_exists(PATH_TILESET_RESOURCE):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Testing the scene"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's run the scene to test our tilemap with the character. Click the [b]Run Current Scene[/b] button to start the game."),
			atr("You'll notice the character falls right through our tiles. This happens because we haven't added collision shapes to our tileset yet!"),
			atr("The character doesn't \"see\" the tiles as physical objects. We have to add collision shapes to the tiles so the player can stand on them. That's what we'll do in the next tour."),
		],
	)
	highlight_editor_nodes([EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON])
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Great job!"))
	bubble_add_bookend_text([
		"[center]" + atr("You can now create a tileset, add tiles, and paint platforms in a level.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("In the next tour, you'll add collision shapes to your tiles so the character can stand on them.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))
