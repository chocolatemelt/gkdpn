extends RichTextLabel

func _ready():
	var output = []
	#OS.execute("git", ["describe"], true, out)
	var exit_code = OS.execute("ls", ["-l", "/tmp"], true, output)
	print(exit_code)
	for line in output:
		print(line)
	self.set_text("lol")
