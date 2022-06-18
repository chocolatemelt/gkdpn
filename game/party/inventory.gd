extends Reference

class_name Inventory

var content = {}

signal item_count_changed(item, amount)


func add(item: Item, amount: int = 1) -> void:
	if item in content:
		content[item] += amount
	else:
		content[item] = 1 if item.unique else amount


func remove(item: Item, amount: int = 1):
	assert(item in content)
	assert(amount <= content[item])

	content[item] -= amount
	if content[item] == 0:
		content.erase(item)
		emit_signal("item_count_changed", item, 0)
	else:
		emit_signal("item_count_changed", item, content[item])
