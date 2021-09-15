tool
extends CheckBox

const data = preload("data.tres")

func _toggled(button_pressed):
	var lineedit:LineEdit = $"../LineEdit"
	if !button_pressed:
		lineedit.remove_custom_filtering()
	else:
		lineedit.filter(lineedit.text)
