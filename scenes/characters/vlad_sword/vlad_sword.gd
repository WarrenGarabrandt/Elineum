extends Node2D

func _ready():
	$SpriteFrame.animation = currentAction + faceDirection
	$SpriteFrame/ShadowFrame.animation = currentAction + faceDirection
	$SpriteFrame.play()
	$SpriteFrame/ShadowFrame.play()

# Next desired input for this character. This is so that either the player input can be passed, or an AI can provide input, depending on what needs doing
@export
var NextDesiredInput: String = ""

# indicates that the play is holding "hold_ground" key, and wishes to turn or attack, but not walk
@export
var HoldGround: bool = false

# Indicates that this character is currently idle (true), or taking an action of some kind (false)
@export
var isIdle: bool = true

# how far does each move advance the character
var distancePerMove = 48
# how fast does the character move (so the feed aren't moon-walking)
var moveSpeed = 90
# what action is the character taking right now
var currentAction = "stand"
# what was the last action + direction the character took, to keep walking animation going
var lastAction = "none"
# how much movement is left in this action before it can return to idle.
var moveRemaining = 0
# direction the character is facing for the current action. Determines direction to move/attack/etc.
var faceDirection = "_s"

func _process(delta):
	if (isIdle):
		#get user's input to see what they want to do.
		if NextDesiredInput == "attack":
			currentAction = "attack"
		elif NextDesiredInput == "move_down":
			if HoldGround:
				currentAction = "stand"
			else:
				currentAction = "walk"
				moveRemaining = distancePerMove
			faceDirection = "_s"
		elif NextDesiredInput == "move_right":
			if HoldGround:
				currentAction = "stand"
			else:
				currentAction = "walk"
				moveRemaining = distancePerMove
			faceDirection = "_e"
		elif NextDesiredInput == "move_left":
			if HoldGround:
				currentAction = "stand"
			else:
				currentAction = "walk"
				moveRemaining = distancePerMove
			faceDirection = "_w"
		elif NextDesiredInput == "move_up":
			if HoldGround:
				currentAction = "stand"
			else:
				currentAction = "walk"
				moveRemaining = distancePerMove
			faceDirection = "_n"
	if isIdle and currentAction == "stand":
		if lastAction != currentAction + faceDirection:
			$SpriteFrame.animation = currentAction + faceDirection
			$SpriteFrame/ShadowFrame.animation = currentAction + faceDirection
			$SpriteFrame.play()
			$SpriteFrame/ShadowFrame.play()
			lastAction = currentAction + faceDirection
	if isIdle and currentAction != "stand":
		#user has chosen to do something. Initiate the action
		var nextAction = currentAction + faceDirection
		if lastAction == nextAction and currentAction == "walk":
			pass
		else:
			lastAction = currentAction + faceDirection
			$SpriteFrame.animation = currentAction + faceDirection
			$SpriteFrame/ShadowFrame.animation = currentAction + faceDirection
			$SpriteFrame.play()
			$SpriteFrame/ShadowFrame.play()
		isIdle = false
	if (!isIdle):
		#an action is underway. continue the animation/move, detect when action is over, and return to Idle state
		if currentAction == "walk":
			var distToMove = moveSpeed * delta
			if moveRemaining < distToMove:
				distToMove = moveRemaining
			moveRemaining -= distToMove
			if faceDirection == "_s":
				position += Vector2(0, distToMove)
			if faceDirection == "_n":
				position += Vector2(0, -distToMove)
			if faceDirection == "_e":
				position += Vector2(distToMove, 0)
			if faceDirection == "_w":
				position += Vector2(-distToMove, 0)
			if moveRemaining <= 0:
				currentAction = "stand"
				isIdle = true

# fired when a non-looping animation completes (attack/hit/falling) so we can go back into Idle state
func _on_sprite_frame_animation_finished():
	currentAction = "stand"
	isIdle = true
