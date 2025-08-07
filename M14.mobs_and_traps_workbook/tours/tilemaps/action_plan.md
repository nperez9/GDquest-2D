# 1. Reintroduction to tile maps

1. open `res://creating_tilemaps.tscn`
1. add a `TileMapLayer` node
1. duplicate the `TileMapLayer` node
1. [explain layers and layer buttons]
1. click the *Select all layers* button
1. assign the `res://assets/worlds/mushroom_world/mushroom_tileset.tres` resource to the *Tile Set* property
1. select the first `TileMapLayer` node
1. paint a few *Ground* tiles manually
1. select the second `TileMapLayer` node
1. paint a few *Ivy* tiles manually
1. [explain painting with terrains]

# 2. Painting platforms with a terrain

1. open `res://drawing_tilemaps.tscn`
1. add a `TileMapLayer` node
1. assign the `res://assets/worlds/mushroom_world/mushroom_tileset.tres` resource to the *Tile Set* property
1. select the *Terrain* tab in the *TileMap* editor
1. select the *Ground* terrain
1. paint a few platforms with *Connected mode*
1. explain *Path mode*
1. paint a few plants using the *Path mode*
1. [explain the two different auto-tiling painting tools and how the indivudal tiles work under *Terrains* tab]

# 3. Using painting, erase, and selection tools + copy and paste

1. open `res://drawing_tilemaps.tscn`
1. select the `TileMapLayer` node
1. select the *Tile* tab in the *TileMap* editor
1. [explain the main tools: painting, erasing, and selection tools + copy paste one by one]
1. select the *Paint Tool* and draw some tiles
1. toggle on the *Erase Tool* and erase some tiles
1. [explain how the *Erase Tool* modifies the current drawing tool]
1. select the *Selection Tool*
1. select a few tiles in the viewport and move them around with click-drag
1. with the tiles still selected copy-paste to see how it works

# 4. Creating multiple tile map layers to create multiple visual layers in a level

1. open `res://editing_tilemap_layers.tscn`
1. add `TileMapLayer` node
1. duplicate the `TileMapLayer` node
1. duplicate the `TileMapLayer` node
1. click the *Select all layers* button
1. assign `res://assets/worlds/mushroom_world/mushroom_tileset.tres` resource to *Tile Set*
1. [explain layers]
1. select the first `TileMapLayer` node
1. paint using *Ground* terrain
1. select the second `TileMapLayer` node
1. paint using the *Underground* terrain
1. select the third `TileMapLayer` node
1. paint using the *Ivy* terrain
1. move `TileMapLayer2` at the top of the hierarchy
1. [explore the other layer buttons]

# 5. Using tile patterns

1. open `res://drawing_tilemaps.tscn`
1. select the `TileMapLayer`
1. [explain patterns]
1. select the *Patterns* tab in the *TileMap* editor
1. select one platform in the canvas viewport
1. drag-drop to *Patterns* tab
1. [explain copy-paste too]
1. select another platform in the canvas viewport
1. copy-paste to *Patterns* tab
1. select one of the newly added patterns
1. draw with it in the viewport
1. to delete a pattern, select it and click the *Delete* keyboard button
