## This script groups methods and properties that are likely to be used by
## multiple of the tileset tours.
@tool
extends "res://addons/godot_tours/tour.gd"

const Gobot := preload("res://addons/godot_tours/bubble/gobot/gobot.gd")

## Path to the scene that users edit while following the tours in this series.
const PATH_SCENE_CREATING_TILESETS = "res://creating_tilesets.tscn"


func add_step_open_start_scene_conditionally() -> void:
	const ROOT_NODE_NAME = "CreatingTilesets"
	var start_scene_root := EditorInterface.get_edited_scene_root()
	if start_scene_root != null and start_scene_root.name == ROOT_NODE_NAME:
		return

	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var filesystem_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.FILE_SYSTEM_DOCK)
	var filesystem_tree: Tree = EditorInterfaceAccess.get_node(EditorNodePoints.FILE_SYSTEM_TREE)

	highlight_filesystem_paths([PATH_SCENE_CREATING_TILESETS])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_set_title(atr("Open the start scene"))
	bubble_add_text(
		[
			atr("Let's start by opening the scene we will be working with."),
			atr("In the [b]FileSystem Dock[/b] at the bottom-left, find and [b]double-click[/b] on the scene we will be working with: [b]%s[/b].") % PATH_SCENE_CREATING_TILESETS.get_file(),
		],
	)
	bubble_add_task(
		atr("Open the scene [b]%s[/b].") % PATH_SCENE_CREATING_TILESETS.get_file(),
		1,
		func task_open_start_scene(_task: Task) -> int:
			var current_scene_root := EditorInterface.get_edited_scene_root()
			if current_scene_root == null:
				return 0
			return 1 if current_scene_root.name == ROOT_NODE_NAME else 0
	)
	mouse_move_by_callable(
		func get_filesystem_dock_center() -> Vector2: return filesystem_dock.get_global_rect().get_center(),
		get_tree_item_center_by_path.bind(filesystem_tree, PATH_SCENE_CREATING_TILESETS),
	)
	mouse_click()
	mouse_click()
	complete_step()


func highlight_dock_tab(dock: EditorDock) -> void:
	queue_command(func() -> void:
		var dock_tabs := EditorInterfaceAccess.get_dock_tabs(dock)
		if not dock_tabs:
			return

		var dock_tab_index := EditorInterfaceAccess.get_dock_tab_index(dock)
		overlays.highlight_tab_index(dock_tabs, dock_tab_index)
	)


## Highlights the widget to edit the polygon shape of a selected tile in the
## central inspector row in the TileSet editor.
func highlight_tileset_inspector_polygons_editor() -> void:
	var inspector := EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_PANEL)
	var properties := inspector.find_children("", "EditorProperty", true, false)
	for property: EditorProperty in properties:
		if property.get_edited_property().begins_with("physics_layer_0/polygons"):
			var to_highlight: Control = null
			for child in property.get_children():
				if child.get_class() == "GenericTilePolygonEditor":
					to_highlight = child

			overlays.highlight_controls([to_highlight])
			break


## Highlights the three vertical dots menu icon in the selected tiles inspector
## that allow you to add a or remove the collision shape to the selected tiles.
func highlight_tileset_inspector_physics_layer_0_vertical_dots() -> void:
	var inspector := EditorInterfaceAccess.get_node(EditorNodePoints.TILE_SET_TILES_ATLAS_EDITOR_SELECT_PANEL)
	var properties := inspector.find_children("", "EditorProperty", true, false)
	for property: EditorProperty in properties:
		# TODO: not sure why some times it's physics_layer_0/polygons_count and others physics_layer_0/polygons
		if property.get_edited_property().begins_with("physics_layer_0/polygons"):
			var polygon_editor: Control = null
			for child in property.get_children():
				if child.get_class() == "GenericTilePolygonEditor":
					polygon_editor = child

			var preview: Control = polygon_editor.get_child(1)
			var dots_menu_button: MenuButton = polygon_editor.find_children("", "MenuButton", true, false)[-2]
			overlays.highlight_controls([dots_menu_button, preview])
			break
