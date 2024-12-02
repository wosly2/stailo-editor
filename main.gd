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
}

var text = [
	{"consonant":"p", "vowel":"ee", "rev":true}
]

func get_length(character) -> int:
	return 32 + 16 if character["vowel"] in ["eh", "ee", "ae", "ah"] else 0

func render_text(text) -> Vector2:
	pass

func _ready() -> void:
	pass 


func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		var key = char(event.unicode).to_lower()
		print(key)
