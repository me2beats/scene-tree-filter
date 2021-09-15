static func get_nodes(node:Node)->Array:
	var nodes = []
	var stack = [node]
	while stack:
		var n = stack.pop_back()
		nodes.push_back(n)
		stack.append_array(n.get_children())
	return nodes

static func find_node_by_class(node:Node, cls:String):
	var stack = [node]
	while stack:
		var n:Node = stack.pop_back()
		if n.get_class() == cls:return n
		stack.append_array(n.get_children())

static func find_child_by_class(node:Node, cls:String):
	for child in node.get_children():
		if child.get_class() == cls:
			return child


static func get_item_children(item:TreeItem)->Array:
	item = item.get_children()
	var children = []
	while item:
		children.append(item)
		item = item.get_next()
	return children


static func get_item_children_rec(item:TreeItem)->Array:
	var items = [item]
	var result = []
	while items:
		item = items.pop_back()
		result.push_back(item)
		var children = get_item_children(item)
		items.append_array(children)
	return result




static func get_item_parents(item:TreeItem)->Array:
	var result: = []
	item = item.get_parent()
	while item:
		result.push_back(item)
		item = item.get_parent()
	return result



static func get_items_all_parents(items:Array):
	var parents = {}
	for i in items:
		i = i as TreeItem
		for j in get_item_parents(i):
			parents[j] = true
	return parents



static func item_node_class_is(cls:String, item:TreeItem, root_node:Node)->bool:
	var nodepath:NodePath = item.get_metadata(0)
	var node:Node = root_node.get_node(nodepath)
	if node.get_class() == cls:
		return true
	return false


static func get_scene_tree_items_by_filter(
	filter_obj:Object,
	filter_method:String,
	filter_arg:String,
	scene_tree:Tree,
	plugin:EditorPlugin,
	items: = []
	):

	var root_item: = scene_tree.get_root()
	if not root_item: return

	var root_node = plugin.get_editor_interface().get_edited_scene_root()
	
	var result: = []
	
	if !items:
		items = get_item_children_rec(root_item)

	for item in items:
		item = item as TreeItem
		if filter_obj.call(filter_method, filter_arg, item, root_node):
			result.push_back(item)

	return result



#todo: shorter name
# items_by_filter - filtered_items?
static func get_items_to_remove_when_filtering_scene_tree(
	filter_obj:Object,
	filter_method:String,
	filter_arg,
	tree:Tree,
	plugin:EditorPlugin
	):
	var items:Array = get_item_children_rec(tree.get_root())
	var items_by_filter:Array = get_scene_tree_items_by_filter(
		filter_obj,
		filter_method,
		filter_arg,
		tree,
		plugin,
		items
		)

	if not items_by_filter:
		return items

	var parents:Dictionary = get_items_all_parents(items_by_filter)
	var filtered_items: = parents
	for i in items_by_filter:
		filtered_items[i] = true
	return arr_minus_dict(items, filtered_items)



static func arr_minus_dict(arr:Array,dict:Dictionary):
	var result: = []
	for i in arr:
		if !i in dict:
			result.push_back(i)
	return result


static func get_classes()->Dictionary:
	var classes = {}
	for i in ClassDB.get_class_list():
		classes[i] = true
	return classes


# todo better name?
static func get_classes_filter_mapping(
	mapping_object:Object,
	mapping_func:String,
	mapping_arg
	)->Dictionary:

	var mapping = {}
	for cls_name in ClassDB.get_class_list():
		var key = mapping_object.call(mapping_func, cls_name, mapping_arg)
		mapping[key] = cls_name
	return mapping

