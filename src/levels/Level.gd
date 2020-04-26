extends Node2D

func _ready():
	$Piece.connect("placed", self, "piece_placed")


func piece_placed(piece_position : Vector2):
	# Swap witch piece at that position
	print(piece_position)
