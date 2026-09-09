@tool
extends "res://tours/tileset_tours_base.gd"


func _build() -> void:
	set_command_context(CommandContext.TOUR_RESET)
	editor_reset_state(
		func reset_editor_state_for_tour():
			# Turn off tilemap grid visibility
			var tilemap_grid_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_COMMON_TOOLBAR_GRID_BUTTON)
			tilemap_grid_button.button_pressed = false
			# Turn off highlighting current layer
			var tilemap_highlight_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_COMMON_TOOLBAR_HIGHLIGHT_BUTTON)
			tilemap_highlight_button.button_pressed = false
	)

	set_command_context(CommandContext.WELCOME_BOOKEND)
	steps_welcome()
	set_command_context(CommandContext.TOUR_STEP)
	part_010_start()
	set_command_context(CommandContext.FINALE_BOOKEND)
	steps_finale()


func steps_welcome() -> void:
	bubble_set_bookend_title(atr("Intro to tilesets and tilemaps in Godot"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you get an introduction to tilesets and tilemaps in Godot.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("You explore how [b]TileSet[/b] resources work like a painter's palette and how [b]TileMapLayer[/b] nodes use that palette to paint levels.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("In the next tour, you start creating your own tileset from scratch.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var layout_root: Control = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_ROOT)
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var run_bar_play_current_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON)
	var tileset_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_DOCK)

	context_set_2d()
	bubble_set_title(atr("What are tilemaps?"))
	bubble_add_text(
		[
			atr("Tilemaps are a widely used technique in 2D games to create levels and backgrounds."),
			atr("Instead of placing individual sprites, tilemaps let you paint your levels using collections of small images called [b]tiles[/b]."),
			atr("In this image, you can see tiles on the left and ivy painted on top of a platform using those tiles on the right:"),
		],
	)
	const TERRAIN_EXAMPLE = preload("uid://c7j7ro754ll37")
	bubble_add_texture(TERRAIN_EXAMPLE, 360)
	complete_step()

	bubble_set_title(atr("Why use tilemaps?"))
	bubble_add_text(
		[
			atr("There are several reasons to use tilemaps in your game:"),
			"[ul]" +
			atr("You can paint your level structure intuitively") + "\n" +
			atr("You need few art assets") + "\n" +
			atr("Their performance is great") + "\n" +
			atr("In Godot, tilemaps are feature-packed: collisions, AI pathfinding, and more are supported out of the box") +
			"[/ul]",
		],
	)
	complete_step()

	bubble_set_title(atr("Many games use tilemaps"))
	bubble_add_text(
		[
			atr("Games that you know and love use tilemaps for their levels, including [b]Stardew Valley[/b], [b]Dead Cells[/b], or even [b]Hollow Knight[/b]!"),
		],
	)
	const STARDEW_VALLEY_SCREENSHOT = preload("uid://8sqr06d588jg")
	bubble_add_texture(STARDEW_VALLEY_SCREENSHOT, 360)
	bubble_add_text(
		[
			atr("The environment in this screenshot from [b]Stardew Valley[/b] is made up of tiles: the dirt, fences, the grass are all tiles."),
		],
	)
	complete_step()

	scene_open("uid://de1wa1mchwo8")
	bubble_set_title(atr("This is a tilemap"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR])
	scene_deselect_all_nodes()
	bubble_add_text(
		[
			atr("This little game level I just opened is created entirely using Godot's tilemap system."),
			atr("Every platform, wall, and decoration you see in the environment is made up of tiles."),
			atr("Only the player character and the water plane use regular sprites."),
		],
	)
	complete_step()

	bubble_set_title(atr("Run the scene"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON])
	bubble_add_text(
		[
			atr("Run the scene to see the tilemap system in action!"),
			atr("Click the [b]Run Current Scene[/b] button in the toolbar."),
			atr("[b]Controls:[/b]"),
			"[ul]" +
			atr("[b]Arrow keys[/b]: Move the character around") + "\n" +
			atr("[b]C[/b]: Jump and double jump") +
			"[/ul]",
			atr("Try jumping through the mushroom platforms! They are one-way platforms, so you can jump through them from below without falling through them from above."),
			atr("Close the game window when you're done exploring."),
		],
	)
	bubble_add_task_press_button(run_bar_play_current_button)
	complete_step()

	bubble_set_title(atr("Select the ground layer"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_scene_nodes_by_path(["MushroomWorld/Ground"])
	bubble_add_text(
		[
			atr("Now that you've played the level, let's look at a [b]TileMapLayer[/b] node. This node is responsible for drawing tiles in the scene."),
			atr("Start by selecting the [b]TileMapLayer[/b] node named [b]Ground[/b] in the [b]Scene Dock[/b]."),
			atr("This node contains the main level structure: the floor and walls."),
		],
	)
	bubble_add_task_select_nodes_by_path(["MushroomWorld/Ground"])
	complete_step()

	bubble_set_title(atr("The tilemap uses a grid"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR])
	queue_command(
		func turn_on_grid_and_highlight():
			# Turn on tilemap grid visibility
			var tilemap_grid_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_COMMON_TOOLBAR_GRID_BUTTON)
			tilemap_grid_button.button_pressed = true
			# Turn on highlighting current layer
			var tilemap_highlight_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_MAP_COMMON_TOOLBAR_HIGHLIGHT_BUTTON)
			tilemap_highlight_button.button_pressed = true
	)
	bubble_add_text(
		[
			atr("Great! Now let's look at the tilemap grid."),
			atr("The tilemap is organized into a grid where each square can hold exactly one tile. This ensures all tiles align perfectly."),
			atr("The grid also makes it easy to paint your level: you just click on a grid square to place a tile there."),
			atr("For this pixel art game, each grid square is 16x16 pixels to match the tile size."),
		],
	)
	complete_step()

	bubble_set_title(atr("Multiple layers work together"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_scene_nodes_by_path(["MushroomWorld/Ground", "MushroomWorld/Decorations"])
	bubble_add_text(
		[
			atr("Notice how this level uses multiple [b]TileMapLayer[/b] nodes. I selected two: [b]Ground[/b] and [b]Decorations[/b]."),
			atr("Each node represents one drawing layer and has a different purpose: the [b]Ground[/b] layer contains the main platforms and walls, while [b]Decorations[/b] adds little details like grass and mushrooms."),
			atr("You can use as many layers as you need to organize your level."),
		],
	)
	complete_step()

	bubble_set_title(atr("The TileSet palette"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("But how does each [b]TileMapLayer[/b] know which tiles it can draw?"),
			atr("It uses a [b]TileSet[/b] resource. Think of it as a painter's palette containing all available tiles."),
			atr("Just like a painter chooses colors from their palette, the [b]TileMapLayer[/b] lets you pick tiles from its [b]TileSet[/b] to paint the level."),
			atr("Let's look at the [b]TileSet[/b] that contains all the mushroom world tiles."),
		],
	)
	complete_step()

	bubble_set_title(atr("TileMapLayer nodes use the Tileset resource"))
	highlight_inspector_properties(["tile_set"])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_add_text(
		[
			atr("Here's how the tilemap system works. You:"),
			atr("1. Create a [b]TileSet[/b] resource (your palette of tiles)"),
			atr("2. Assign the [b]TileSet[/b] to a [b]TileMapLayer[/b] node in the [b]Inspector[/b]"),
			atr("3. Use the [b]TileMapLayer[/b] to paint your level with tiles from the [b]TileSet[/b]"),
			atr("You can see the [b]TileSet[/b] assigned to the [b]Ground[/b] layer in the [b]Inspector[/b]."),
		],
	)
	complete_step()

	bubble_set_title(atr("Open the TileSet editor"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	highlight_dock_tab(tileset_dock)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_add_text(
		[
			atr("The [b]TileSet[/b] editor is where you create and configure your palette of tiles."),
			atr("Click the [b]TileSet button[/b] at the bottom to switch from the [b]TileMap editor[/b] to the [b]TileSet editor[/b]."),
			atr("You'll see the actual tiles that make up this mushroom world."),
		],
	)
	bubble_add_task(
		atr("Open the TileSet editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tileset_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_set_title(atr("What's in a TileSet?"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER)
	bubble_add_text(
		[
			atr("A [b]TileSet[/b] resource contains all the data needed to draw tiles:"),
			"[ul]" +
			atr("Tile textures (the actual images)") + "\n" +
			atr("Collision shapes for physics") + "\n" +
			atr("Terrain rules for auto-connecting tiles") + "\n" +
			atr("Custom properties for each tile") +
			"[/ul]",
			atr("The [b]TileSet[/b] editor exposes all of that."),
		],
	)
	complete_step()

	bubble_set_title(atr("Your tile palette"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_DOCK])
	bubble_add_text(
		[
			atr("Here's the [b]TileSet[/b] palette used to create the level you just played!"),
			atr("The interface is busy but you can see individual tiles for the ground on the right side."),
			atr("Each tile here can be painted onto a [b]TileMapLayer[/b] to build your level."),
			atr("In the next tours, you'll learn how to create your own [b]TileSet[/b] like this one."),
		],
	)
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Excellent!"))
	bubble_add_bookend_text([
		"[center]" + atr("You now understand how [b]TileSet[/b] resources and [b]TileMapLayer[/b] nodes work together to build levels.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("In the next tour, you'll create your first tileset from scratch.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))
