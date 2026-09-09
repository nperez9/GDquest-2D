@tool
extends "res://addons/godot_tours/tour.gd"

const Gobot := preload("res://addons/godot_tours/bubble/gobot/gobot.gd")

const TEXTURE_IDLE := preload("res://assets/lucy/idle/idle.png")
const TEXTURE_BLINKING := preload("res://assets/lucy/idle/blinking.png")


func _build() -> void:
	set_command_context(CommandContext.WELCOME_BOOKEND)
	steps_welcome()
	set_command_context(CommandContext.TOUR_STEP)
	part_010_start()
	set_command_context(CommandContext.FINALE_BOOKEND)
	steps_finale()


func steps_welcome() -> void:
	bubble_set_bookend_title(atr("Manipulating animation frames"))
	bubble_set_bookend_button_text(atr("LET'S GET STARTED!"))
	bubble_add_bookend_text([
		"[center]" + atr("If you haven't completed the previous tours in this series, quit to return to the menu and complete them in order to get the expected results.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("In this tour, you learn how to manipulate individual frames in the [b]SpriteFrames[/b] editor.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("You create a blinking idle animation by adjusting frame durations, reordering frames, and copying and pasting frames.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.do_wink())


func part_010_start() -> void:
	var layout_root: Control = EditorInterfaceAccess.get_node(EditorNodePoints.LAYOUT_ROOT)
	var canvas_item_editor: Control = EditorInterfaceAccess.get_node(EditorNodePoints.CANVAS_ITEM_EDITOR)
	var filesystem_tree: Tree = EditorInterfaceAccess.get_node(EditorNodePoints.FILE_SYSTEM_TREE)

	var sprite_frames_animations_list: Tree = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_LIST)
	var sprite_frames_animations_toolbar_add_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR_ADD_BUTTON)
	var sprite_frames_frames_list: ItemList = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST)
	var sprite_frames_frames_toolbar_play_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON)
	var sprite_frames_frames_toolbar_frame_duration_edit: Control = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_FRAME_DURATION_EDIT)
	var sprite_frames_frames_toolbar_copy_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_COPY_BUTTON)
	var sprite_frames_frames_toolbar_paste_button: Button = EditorInterfaceAccess.get_node(EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PASTE_BUTTON)

	bubble_set_title(atr("Creating a new animation"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_TOOLBAR_ADD_BUTTON])
	bubble_add_text(
		[
			atr("It's common in games to have an idle animation with the character mostly standing still and blinking occasionally. That's what we'll create in this tour."),
			atr("Click the %s [b]New Animation[/b] button at the top left of the editor.") % [bbcode_generate_icon_image_by_name("New")],
		],
	)
	bubble_add_task_press_button(sprite_frames_animations_toolbar_add_button, atr("Add Animation"))
	complete_step()

	bubble_set_title(atr("Renaming the new animation"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.CENTER_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_ANIMATIONS_LIST])
	bubble_add_text(
		[
			atr("Animations are created with the default name [b]new_animation[/b]. This could be clearer so let's rename it."),
			atr("Click on [b]new_animation[/b] in the animation list to rename it. Type [b]idle[/b] and press Enter."),
		],
	)
	bubble_add_task(
		atr("Rename [b]new_animation[/b] to [b]idle[/b]"),
		1,
		func(_task: Task) -> int:
			var root = sprite_frames_animations_list.get_root()
			if root == null:
				return 0

			for item in Utils.filter_tree_items(root, func(ti: TreeItem) -> bool: return true):
				if item.get_text(0) == "idle":
					return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("The idle animation frames"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_filesystem_paths(["res://assets/lucy/idle/idle.png", "res://assets/lucy/idle/blinking.png"], true)
	bubble_add_text(
		[
			atr("For the idle animation, we'll use two frames to make the character blink occasionally: one where the character is standing with open eyes and one where her eyes are closed."),
			atr("In the [b]FileSystem[/b] dock, find and select the idle animation images ([b]idle.png[/b] and [b]blinking.png[/b]). You can press the [b]Ctrl[/b] key ([b]Cmd[/b] on macOS) before clicking to add a file to the selection."),
		],
	)
	bubble_add_task(
		atr("Select the [b]blinking.png[/b] and [b]idle.png[/b] files in the [b]FileSystem[/b] dock"),
		2,
		func(_task: Task) -> int:
			var selected_paths = EditorInterface.get_selected_paths()

			# This will fail the task in case the user has selected too many
			# files. They should select just the idle and blinking frames.
			var selected_count: int = selected_paths.size()
			if selected_count > 2:
				return selected_count

			var matching_count := 0
			if selected_paths.has("res://assets/lucy/idle/idle.png"):
				matching_count += 1
			if selected_paths.has("res://assets/lucy/idle/blinking.png"):
				matching_count += 1
			return matching_count
	)
	complete_step()

	bubble_set_title(atr("Adding the idle frames"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_LEFT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_filesystem_paths(["res://assets/lucy/idle/idle.png", "res://assets/lucy/idle/blinking.png"], false)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST])
	bubble_add_text(
		[
			atr("Drag and drop the selected idle images into the [b]Frames View[/b] of the SpriteFrames editor."),
			atr("You should end with two frames in the [b]Frames View[/b]: one for the standing pose and one for the blinking pose."),
		],
	)
	bubble_add_task(
		atr("Add the standing and blinking frames to the animation."),
		1,
		func(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if animated_sprite.sprite_frames.has_animation("idle") and animated_sprite.sprite_frames.get_frame_count("idle") == 2:
				var textures := [
					animated_sprite.sprite_frames.get_frame_texture("idle", 0),
					animated_sprite.sprite_frames.get_frame_texture("idle", 1),
				]
				if textures.has(TEXTURE_IDLE) and textures.has(TEXTURE_BLINKING):
					return 1
			return 0
	)
	mouse_click()
	mouse_move_by_callable(
		get_tree_item_center_by_path.bind(filesystem_tree, "res://assets/lucy/idle/idle.png"),
		get_control_global_center.bind(sprite_frames_frames_list),
	)
	mouse_click()
	complete_step()

	bubble_set_title(atr("Reordering the frames"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST])
	bubble_add_text(
		[
			atr("The frames were added based on their order in the [b]FileSystem[/b] dock: the blinking frame first, and the standing frame second."),
			atr("For our idle animation, we need to swap them: the standing pose should be frame [b]0[/b] (the first frame), and the blinking pose frame [b]1[/b] (the second frame)."),
			atr("You can reorder the frames by dragging and dropping them within the [b]Frames View[/b]."),
		],
	)
	bubble_add_task(
		atr("Ensure the standing pose is frame [b]0[/b] and the blinking pose is frame [b]1[/b]"),
		1,
		func(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			var frames_are_correct := (
				animated_sprite.sprite_frames.get_frame_count("idle") == 2 and
				animated_sprite.sprite_frames.get_frame_texture("idle", 0) == TEXTURE_IDLE and
				animated_sprite.sprite_frames.get_frame_texture("idle", 1) == TEXTURE_BLINKING
			)
			return 1 if frames_are_correct else 0
	)
	complete_step()

	bubble_set_title(atr("Previewing the animation"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON])
	bubble_add_text(
		[
			atr("Good job! Now, click the %s [b]Play[/b] icon to preview the animation.") % [bbcode_generate_icon_image_by_name("Play")],
			atr("As both frames have the same duration, the result looks off: the character blinks continuously."),
			atr("Instead, we want the character to only blink occasionally, so we need to adjust the timing of these frames."),
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_play_button, atr("Play the animation."))
	complete_step()

	bubble_set_title(atr("Adjusting individual frame duration"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([
		EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST,
		EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_FRAME_DURATION_EDIT,
	])
	bubble_add_text(
		[
			atr("We can adjust the duration of individual frames using the [b]Frame Duration[/b] field in the toolbar above the frames view."),
			atr("In the [b]Frames View[/b], select the frame [b]0[/b] (the standing pose)."),
			atr("With the frame selected, head to the [b]Frame Duration[/b] field at the top right of the SpriteFrames editor."),
			atr("Change the value from [b]1.0[/b] to [b]20.0[/b] and press [b]Enter[/b]. This makes this frame stay on screen 20 times longer than the default duration."),
		],
	)
	bubble_add_task(
		atr("Select frame [b]0[/b] (the standing pose) in the [b]Frames View[/b]"),
		1,
		func(_task: Task) -> int:
			var selected_items := sprite_frames_frames_list.get_selected_items()
			if selected_items.size() == 1 and selected_items[0] == 0:
				return 1
			return 0
	)
	bubble_add_task(
		atr("Change the [b]Frame Duration[/b] of frame [b]0[/b] to [b]20.0[/b]"),
		1,
		func(_task: Task) -> int:
			var animated_sprite := get_animated_sprite_node()
			if (
				is_equal_approx(animated_sprite.sprite_frames.get_frame_duration("idle", 0), 20.0) and
				is_equal_approx(animated_sprite.sprite_frames.get_frame_duration("idle", 1), 1.0)
			):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Previewing the adjusted animation"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON])
	bubble_add_text(
		[
			atr("Click the %s [b]Play[/b] button again to preview the animation with the adjusted timing.") % [bbcode_generate_icon_image_by_name("Play")],
			atr("Now the character stays in the standing pose for much longer and only blinks occasionally. This is more natural!"),
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_play_button, atr("Play the animation."))
	complete_step()

	bubble_set_title(atr("Creating a blinking pattern"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST])
	bubble_add_text(
		[
			atr("Now let's make the character blink twice in a row before returning to the long idle pose. It'll make the animation nicer and it'll teach you how to copy and paste frames."),
			atr("First, we have to select the frames we want to copy."),
			atr("Click on the first frame, then hold [b]Shift[/b] and click on the second frame to select both frames."),
		],
	)
	bubble_add_task(
		atr("Select both animation frames"),
		2,
		func(_task: Task) -> int:
			return sprite_frames_frames_list.get_selected_items().size()
	)
	complete_step()

	bubble_set_title(atr("Pasting frames"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([
		EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST,
		EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_COPY_BUTTON,
	])
	bubble_add_text(
		[
			atr("With both frames selected, click the %s [b]Copy Frames[/b] button above the [b]Frames View[/b] to copy the frames in the clipboard.") % [bbcode_generate_icon_image_by_name("ActionCopy")],
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_copy_button, "Copy Frames")
	complete_step()

	bubble_set_title(atr("Pasting frames"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([
		EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST,
		EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PASTE_BUTTON,
	])
	bubble_add_text(
		[
			atr("Now click the %s [b]Paste Frames[/b] button. This duplicates the copied frames and inserts them at the end of the animation.") % [bbcode_generate_icon_image_by_name("ActionPaste")],
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_paste_button, "Paste Frames")
	complete_step()

	bubble_set_title(atr("The updated animation"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON])
	bubble_add_text(
		[
			atr("Click the %s [b]Play[/b] button to preview the animation.") % [bbcode_generate_icon_image_by_name("Play")],
			atr("Copying and pasting the frames duplicated our animation. The character waits for a long time, blinks, and repeats the pattern."),
			atr("We can adjust the third frame's duration to make the character blink twice in a row."),
		],
	)
	complete_step()

	bubble_set_title(atr("Changing the second idle pose duration"))
	bubble_move_and_anchor(canvas_item_editor, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([
		EditorNodePoints.SPRITE_FRAMES_FRAMES_LIST,
		EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_FRAME_DURATION_EDIT,
	])
	bubble_add_text(
		[
			atr("Click on frame [b]2[/b] (the second standing pose) to select it. Then, change the [b]Frame Duration[/b] from [b]20.0[/b] to [b]2.0[/b]."),
			atr("This will result in a much shorter idle pose and make the character blink twice in a row before returning to the long idle pose."),
		],
	)
	bubble_add_task(
		atr("Select frame [b]2[/b] in the [b]Frames View[/b]"),
		1,
		func(_task: Task) -> int:
			var selected_items := sprite_frames_frames_list.get_selected_items()
			if selected_items.size() == 1 and selected_items[0] == 2:
				return 1
			return 0
	)
	bubble_add_task(
		atr("Change the [b]Frame Duration[/b] of frame [b]2[/b] to [b]2.0[/b]"),
		1,
		func(_task: Task) -> int:
			if sprite_frames_frames_list.is_anything_selected() and is_equal_approx(sprite_frames_frames_toolbar_frame_duration_edit.value, 2.0):
				return 1
			return 0
	)
	complete_step()

	bubble_set_title(atr("Previewing the idle animation"))
	bubble_move_and_anchor(layout_root, Bubble.At.BOTTOM_RIGHT)
	bubble_set_avatar_at(Bubble.AvatarAt.LEFT)
	highlight_editor_nodes([EditorNodePoints.CANVAS_ITEM_EDITOR, EditorNodePoints.SPRITE_FRAMES_FRAMES_TOOLBAR_PLAY_FORWARDS_BUTTON])
	bubble_add_text(
		[
			atr("Click the [b]Play[/b] button to preview the idle animation with the adjusted timing."),
			atr("It looks much nicer, doesn't it?"),
		],
	)
	bubble_add_task_press_button(sprite_frames_frames_toolbar_play_button, atr("Play"))
	complete_step()

	bubble_set_title(atr("Reviewing what we've done"))
	bubble_move_and_anchor(layout_root, Bubble.At.CENTER)
	bubble_set_avatar_at(Bubble.AvatarAt.CENTER)
	bubble_add_text(
		[
			atr("Let's review how we created the idle animation:"),
			"[ul]" +
			atr("Frame [b]0[/b] (the standing pose) lasts 20 frames") + "\n" +
			atr("Frame [b]1[/b] (the first blink) shows briefly for one frame") + "\n" +
			atr("Frame [b]2[/b] (standing pose again) lasts 2 frames") + "\n" +
			atr("Frame [b]3[/b] (blinking again) shows briefly for one frame before the cycle repeats") +
			"[/ul]",
			atr("All it took was 2 textures! By reordering the frames and adjusting their durations, you could create a nice idle animation."),
		],
	)
	complete_step()


func steps_finale() -> void:
	bubble_set_bookend_title(atr("Congratulations!"))
	bubble_add_bookend_text([
		"[center]" + atr("You can now adjust frame durations, reorder frames, and copy and paste them in the [b]SpriteFrames[/b] editor.") + "[/center]",
	], Bubble.BookendTextStyle.RECAP)
	bubble_add_bookend_text([
		"[center]" + atr("Your progress will be saved if you quit now.") + "[/center]",
	], Bubble.BookendTextStyle.KEY)
	bubble_add_bookend_text([
		"[center]" + atr("Head back to GDSchool to continue with this module's lessons whenever you're ready.") + "[/center]",
	], Bubble.BookendTextStyle.INFO)
	queue_command(func() -> void: bubble._avatar.set_expression(Gobot.Expressions.HAPPY))


# Helpers.

## Helper function to get the AnimatedSprite2D node created in this tour from the scene.
func get_animated_sprite_node() -> AnimatedSprite2D:
	var scene_root = EditorInterface.get_edited_scene_root()
	return scene_root as AnimatedSprite2D
