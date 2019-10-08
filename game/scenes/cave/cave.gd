extends Node2D

func _ready():
	globals.get("player").get_node("droneCamera/rainManager").on_RainAmountChange("none")