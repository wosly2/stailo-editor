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
	"\\":"",
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
	"0":""
}

var text = [
	{"consonant":"s", "vowel":"oh", "reverse":false},
	{"consonant":"@", "vowel":"ee", "reverse":false},
	{"consonant":"r", "vowel":"uh", "reverse":true},
	{"consonant":"d", "vowel":"ee", "reverse":false},
]

func get_length(character) -> int:
	return 32 + (16 if character["vowel"] in ["ae", "ah"] else 0)

func render_text(text, render_pos=$TextStart.global_position) -> Vector2:
	for child in $Characters.get_children():
		child.queue_free()
		print("Removed child fromm Characters")
	for character in text:
		var char_scene = character_prefab.instantiate()
		char_scene.character = character
		$Characters.add_child(char_scene)
		render_pos.x += (16 if character["vowel"] in ["eh", "ee"] else 0)
		char_scene.global_position = render_pos
		render_pos.x += get_length(character) + 2
		print("Added character "+str(character)+" at ", render_pos)
	return render_pos

func _ready() -> void:
	render_text(text)
	$GUI/Error.text = ""

func _on_submit_pressed() -> void:
	var cons = $GUI/Consonant.text
	var vowl = $GUI/Vowel.text
	var rev = $GUI/Reverse.is_pressed()
	if cons in consonants.values():
		if vowl in vowels.values():
			text.append({
				"consonant":cons,
				"vowel":vowl,
				"reverse":rev
			})
			$GUI/Error.text = ""
		else:
			$GUI/Error.text = "Unknown Vowel!"
	else:
		$GUI/Error.text = "Unkown Consonant!"
	render_text(text)


func _on_backspace_pressed() -> void:
	text.remove_at(len(text)-1)
	render_text(text)


func _on_clear_pressed() -> void:
	text = []
	render_text(text)
