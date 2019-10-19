extends TextEdit

export (String) var filePath = ""

func _ready():
	var names = "Created by:\nGeorge Meisinger\nLindsy Kitsis\nJoshua Robinson\nand Jason Lothamer\n\n"
	text = names + readFile()

func readFile():
	if filePath == "" || filePath == null:
		return ""
	var f = File.new()
	if !f.file_exists(filePath):
		return "file does not exist: '" + str(filePath) + "'"
	f.open(filePath, File.READ)
	var text = f.get_as_text()
	f.close()
	return text
