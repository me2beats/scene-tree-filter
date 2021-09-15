tool
extends Resource

const Utils = preload("utils.gd")

var tree:Tree # SceneTreeEditor tree
var filter_by_name:LineEdit
#var plugin:EditorPlugin

var classes = Utils.get_classes_filter_mapping(self, "lower", null)

# why is this here?
func lower(s:String, arg):
	return s.to_lower()
