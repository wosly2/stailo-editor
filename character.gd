extends Node2D

@export var character = {
	"consonant": "g",
	"vowel": "ee",
	"reverse": true,
}

func format(character=character):
	$Consonant.animation = character["consonant"]
	$Vowel.animation = character["vowel"]
	$Reverse.hide()
	if character["reverse"]:
		$Reverse.show()
	$Reverse.position = $VowelTop.position
	var vowel = character["vowel"]
	if vowel in ["ih", "ai"]:
		$Vowel.position = $VowelTop.position
		$Reverse.position = $ReverseTop.position
	if vowel in ["ee", "eh"]:
		$Vowel.position = $VowelLeft.position
	if vowel in ["ah", "ae"]:
		$Vowel.position = $VowelRight.position
	if vowel in ["oh", "uh", "oo"]:
		$Vowel.position = $VowelBottom.position

func _ready() -> void:
	format()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
