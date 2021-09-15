tool
extends LineEdit

const data = preload("data.tres")
const Utils = preload("utils.gd")

export var success_color:Color = "7fcb50"
export var fail_color:Color = "cb5050"

func _enter_tree():
	var filter_by_name:LineEdit = data.filter_by_name
	if not filter_by_name.is_connected("text_changed", self, "on_filter_by_name_text_changed"):
		filter_by_name.connect("text_changed", self, "on_filter_by_name_text_changed")


func on_filter_by_name_text_changed(new_text:String):
	if !is_checkbox_pressed(): return
	yield(get_tree(), "idle_frame")
	filter(text)


func is_checkbox_pressed():
	var checkbox = $"../CheckBox"
	return checkbox.pressed

func _on_text_changed(new_text:String):
	if !is_checkbox_pressed(): return

	filter(new_text)


func remove_custom_filtering():
	yield(get_tree(), "idle_frame") # _update_tree() doesn't work without it
	var tree_editor:Control = Utils.find_child_by_class(get_parent().get_parent(), 'SceneTreeEditor')
	tree_editor._update_tree()



func filter(text:String):
	if not data.tree: return

	if not text:
		remove_custom_filtering()

	print("filre?")

	if not text.to_lower() in data.classes:
		set("custom_colors/clear_button_color", fail_color)
		return

	set("custom_colors/clear_button_color", success_color)
	
	var tree = data.tree
	
	var root:TreeItem = tree.get_root()
	if not root: return
	
	
	var plugin_data = load("res://addons/scene-tree-filter/plugin_data.tres")
	
	
	# could be optimized - only topmost parents could be returned
	var items_to_remove = Utils.get_items_to_remove_when_filtering_scene_tree(
		Utils,
		'item_node_class_is',
		data.classes[text.to_lower()],
		tree,
		plugin_data.plugin
	)
	
	if root in items_to_remove:
		tree.clear()

	else:
		for item in items_to_remove:
			item = item as TreeItem
			var parent = item.get_parent()		
			if !parent: continue
			parent.remove_child(item)

	tree.update()
