@tool
extends "res://addons/godot_tours/tour.gd"

const Gobot := preload("res://addons/godot_tours/bubble/gobot/gobot.gd")


func _build() -> void:
	set_command_context(CommandContext.WELCOME_BOOKEND)
	steps_welcome()
	set_command_context(CommandContext.TOUR_STEP)
	part_010_start()
	set_command_context(CommandContext.FINALE_BOOKEND)
	steps_finale()


func steps_welcome() -> void:
	bubble_set_bookend_title(atr("Creating an animation"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("If you haven't completed the previous tour in this series, quit to return to the menu and complete it first to get the expected results.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you create a new animation from scratch using the [b]SpriteFrames[/b] editor.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("You learn how to add frames, change playback speed, and loop animations. This is everything you need to set up character animations in your own games.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var layout_root: Control = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_ROOT)
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var filesystem_tree: Tree = EditorInterfaceAccess.get_node(EditorNodePoints.FILE_SYSTEM_TREE)

	var sprite_frames_dock: EditorDock = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_DOCK)
	var sprite_frames_animations_toolbar_looping_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR_LOOPING_BUTTON)
	var sprite_frames_animations_toolbar_speed_edit: Control = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR_SPEED_EDIT)
	var sprite_frames_frames_list: ItemList = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST)
	var sprite_frames_frames_toolbar_play_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON)

	# Step 1: Creating a new scene
	context_set_2d()
	bubble_set_title(atr("Creating a new scene"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_LEFT)
	highlight_editor_nodes([EditorNodePoints.MENU_BAR], true)
	bubble_add_text(
		[
			atr("Let's create our own animated sprite from scratch!"),
			atr("Create a new scene by going to the Scene menu and selecting [b]New Scene[/b]."),
		],
	)
	bubble_add_task(
		atr("Create a new scene."),
		1,
		func task_create_new_scene(_task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 1
			return 0
	)
	complete_step()

	# Step 2: Adding an AnimatedSprite2D node
	bubble_set_title(atr("Adding an AnimatedSprite2D node"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_LEFT)
	highlight_editor_nodes([EditorNodePoints.SCENE_TREE_ADD_NODE_BUTTON], true)
	bubble_add_text(
		[
			atr("Now click the %s [b]Add Node[/b] button at the top left of the Scene dock to open the node creation dialog.") % [bbcode_generate_icon_image_by_name("Add")],
			atr("When the [b]Create New Node[/b] dialog appears, search for [b]AnimatedSprite2D[/b] and double-click it to add it to your scene."),
		],
	)
	bubble_add_task(
		atr("Create an AnimatedSprite2D node."),
		1,
		func task_created_animated_sprite_node(_task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			# Check if there is an AnimatedSprite2D node as root or child
			if scene_root is AnimatedSprite2D:
				return 1

			for child in scene_root.get_children():
				if child is AnimatedSprite2D:
					return 1

			return 0
	)
	complete_step()

	# Step 3: Creating a SpriteFrames resource
	bubble_set_title(atr("Creating a SpriteFrames resource"))
	queue_command(
		func force_zoom():
			canvas_item_editor_center_at()

			var canvas_item_editor_zoom_widget: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR_VIEWPORT_ZOOM_WIDGET)
			var canvas_item_editor_zoom_reset_button: Button = EditorInterfaceAccess.get_node_relative(canvas_item_editor_zoom_widget, EditorNodePoints.EDITOR_ZOOM_WIDGET_RESET_BUTTON)
			var canvas_item_editor_zoom_in_button: Button = EditorInterfaceAccess.get_node_relative(canvas_item_editor_zoom_widget, EditorNodePoints.EDITOR_ZOOM_WIDGET_ZOOM_IN_BUTTON)
			var canvas_item_editor_center_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR_VIEWPORT_CENTER_BUTTON)

			# TODO: Replace with direct API calls via editor nodes.
			canvas_item_editor_zoom_reset_button.pressed.emit()
			canvas_item_editor_zoom_in_button.pressed.emit()
			canvas_item_editor_zoom_in_button.pressed.emit()
			canvas_item_editor_zoom_in_button.pressed.emit()
			canvas_item_editor_center_button.pressed.emit()
	)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_RIGHT)
	highlight_inspector_properties(["sprite_frames"])
	bubble_add_text(
		[
			atr("The [b]AnimatedSprite2D[/b] node needs a [b]SpriteFrames[/b] resource to hold all its animations and frames."),
			atr("In the [b]Inspector[/b], ensure the Animation category is expanded and locate the [b]Sprite Frames[/b] property, which is currently empty."),
			atr("Click the dropdown arrow next to the empty field and select %s [b]New SpriteFrames[/b] to create the resource.") % [bbcode_generate_icon_image_by_name("SpriteFrames")],
		],
	)
	bubble_add_task(
		atr("Create a SpriteFrames resource."),
		1,
		func task_create_spriteframes_resource(_task: Task) -> int:
			var scene_root = EditorInterface.get_edited_scene_root()
			if scene_root == null:
				return 0

			var animated_sprite = null
			if scene_root is AnimatedSprite2D:
				animated_sprite = scene_root
			else:
				for child in scene_root.get_children():
					if child is AnimatedSprite2D:
						animated_sprite = child
						break

			if animated_sprite == null:
				return 0

			return 1 if animated_sprite.sprite_frames != null else 0
	)
	complete_step()

	# Step 4: Opening the SpriteFrames editor
	bubble_set_title(atr("Opening the SpriteFrames editor"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_RIGHT)
	highlight_inspector_properties(["sprite_frames"])
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_DOCK])
	bubble_add_text(
		[
			atr("Click on the newly created [b]SpriteFrames[/b] resource in the Inspector. This will open the SpriteFrames editor at the bottom of the screen."),
		],
	)
	bubble_add_task(
		atr("Open the SpriteFrames editor."),
		1,
		func task_open_spriteframes_editor(_task: Task) -> int:
			return 1 if sprite_frames_dock.visible else 0
	)
	complete_step()

	# Step 5: Renaming the default animation
	bubble_set_title(atr("Renaming the default animation"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_LIST])
	bubble_add_text(
		[
			atr("You'll notice a \"default\" animation has already been created for you. Let's rename it to better match the animation we'll create."),
			atr("Click on [b]default[/b] in the animation list to rename it. Type [b]run[/b] and press Enter."),
			atr("It's important to give animations meaningful names because those are the names you'll use to play them in your GDScript code."),
		],
	)
	bubble_add_task(
		atr("Rename the default animation to 'run'."),
		1,
		func task_rename_animation_to_run(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if animated_sprite == null or animated_sprite.sprite_frames == null:
				return 0
			return 1 if animated_sprite.sprite_frames.has_animation("run") else 0
	)
	complete_step()

	# Step 6: Adding frames to an animation
	bubble_set_title(atr("Adding frames to an animation"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	var run_frames: Array[String] = []
	for i in range(6):
		run_frames.append("res://assets/lucy/run/%03d.png" % i)
	highlight_filesystem_paths(run_frames, false)
	bubble_add_text(
		[
			atr("There are multiple ways to add frames to an animation. The easiest method is to drag and drop images from the FileSystem dock."),
			atr("Notice the folder [b]res://assets/lucy/run[/b] in the [b]FileSystem[/b] dock. That's where the sprites for Lucy's run animation are stored."),
		],
	)
	complete_step()

	# Step 7: Selecting multiple frames
	bubble_set_title(atr("Selecting multiple frames"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_filesystem_paths(run_frames, false)
	bubble_add_text(
		[
			atr("Let's add frames to the run animation. To add multiple frames at once:"),
			"[ul]" +
			atr("[b]Left click[/b] on the first image file, [b]000.png[/b]") + "\n" +
			atr("Hold [b]Shift[/b] and [b]left click[/b] on the last file, [b]005.png[/b]") +
			"[/ul]",
			"",
			atr("This selects all frames in between."),
		],
	)
	bubble_add_task(
		atr("Select all 6 run animation frames."),
		6,
		func task_select_all_anim_frames(_task: Task) -> int:
			# Verify that all run_frames are in the selection
			var selected_paths = EditorInterface.get_selected_paths()
			var count := 0
			for path in run_frames:
				if selected_paths.has(path):
					count += 1
			return count
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(filesystem_tree, run_frames.front()),
		get_tree_item_center_by_path.bind(filesystem_tree, run_frames.back()),
	)
	mouse_click()
	complete_step()

	# Step 8: Drag and drop frames
	bubble_set_title(atr("Drag and drop frames"))
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	highlight_filesystem_paths(run_frames, false)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST])
	bubble_add_text(
		[
			atr("With the frames selected, drag and drop them into the [b]Frames View[/b] in the right side of the SpriteFrames editor."),
			atr("All the selected frames will be added to your [b]run[/b] animation in sequence."),
		],
	)
	bubble_add_task(
		atr("Add the 6 run frames to the animation."),
		6,
		func task_add_6_frames(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if animated_sprite == null or animated_sprite.sprite_frames == null:
				return 0
			var animation_name := "run"
			if not animated_sprite.sprite_frames.has_animation("run"):
				var names := animated_sprite.sprite_frames.get_animation_names()
				animation_name = names[0] if names.size() > 0 else "default"
			return animated_sprite.sprite_frames.get_frame_count(animation_name)
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(filesystem_tree, run_frames[run_frames.size() / 2]),
		get_control_global_center.bind(sprite_frames_frames_list),
	)
	mouse_click()
	complete_step()

	# Step 9: Looping animations
	bubble_set_title(atr("Looping animations"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR_LOOPING_BUTTON])
	bubble_add_text(
		[
			atr("Animations can be set to loop, play in ping-pong mode (forward then backward), or play once. The %s [b]Loop[/b] icon above the animation list cycles through these modes.") % [bbcode_generate_icon_image_by_name("Loop")],
			atr("By default, looping is turned off. Click the icon once to enable the standard looping mode (the icon should be highlighted blue)."),
			atr("For a run animation, we use standard looping so the animation cycles continuously."),
		],
	)
	bubble_add_task_toggle_button(sprite_frames_animations_toolbar_looping_button, true, atr("Turn on animation looping by clicking the Loop button once."))
	complete_step()

	# Step 10: Previewing your animation
	bubble_set_title(atr("Previewing your animation"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	canvas_item_editor_center_at()
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON])
	bubble_add_text(
		[
			atr("Let's see how the animation looks!"),
			atr("Click the %s [b]Play[/b] button to preview your animation.") % [bbcode_generate_icon_image_by_name("Play")],
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_play_button, atr("Play the animation."))
	complete_step()

	# Step 11: Adjusting animation speed
	bubble_set_title(atr("Adjusting animation speed"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR_SPEED_EDIT])
	bubble_add_text(
		[
			atr("Our run animation currently is too slow because the default animation framerate is low."),
			atr("We can adjust this by changing its frame rate using the [b]FPS[/b] (Frames Per Second) field above the animation list."),
			atr("Change the FPS value from [b]5.0[/b] to [b]10.0[/b]."),
			atr("Think of this like a flipbook: higher FPS means flipping through the frames faster. It also makes the animation more fluid."),
		],
	)
	bubble_add_task(
		atr("Change the FPS value to 10.0."),
		1,
		func task_change_fps_value(_task: Task) -> int:
			# Check if the animation speed is 10.0 FPS
			if is_equal_approx(sprite_frames_animations_toolbar_speed_edit.value, 10.0):
				return 1
			return 0
	)
	complete_step()

	# Step 12: Previewing the adjusted animation
	bubble_set_title(atr("Previewing the adjusted animation"))
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR])
	bubble_add_text(
		[
			atr("Great job! Because the animation is looping, you can immediately see how the speed change affects the animation."),
			atr("For a running animation, 10-12 FPS usually gives a good result for pixel art characters."),
		],
	)
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Excellent!"))
	bubble_add_bookend_text([
		"[center]" + atr("You can now create a looping animation from scratch using the [b]SpriteFrames[/b] editor.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("In the next tour, you'll fine-tune animations by adjusting the timing of individual frames and reordering frames.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))


# Helpers.

## Helper function to get the AnimatedSprite2D node created in this tour from the scene.
func get_animated_sprite_node() -> AnimatedSprite2D:
	var scene_root = EditorInterface.get_edited_scene_root()
	return scene_root as AnimatedSprite2D
