extends Node

onready var is_mobile : bool = not OS.get_name() in ["Windows", "Flash", "OSX"]

