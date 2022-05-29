extends Node

var template = {
	"title": "test",
	"description": "BlaBla",
	"rarity": "basic",
	"type": "type",
	"increase" : 5,
	"procentile" : 100
}

#-------------------------------------------------------------------------------UPGRADES
#Basic
var moveSpeed = {
	"title": "Movement Speed",
	"description": "Increases your movement speed by 5%",
	"rarity": "basic",
	"type": "stat",
	"increase" : 5,
	"procentile" : 100}
var smgAmmo = {
	"title": "Smg Ammo",
	"description": "Increases your smg ammo clip by 10%",
	"rarity": "basic",
	"type": "stat",
	"increase" : 10,
	"procentile" : 100}
var smgDamage = {
	"title": "Smg Damage",
	"description": "Increases your smg damage by 10%",
	"rarity": "basic",
	"type": "stat",
	"increase" : 10,
	"procentile" : 100}

var basicUpgrades = [moveSpeed, smgAmmo, smgDamage]

#Rare
var udm20 = {
	"title": "UDM-20",
	"description": "A small fast-paced submachine gun",
	"rarity": "rare",
	"type": "weapon",
	"weapon": preload("res://Scenes/Weapons/Smg.tscn")
}

var rareUpgrades = [udm20]

#Epic

var epicUpgrades = []

#Legendary

var legendaryUpgrades = []

var allUpgrades = [basicUpgrades, rareUpgrades, epicUpgrades, legendaryUpgrades]


func apply_upgrade(upgrade):
	match upgrade.type:
		"stat":
			upgrade.procentile += upgrade.increase
			print(upgrade.title + " " + str(upgrade.procentile))
		"weapon":
			GlobalGameHandler.add_weapon(upgrade.weapon)
			print("Gave the " + upgrade.title)
