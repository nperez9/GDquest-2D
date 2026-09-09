## Panel that appears when running Godot with a debug flag (see [CLI_OPTION_DEBUG] constant below).
## Provides controls to change the opacity and visibility of the overlays and dimmers,
## as well as a list of available tours.
@tool
extends PanelContainer

const GDTourMetadata := preload("../gdtour_metadata.gd")
const Overlays := preload("../overlays/overlays.gd")
const Tour := preload("../tour.gd")

## If Godot is run with this flag, the tour will be run in debug mode, displaying this debugger panel.
const CLI_OPTION_DEBUG := "--tour-debug"
const DIMMER_GROUP: StringName = "dimmer"

## Emitted when the user clicks "Start tour" in the debugger.
signal tour_start_requested(tour_id: String)

var series_metadata: GDTourMetadata = null
## Reference to the currently active tour running in debug mode.
var tour: Tour = null:
	set(new_tour):
		tour = new_tour
		if tour != null and button_toggle_tour_visible != null:
			button_toggle_tour_visible.disabled = false
			button_toggle_tour_visible.toggled.connect(tour.toggle_visible)

var overlays: Overlays = null

@onready var toggle_dimmers_check_button: CheckButton = %ToggleDimmersCheckButton
@onready var toggle_bubble_check_button: CheckButton = %ToggleBubbleCheckButton
@onready var dimmers_alpha_h_slider: HSlider = %OverlaysAlphaHSlider
@onready var tours_item_list: ItemList = %ToursItemList
@onready var jump_button: Button = %JumpButton
@onready var jump_spin_box: SpinBox = %JumpSpinBox
@onready var button_toggle_tour_visible: CheckButton = %ButtonToggleTourVisible
@onready var button_start_tour: Button = %ButtonStartTour
@onready var debug_mode_check_button: CheckButton = %DebugModeCheckButton

var _debug_mode_toggled_signal: Signal
var _on_cleaned_up: Callable


func setup(
		p_series_metadata: GDTourMetadata,
		p_overlays: Overlays,
		p_tour: Tour,
		p_debug_mode_toggled_signal: Signal,
) -> void:
	series_metadata = p_series_metadata
	overlays = p_overlays
	tour = p_tour
	_debug_mode_toggled_signal = p_debug_mode_toggled_signal
	_debug_mode_toggled_signal.connect(set_is_debug_mode)


func _ready() -> void:
	if not Engine.is_editor_hint() or EditorInterface.get_edited_scene_root() == self:
		return

	_on_cleaned_up = overlays.add_highlight_to_control.bind(self)
	overlays.cleaned_up.connect(_on_cleaned_up)
	toggle_dimmers_check_button.button_pressed = overlays.has_dimmers()
	toggle_dimmers_check_button.toggled.connect(
		func(is_active: bool) -> void:
			overlays.toggle_dimmers(is_active)
			dimmers_alpha_h_slider.editable = is_active
	)
	toggle_bubble_check_button.toggled.connect(
		func(is_toggled: bool) -> void:
			if tour != null:
				tour.bubble.visible = is_toggled
	)
	tours_item_list.item_selected.connect(_on_tours_item_list_item_selected)
	button_start_tour.pressed.connect(_start_selected_tour)
	dimmers_alpha_h_slider.value_changed.connect(_on_overlay_alpha_h_slider_value_changed)
	jump_button.pressed.connect(_jump_to_step)
	debug_mode_check_button.toggled.connect(
		func(is_toggled: bool) -> void:
			_debug_mode_toggled_signal.emit(is_toggled)
	)

	dimmers_alpha_h_slider.editable = toggle_dimmers_check_button.button_pressed
	overlays.add_highlight_to_control(self)
	_on_overlay_alpha_h_slider_value_changed(dimmers_alpha_h_slider.value)
	_update_spinbox_step_count()
	populate_tours_item_list()
	toggle_bubble_check_button.button_pressed = tour != null


func _exit_tree() -> void:
	if not is_instance_valid(overlays): # Safeguards when editing the scene in the editor.
		return

	if overlays.cleaned_up.is_connected(_on_cleaned_up):
		overlays.cleaned_up.disconnect(_on_cleaned_up)
	_on_overlay_alpha_h_slider_value_changed(1.0)
	overlays.remove_highlights_from_control(self)


func _start_selected_tour() -> void:
	var selected := tours_item_list.get_selected_items()
	if selected.size() == 0:
		return

	var index := tours_item_list.get_selected_items()[0]
	var tour_metadata: GDTourMetadata.Tour = tours_item_list.get_item_metadata(index)

	tour_start_requested.emit(tour_metadata.id)


func _on_tours_item_list_item_selected(index: int) -> void:
	button_start_tour.disabled = tours_item_list.get_selected_items().size() == 0


func _on_overlay_alpha_h_slider_value_changed(value: float) -> void:
	get_tree().set_group(DIMMER_GROUP, "modulate", Color(1, 1, 1, value))
	toggle_dimmers_check_button.set_pressed_no_signal(not is_zero_approx(value))


func populate_tours_item_list() -> void:
	tours_item_list.clear()
	for index in series_metadata.tours.size():
		var tour_metadata := series_metadata.tours[index]
		var title := tour_metadata.title
		title = "%s. %s" % [tour_metadata.title_key, tour_metadata.title]
		tours_item_list.add_item(title)
		tours_item_list.set_item_metadata(index, tour_metadata)


func _update_spinbox_step_count() -> void:
	if tour == null:
		jump_spin_box.suffix = "/ 1"
		jump_spin_box.editable = false
		jump_button.disabled = true
	else:
		var max_value := tour.steps.size()
		jump_spin_box.suffix = " / " + str(max_value)
		jump_spin_box.max_value = max_value
		jump_spin_box.editable = true
		jump_button.disabled = false


func _jump_to_step() -> void:
	tour.index = int(jump_spin_box.value - 1)


func set_is_debug_mode(enabled: bool) -> void:
	if debug_mode_check_button != null:
		debug_mode_check_button.button_pressed = enabled


## Called by the plugin when it starts a tour, so the debugger can updates its
## reference and UI.
func on_tour_started(new_tour: Tour) -> void:
	tour = new_tour
	toggle_dimmers_check_button.button_pressed = true
	toggle_bubble_check_button.button_pressed = true
	_update_spinbox_step_count()

	new_tour.bubble.set_is_debug_mode(debug_mode_check_button.button_pressed)
