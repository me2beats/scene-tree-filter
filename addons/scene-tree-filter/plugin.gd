tool
extends EditorPlugin

const Utils = preload("utils.gd")
const data = preload("data.tres")
const plugin_data = preload("plugin_data.tres")

var ui = plugin_data.ui

func _enter_tree():
	plugin_data.plugin = self

	var base: = get_editor_interface().get_base_control()
	var scene_dock = base.find_node("Scene", true, false)

	var tree_editor:Control = Utils.find_child_by_class(scene_dock, 'SceneTreeEditor')
	
	var top_bar:HBoxContainer = scene_dock.get_child(0)
	var filter_by_name:LineEdit = Utils.find_child_by_class(top_bar, 'LineEdit')

	data.filter_by_name = filter_by_name

	var tree:Tree = Utils.find_child_by_class(tree_editor, "Tree")
	if not tree: return
	data.tree = tree

	scene_dock.add_child(ui)
	scene_dock.move_child(ui, 1)
	





func _exit_tree():
	ui.get_parent().remove_child(ui)


