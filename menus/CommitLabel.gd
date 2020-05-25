extends RichTextLabel

func _ready():
	var file = File.new()
	if not file.file_exists("res://build_commit.txt"):
		self.set_text("no commit found")
		return
	if file.open("res://build_commit.txt", File.READ) != 0:
		self.set_text("unable to read commit")
		return
	var commit = file.get_line()
	self.set_text(commit)
