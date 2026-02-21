# M09 Top Down Movement Workbook

Godot 4.4 educational project teaching 2D top-down movement mechanics. Part of GDQuest's "Learn 2D Gamedev" course.

## Project Structure

```
lessons/       — Core game scripts and scenes (main working area)
assets/        — Sprites, shaders, particles, audio, and support scripts
practices/     — Student exercises (L2, L4, L5, L8)
addons/        — DO NOT MODIFY. Educational framework plugins (gdpractice, gdquest_sparkly_bag, gdquest_theme_utils)
```

## Key Scripts & Relationships

| Script | Extends | Role |
|--------|---------|------|
| `lessons/game_manager.gd` | Node2D | Orchestrates game flow: countdown → gameplay → finish → confetti → reload |
| `lessons/runner.gd` | CharacterBody2D | Player character: WASD input, acceleration/deceleration, animation states |
| `lessons/bouncer.gd` | CharacterBody2D | AI character that follows mouse cursor (same mechanics as runner) |
| `lessons/pause_menu.gd` | Control (@tool) | Pause UI with blur/tint shader, resume/quit buttons |

### Signal Flow

```
CountDown.counting_finished → runner physics enabled
  → Player input drives runner
    → FinishLine.body_entered (runner collides)
      → runner.walk_to() → runner.walked_to
        → FinishLine.pop_confettis()
          → FinishLine.confettis_finished → scene reload
```

### Support Scripts (in assets/)

- `count_down.gd` — Countdown label with tween animation, emits `counting_finished`
- `finish_line.gd` — Area2D with shader visuals and confetti spawning
- `runner_visual.gd` — Multi-part character with AnimationTree (IDLE/WALK/RUN)
- `confettis_area.gd` — Staggered confetti particle spawner
- `cursors.gd` — Dual cursor with collision detection

## Main Scene

`lessons/testo_sceno.tscn` — Uses `game_manager.gd`. Contains: CanvasLayer (CountDown + PauseMenu), Level, Block instances, FinishLine, Bouncer, Runner with Camera2D.

## GDScript Conventions

**Always follow these patterns when writing code for this project:**

- **Typed variables with inference:** `var max_speed := 600.0`
- **Explicit typing for nodes:** `var _runner: Runner = %Runner`
- **Unique name references:** Use `%NodeName` (not `$path/to/node`)
- **@onready for node bindings:** `@onready var _particles := %GPUParticles2D`
- **Private prefix:** Underscore for internal vars/methods (`_runner`, `_physics_process`)
- **Signals:** Declare with `signal name`, emit with `name.emit()`, connect with lambdas
- **@export with ranges:** `@export_range(0, 1.0) var prop := 0.0: set = set_prop`
- **@tool for editor preview:** Combined with `if Engine.is_editor_hint(): return`
- **class_name declarations:** `class_name Runner extends CharacterBody2D`

### Movement Pattern

```gdscript
var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
if direction.length() > 0.0:
    velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
else:
    velocity = velocity.move_toward(Vector2.ZERO, deacceleration * delta)
move_and_slide()
```

### Tween Pattern

```gdscript
var tween := create_tween()
tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
tween.tween_property(self, "property", target_value, duration)
tween.tween_callback(func(): signal.emit())
```

## Input Map

| Action | Keys |
|--------|------|
| `move_left` | A / Left Arrow |
| `move_right` | D / Right Arrow |
| `move_up` | W / Up Arrow |
| `move_down` | S / Down Arrow |
| `ui_cancel` | Escape (pause toggle) |

## Practice Exercises

| Practice | Concepts |
|----------|----------|
| `L2.P1.asteroid_field` | `Input.get_vector()`, basic velocity, `move_and_slide()` |
| `L4.P1.bumping_in_wall` | Collision with static bodies |
| `L5.P1.smooth_game` | `velocity.move_toward()`, `rotate_toward()`, delta time |
| `L8.P1.move_to_mouse` | Tween-based click-to-move, `InputEventMouseButton` |

Solutions live in `addons/gdpractice/practice_solutions/` (hidden during practice).

## Configuration

- **Viewport:** 1920x1080, canvas_items stretch mode
- **Max FPS:** 60
- **Rendering:** GL Compatibility
- **Autoloads:** UITestPanel, Metadata (educational framework)
