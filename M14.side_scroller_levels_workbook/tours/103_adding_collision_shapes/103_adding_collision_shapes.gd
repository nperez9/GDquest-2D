@tool
extends "res://tours/tileset_tours_base.gd"


func _build() -> void:
	set_command_context(CommandContext.WELCOME_BOOKEND)
	steps_welcome()
	set_command_context(CommandContext.TOUR_STEP)
	part_010_start()
	set_command_context(CommandContext.FINALE_BOOKEND)
	steps_finale()


func steps_welcome() -> void:
	bubble_set_bookend_title(atr("Adding collision shapes"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("If you haven't completed the previous tours in this series, quit to return to the menu and complete them in order to get the expected results.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you add collision shapes to your tileset tiles.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("You create a physics layer and add rectangular collision shapes to make tiles solid so the player can stand on platforms.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var run_bar_play_current_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON)

	var tileset_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_DOCK)
	var tileset_atlas_view: Control = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_ATLAS_VIEW)

	add_step_open_start_scene_conditionally()

	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_set_title(atr("Collisions in tilemaps"))
	bubble_add_text(
		[
			atr("The tiles in a tilemap start without collision shapes. This means that when you draw tiles, by default, they are just visual elements without any physics properties."),
			atr("You need to add collision shapes to relevant tiles to make them solid and stop the player from falling through them."),
			atr("Before we can add collision shapes, we need to add a [b]Physics Layer[/b] in the TileSet to enable collisions on it. We can do that by editing the TileSet resource in the [b]Inspector[/b]."),
		],
	)
	complete_step()

	bubble_set_title(atr("Selecting the Ground node"))
	highlight_scene_nodes_by_name(["Ground"])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Make sure that the [b]Ground[/b] node is selected to reveal its properties in the [b]Inspector[/b]."),
		],
	)
	bubble_add_task_select_nodes_by_path(["CreatingTilesets/Ground"])
	complete_step()

	bubble_set_title(atr("Reveal the TileSet physics layers"))
	highlight_inspector_properties(["tile_set"], false)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's reveal the physics layers in the [b]Inspector[/b]:"),
			atr("1. Click the [b]Tile Set[/b] property to expand the TileSet resource if it isn't already open"),
			atr("2. Locate and click the [b]Physics Layers[/b] category to open it"),
		],
	)
	bubble_add_task_expand_inspector_property("tile_set")
	complete_step()

	bubble_set_title(atr("Creating a physics layer"))
	highlight_inspector_properties(["tile_set"], false)
	bubble_add_text(
		[
			atr("The physics layers start out empty, so we need to create a new one."),
			atr("Click the [b]Add Element[/b] button under the [b]Physics Layers[/b] section to add a new physics layer."),
		],
	)
	bubble_add_task(
		atr("Add a physics layer to the [b]TileSet[/b] resource"),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node := scene_root.find_child("Ground")
			if ground_node and ground_node.tile_set and ground_node.tile_set.get_physics_layers_count() > 0:
				return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Understanding collision layers"))
	highlight_inspector_properties(["physics_layer_0/collision_layer", "physics_layer_0/collision_mask"], false)
	bubble_add_text(
		[
			atr("You now have one physics layer associated with your tileset!"),
			atr("Just like Godot's physics bodies and area nodes, this physics layer comes with two important properties: [b]Collision Layer[/b] and [b]Collision Mask[/b]."),
			atr("These properties work the same as any other physics body or area node in Godot. Let's review each of them."),
		],
	)
	complete_step()

	bubble_set_title(atr("The collision layer property"))
	highlight_inspector_properties(["physics_layer_0/collision_layer"], false)
	bubble_add_text(
		[
			atr("The [b]Collision Layer[/b] controls which physics layer the tilemap is on. It allows [b]other[/b] objects to detect the tilemap's platforms."),
			atr("Think of it as a \"tag\" the physics engine uses to identify the tilemap. It allows entities like the player character to stand on platforms."),
			atr("The player character is set up to look for ground on collision layer 2, so we need to change the [b]Collision Layer[/b] from [b]1[/b] to [b]2[/b]."),
			atr("Click the lit field labeled [b]1[/b] below \"Collision Layer\" to disable it, then click the field labeled [b]2[/b] to enable it."),
		],
	)
	bubble_add_task(
		atr("Set the collision layer to 2"),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node := scene_root.find_child("Ground")
			if (
				ground_node and ground_node.tile_set and
				ground_node.tile_set.get_physics_layer_collision_layer(0) == 0b10
			):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("The collision mask property"))
	highlight_inspector_properties(["physics_layer_0/collision_mask"], false)
	bubble_add_text(
		[
			atr("The [b]Collision Mask[/b] controls which other physics objects the tilemap itself can detect."),
			atr("We don't need the tilemap to detect anything - we just want the player character to be able to detect the tilemap."),
			atr("Let's remove the [b]Collision Mask[/b]. Click the lit field labeled [b]1[/b] below \"Collision Mask\" to disable it."),
		],
	)
	bubble_add_task(
		atr("Remove the collision mask 1"),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node := scene_root.find_child("Ground")
			if ground_node and ground_node.tile_set and ground_node.tile_set.get_physics_layer_collision_mask(0) == 0:
				return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Opening the TileSet editor"))
	highlight_dock_tab(tileset_dock)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's open the [b]TileSet editor[/b] to add collision shapes to our tiles."),
		],
	)
	bubble_add_task(
		atr("Open the TileSet editor."),
		1,
		func(_task: Task) -> int:
			return 1 if tileset_dock.is_visible_in_tree() else 0
	)
	complete_step()

	bubble_set_title(atr("Activating the Select tool"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_BUTTON])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("We want to add the same collision shape to all our solid ground tiles at once. For that, we need to select them all."),
			atr("First, let's make sure we have the right tool active. Click the %s [b]Select Tool[/b] in the TileSet editor toolbar.") % [bbcode_generate_icon_image_by_name("ToolSelect")],
		],
	)
	bubble_add_task(
		atr("Activate the Select Tool"),
		1,
		func(_task: Task) -> int:
			var select_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_BUTTON)
			return 1 if select_button.button_pressed else 0
	)
	complete_step()

	bubble_set_title(atr("Selecting all tiles"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_ATLAS_VIEW])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Now let's select all the solid ground tiles at once."),
			atr("Click and drag from the top left tile to the bottom right tile to select all the solid ground tiles in the tiles view."),
			atr("Use the zoom controls at the top left of the tiles view to zoom in and out if needed. Press the [b]Middle Mouse Button[/b] to pan the view."),
		],
	)
	complete_step()

	bubble_set_title(atr("Accessing physics properties"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_PANEL])
	bubble_add_text(
		[
			atr("Selecting one or more tiles reveals their properties in the middle column of the TileSet editor. This column works like the [b]Inspector[/b] dock: it shows the properties of the selected tiles."),
			atr("In the middle column, expand the [b]Physics[/b] section and then [b]Physics Layer 0[/b] to access the physics properties of the selected tiles."),
		],
	)
	complete_step()

	bubble_set_title(atr("Expanding the TileSet editor"))
	highlight_editor_nodes([EditorNodePoints.LAYOUT_EXPAND_BOTTOM_BUTTON])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("The TileSet editor can sometimes be too small to see all the properties. We can expand it to fill the entire Godot editor vertically by clicking the [b]Expand Bottom Panel[/b] button (Shift+F12) at the bottom right of the TileSet editor."),
			atr("This button works for all bottom panels in Godot, so you can use it to quickly resize the editor to your liking."),
		],
	)
	bubble_add_task(
		atr("Expand the bottom panel"),
		1,
		func(_task: Task) -> int:
			var expand_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_EXPAND_BOTTOM_BUTTON)
			return 1 if expand_button.button_pressed else 0
	)
	complete_step()

	# NOTE: After this point the canvas item editor may not be visible due to the expanded
	# bottom panel and anchoring to it may not be reliable.

	bubble_set_title(atr("The collision shape editor"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_PANEL])
	bubble_move_and_anchor(tileset_atlas_view, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Now, we can see the tiles' physics properties more comfortably. Let's focus on the [b]Physics Layer 0[/b] section once more."),
			atr("This section offers an editor to add collision shapes to the selected tiles. It works similarly to the [b]CollisionPolygon2D[/b] node, as it allows you to draw polygons to define the collision shapes."),
		],
	)
	complete_step()

	bubble_set_title(atr("The collision shape editor toolbar"))
	queue_command(highlight_tileset_inspector_polygons_editor)
	bubble_add_text(
		[
			atr("The toolbar above the collision shape editor contains several buttons to add, select, and remove points from the collision shape."),
			atr("On the right, the %s [b]Grid Snap[/b] icon lets you choose whether to snap the points to a grid or not. This is useful for aligning the points of the collision shape to pixel-perfect positions.") % [bbcode_generate_icon_image_by_name("SnapDisable")],
		],
	)
	complete_step()

	bubble_set_title(atr("Adding a square collision shape"))
	queue_command(highlight_tileset_inspector_physics_layer_0_vertical_dots)
	bubble_add_text(
		[
			atr("Now let's add a collision shape. We want every tile to have a rectangular collision shape that covers the entire tile."),
			atr("For that, we can use the [b]Reset to default tile shape[/b] menu option:"),
			atr("1. Click the %s [b]three vertical dots[/b] button in the collision shape editor toolbar") % [bbcode_generate_icon_image_by_name("GuiTabMenuHl")],
			atr("2. Select [b]Reset to default tile shape[/b] from the menu"),
			atr("You can also press the [b]F[/b] key with the collision shape editor focused."),
		],
	)
	bubble_add_task(
		atr("Add a square collision shape to the selected tiles"),
		1,
		func(_task: Task) -> int:
			var scene_root := EditorInterface.get_edited_scene_root()
			var ground_node := scene_root.find_child("Ground")
			if ground_node != null and ground_node.tile_set != null:
				if did_user_create_collision_polygon(ground_node.tile_set):
					return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Verifying the collision shapes"))
	highlight_editor_nodes([EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_ATLAS_VIEW])
	bubble_move_and_anchor(tileset_dock, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("You should now see a light blue polygon overlaid on each of your selected tiles in the tiles view on the right."),
			atr("Because all your tiles are selected, you just created a collision shape for all of them at once! This is a great way to save time when working with large tilesets."),
		],
	)
	complete_step()

	bubble_set_title(atr("Running the scene"))
	highlight_editor_nodes([EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's test our collisions by running the scene."),
			atr("Click the [b]Run Current Scene[/b] button to run the game."),
			atr("Here are the controls to move the character:"),
			"[ul]" +
			atr("Use the arrow keys to move") + "\n" +
			atr("Press the [b]C[/b] key to jump") +
			"[/ul]",
			atr("Now, the character should be able to stand on the platforms instead of falling through them!"),
		],
	)
	bubble_add_task_press_button(run_bar_play_current_button)
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Marvelous!"))
	bubble_add_bookend_text([
		"[center]" + atr("You now have a tileset with working collision shapes that can interact with physics bodies.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("Next, you'll set up one-way tiles that the character can jump through from below and land on from above.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))


# Helpers.

## Returns true if the first tile in the last tile Atlas source has a collision
## polygon. Use this to check that at least one selected tile has a
## collision polygon, which validates that the user did create a collision
## polygon.
func did_user_create_collision_polygon(tileset: TileSet) -> bool:
	var count := tileset.get_source_count()
	if count == 0:
		return false

	var tile_atlas := tileset.get_source(tileset.get_source_id(count - 1)) as TileSetAtlasSource
	if tile_atlas == null:
		return false

	var tile_data := tile_atlas.get_tile_data(Vector2i.ZERO, 0)
	if tile_data == null:
		return false

	const PHYSICS_LAYER_INDEX = 0
	if tile_data.get_collision_polygons_count(PHYSICS_LAYER_INDEX) > 0:
		return true
	return false
