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
	bubble_set_bookend_title(atr("Overview of the animated sprite editor"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you get an overview of Godot's built-in editor to set up flipbook animations for your 2D games.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("You explore the [b]AnimatedSprite2D[/b] node and its [b]SpriteFrames[/b] editor: the animation list, the frames view, and the toolbar controls.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("In the next two tours, you'll create and fine-tune animations step-by-step.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var layout_root: Control = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_ROOT)
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var run_bar_play_current_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON)
	var sprite_frames_frames_toolbar_play_forwards_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON)

	context_set_2d()
	bubble_set_title(atr("What is AnimatedSprite2D?"))
	bubble_add_text(
		[
			atr("The [b]AnimatedSprite2D[/b] node is a slightly more powerful variant of the Sprite2D node that supports 2D flipbook style animations out of the box."),
			atr("It comes with a dedicated editor to set up hand-drawn frame by frame animations easily."),
			atr("It's perfect for character animations in pixel art games."),
		],
	)
	complete_step()

	scene_open("res://tours/animated_sprite_completed.tscn")
	bubble_set_title(atr("See the finished result"))
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SCENE_DOCK])
	queue_command(
		func force_zoom():
			var canvas_item_editor_zoom_widget: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR_VIEWPORT_ZOOM_WIDGET)
			var canvas_item_editor_zoom_reset_button: Button = EditorInterfaceAccess.get_node_relative(canvas_item_editor_zoom_widget, EditorNodePoints.EDITOR_ZOOM_WIDGET_RESET_BUTTON)
			var canvas_item_editor_zoom_in_button: Button = EditorInterfaceAccess.get_node_relative(canvas_item_editor_zoom_widget, EditorNodePoints.EDITOR_ZOOM_WIDGET_ZOOM_IN_BUTTON)
			var canvas_item_editor_center_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR_VIEWPORT_CENTER_BUTTON)

			# TODO: Replace with direct API calls via editor nodes.
			canvas_item_editor_zoom_reset_button.pressed.emit()
			canvas_item_editor_zoom_in_button.pressed.emit()
			canvas_item_editor_zoom_in_button.pressed.emit()
			canvas_item_editor_zoom_in_button.pressed.emit()
			canvas_item_editor_center_button.pressed.emit.call_deferred()
	)
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("I've opened a scene with an animated character using the [b]AnimatedSprite2D[/b] node."),
			atr("This character has four animations: \"Fall\", \"Idle\", \"Jump\", and \"Run.\" These animations can be triggered during gameplay."),
		],
	)
	bubble_add_task_select_nodes_by_path(["AnimatedSprite2D"])
	complete_step()

	bubble_set_title(atr("The SpriteFrames editor"))
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_DOCK])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text(
		[
			atr("Because this node already has animations set up, selecting it opens the corresponding bottom panel: the [b]SpriteFrames[/b] editor."),
			atr("Let's run through the different parts of the editor."),
		],
	)
	complete_step()

	bubble_set_title(atr("The animation list"))
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_LIST])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("On the left side of the SpriteFrames editor is the [b]Animation List[/b]."),
			atr("This area displays all animations for your sprite. You can add, remove, rename, and select animations here."),
			atr("Each character or object can have multiple animations like \"Idle\", \"Run\", or \"Jump\", and you can play any of them in the running game."),
		],
	)
	complete_step()

	bubble_set_title(atr("Animation toolbar controls"))
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Above the animation list, you'll find controls to manage animations:"),
			"[ul]" +
			atr("The five icons on the left create, cut, copy, paste, and delete animations") + "\n" +
			atr("The %s [b]Autoplay on Load[/b] icon determines if the animation plays automatically when the game starts") % [bbcode_generate_icon_image_by_name("AutoPlay")] + "\n" +
			atr("The %s [b]Animation Looping[/b] toggle button determines if animations repeat") % [bbcode_generate_icon_image_by_name("Loop")] + "\n" +
			atr("The [b]FPS[/b] field controls the selected animation's speed in frames per second") +
			"[/ul]",
		],
	)
	complete_step()

	bubble_set_title(atr("The frames view"))
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text(
		[
			atr("The area on the right is the [b]Frames View[/b], which displays all individual sprite frames in the currently selected animation."),
			atr("Each frame represents one image in your flipbook animation sequence. When played in order at the specified speed, these frames create the illusion of movement."),
		],
	)
	complete_step()

	bubble_set_title(atr("Frames toolbar controls"))
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR])
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text(
		[
			atr("At the top of the frames view, you'll find a toolbar with buttons to play and edit your animation:"),
			"[ul]"+
			atr("On the left are the animation playback controls") + "\n" +
			atr("The next buttons add, copy, move, and delete frames") + "\n" +
			atr("The [b]Frame Duration[/b] field controls the duration of the selected frames relative to the others") +
			"[/ul]",
		],
	)
	complete_step()

	bubble_set_title(atr("Try playing an animation"))
	highlight_editor_nodes(
		[
			EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_PANEL,
			EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON,
		],
	)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR])
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	bubble_add_text(
		[
			atr("Let's preview the selected animation right in the editor!"),
			atr("In the [b]Animation List[/b] on the left, make sure that the [b]run[/b] animation is selected."),
			atr("Then, click the %s [b]Play[/b] button. Click it to play the animation.") % [bbcode_generate_icon_image_by_name("Play")],
			atr("Notice how the frames play in sequence and loop. You can click the %s [b]Pause[/b] button to pause the animation.") % [bbcode_generate_icon_image_by_name("Pause")],
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_play_forwards_button, atr("Play selected animation"))
	complete_step()

	bubble_set_title(atr("Run the scene"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.TOP_RIGHT)
	highlight_editor_nodes([EditorNodePoints.RUN_BAR_PLAY_CURRENT_BUTTON], true)
	scene_open("res://tours/101_animated_sprites_overview/101_in_game.tscn")
	bubble_add_text(
		[
			atr("I just opened a game level for you to try and see the character in action."),
			atr("Click the [b]Run Current Scene[/b] button to play."),
			atr("Use the arrow keys to move the character and space to jump. Watch how the animations change based on what the character is doing! The character uses the animations defined in the SpriteFrames editor."),
			atr("When you're done exploring, close the game window to return to the editor."),
		],
	)
	bubble_add_task_press_button(run_bar_play_current_button)
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Great job!"))
	bubble_add_bookend_text([
		"[center]" + atr("You now know the [b]AnimatedSprite2D[/b] node and the different parts of the [b]SpriteFrames[/b] editor.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("In the next tour, you'll create your first animation from scratch.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))
