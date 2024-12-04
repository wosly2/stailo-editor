extends Node2D

@export var character_prefab: PackedScene

const consonants = {
	"b":"b",
	"d":"d",
	"f":"f",
	"g":"g",
	"h":"h",
	"j":"j",
	"k":"k",
	"l":"l",
	"m":"m",
	"n":"n",
	"p":"p",
	"r":"r",
	"s":"s",
	"t":"t",
	"v":"v",
	"w":"w",
	"y":"y",
	"z":"z",
	"-":"th",
	"=":"dh",
	"[":"sh",
	"]":"ch",
	"*":"ng",
	"@":"@"
}

var vowels = {
	"1":"ae",
	"2":"ai",
	"3":"ee",
	"4":"oh",
	"5":"oo",
	"6":"ah",
	"7":"ih",
	"8":"eh",
	"9":"uh",
	"0":"",
}

#@onready var body = [
	#[
		#$TextStart.global_position,
		#[
			#{"consonant":"h", "vowel":"eh", "reverse":false, "is_space":false}, # heh
			#{"consonant":"l", "vowel":"oh", "reverse":false, "is_space":false}, # loh
			#{"consonant":"", "vowel":"", "reverse":false, "is_space":true}, # space
			#{"consonant":"w", "vowel":"uh", "reverse":false, "is_space":false}, # wuh
			#{"consonant":"r", "vowel":"", "reverse":false, "is_space":false}, # r
			#{"consonant":"l", "vowel":"", "reverse":false, "is_space":false}, # l
			#{"consonant":"d", "vowel":"", "reverse":false, "is_space":false}, # d
		#]
	#]
#]

@onready var body = text_to_body("h.eh.-l.oh.-space-w.uh.-r..-l..-d..", $TextStart.global_position)

func get_length(character) -> int:
	return 32 + (16 if character["vowel"] in ["ae", "ah"] else 0)

func render_text(body):
	$GUI/Output.text = body_to_text(body)
	for child in $Characters.get_children():
			child.queue_free()
			#print("Removed child from Characters")
	for text in body:
		var render_pos = text[0]
		for character in text[1]:
			var char_scene = character_prefab.instantiate()
			char_scene.character = character
			$Characters.add_child(char_scene)
			render_pos.x += (16 if character["vowel"] in ["eh", "ee"] else 0)
			char_scene.global_position = render_pos
			render_pos.x += get_length(character) + 2
			#print("Added character "+str(character)+" at ", render_pos)
		$Cursor.global_position = render_pos

func _ready() -> void:
	render_text(body)
	$GUI/Error.text = ""
	$Cursor/AnimatedSprite2D.play()
	$InputPopup/VBoxContainer/TextEdit.text = body_to_text(body)

func _on_submit_pressed() -> void:
	var cons = $GUI/Consonant.text
	var vowl = $GUI/Vowel.text
	var rev = $GUI/Reverse.is_pressed()
	if cons in consonants.values():
		if vowl in vowels.values():
			body[-1][1].append({
				"consonant":cons,
				"vowel":vowl,
				"reverse":rev,
				"is_space":false,
			})
			$GUI/Error.text = ""
		else:
			$GUI/Error.text = "Unknown Vowel!"
	else:
		$GUI/Error.text = "Unknown Consonant!"
	render_text(body)


func _on_backspace_pressed() -> void:
	body[-1][1].remove_at(len(body[-1][1])-1)
	render_text(body)

func _on_clear_pressed() -> void:
	body[-1][1] = []
	render_text(body)

func _on_newline_pressed() -> void:
	body.append([Vector2(body[-1][0].x, body[-1][0].y + 64), []])
	render_text(body)

func _on_subtract_line_pressed() -> void:
	if not len(body[-1][1]) > 0:
		body.remove_at(len(body)-1)
		$GUI/Error.text = ""
		render_text(body)
	else:
		$GUI/Error.text = "This line has text!"

func body_to_text(body) -> String:
	var output = ""
	for i in range(len(body)):
		for j in range(len(body[i][1])):
			var char = body[i][1][j]
			var cout = char["consonant"]+"."+char["vowel"]+(".rev" if char["reverse"] else ".")
			if char["is_space"]:
				cout = "space"
			output += cout
			if i < len(body[i][1][j])-1:
				output += "-"
		if i < len(body)-1:
			output += "\n"
	return output

func text_to_body(text: String, render_pos: Vector2) -> Array:
	# Convert text back to body format
	if text == "":
		return []
	
	var body = []
	var lines = text.split("\n")
	for line in lines:
		var output_line = []
		var symbols = line.split("-")
		for symbol in symbols:
			if symbol == "space":
				output_line.append({
					"consonant": "",
					"vowel": "",
					"reverse": false,
					"is_space": true
				})
			else:
				var char = symbol.split(".")
				# Validate that the format contains at least consonant and vowel
				if len(char) < 2:
					push_error("Invalid symbol format: %s" % symbol)
					continue
				output_line.append({
					"consonant": char[0],
					"vowel": char[1],
					"reverse": "rev" in symbol,
					"is_space": false
				})
		# Append line with its position
		body.append([render_pos, output_line])
		render_pos.y += 64  # Adjust render position for the next line
	return body

func _on_use_cursor_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Cursor.show()
	else:
		$Cursor.hide()


func _on_add_space_pressed() -> void:
	body[-1][1].append({
		"consonant":"",
		"vowel":"",
		"reverse":false,
		"is_space":true,
	})
	render_text(body)

func _on_edit_manually_pressed() -> void:
	$InputPopup.global_position = Vector2(0, 0)
	for child in $Characters.get_children():
		child.hide()
	$Cursor.hide()
	$InputPopup/VBoxContainer/TextEdit.text = body_to_text(body)


func _on_cancel_pressed() -> void:
	$InputPopup.global_position = Vector2(10000, 10000)
	for child in $Characters.get_children():
		child.show()
	$Cursor.show()


func _on_submit_text_pressed() -> void:
	$InputPopup.global_position = Vector2(10000, 10000)
	for child in $Characters.get_children():
		child.show()
	$Cursor.show()
	body = text_to_body($InputPopup/VBoxContainer/TextEdit.text, $TextStart.global_position)
	render_text(body)
