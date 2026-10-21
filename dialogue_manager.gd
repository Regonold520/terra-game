extends Node3D
class_name DialogueManager

@onready var dialogueBox = Ref.ui.find_child("DialogueBox")
var speaker = null
var dialogueActive = false

func _process(delta: float) -> void:
	if dialogueActive:
		var plr : CharacterBody3D = $"../Player"
		
		if plr.global_position.distance_to(speaker.global_position) > 5:
			quitDialogue()

func initiateDialogue(newSpeaker, id):
	var speakerId = newSpeaker.speakerId
	dialogueBox.show()
	
	if speaker == null:
		dialogueActive = true
		speaker = newSpeaker
		var speakerJson = Ref.parse_json_path("res://dialogue/"+speakerId+"/"+speakerId+"Dialogue.json")
		var textToSpeak = speakerJson[id]
		
		for i in textToSpeak:
			if !dialogueActive:
				return
			
			await speakText(i)
			
		quitDialogue()
	
	
func speakText(text):
	var txt : Label3D = dialogueBox.find_child("Text")
	
	txt.text = ""
	
	for i in text:
		if !dialogueActive:
			return
		
		txt.text += i
		var adder = 0
		if i in [".",",","!","?"]: adder + 0.1
		var waitTime = 0.07 + adder
		
		iconJiggle(waitTime)
		
		await get_tree().create_timer(waitTime).timeout
	await get_tree().create_timer(1).timeout
	
func quitDialogue():
	dialogueBox.hide()
	speaker = null
	dialogueActive = false


@onready var icoTween = create_tween()
func iconJiggle(time):
	icoTween.kill()
	icoTween = create_tween().set_ease(Tween.EASE_OUT)
	
	var icon = dialogueBox.find_child("Icon")
	var baseIcoRot = 4.0
	
	var jiggleRot = randf_range(-2, 2)
	
	icoTween.tween_property(icon, "rotation_degrees:z", baseIcoRot + jiggleRot, time)
