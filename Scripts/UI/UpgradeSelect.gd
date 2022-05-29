extends Control

onready var card1 = $Cards/UpgradeCard1
onready var Title1 = $Cards/UpgradeCard1/Title
onready var Desc1 = $Cards/UpgradeCard1/Description

onready var card2 = $Cards/UpgradeCard2
onready var Title2 = $Cards/UpgradeCard2/Title
onready var Desc2 = $Cards/UpgradeCard2/Description

onready var card3 = $Cards/UpgradeCard3
onready var Title3 = $Cards/UpgradeCard3/Title
onready var Desc3 = $Cards/UpgradeCard3/Description

onready var amount = $Cards/Amount

onready var cards = [[Title1, Desc1],[Title2, Desc2],[Title3, Desc3]]
var rarity : int
var upgrades  = []

var canSelectUpgrades = 0

var rng = RandomNumberGenerator.new()


export (Color) var basic_color = Color.green
export (Color) var rare_color = Color.blue
export (Color) var epic_color = Color.purple
export (Color) var legendary_color = Color.orangered

func _ready():
	upgrades = []
	visible = false

func check_for_amount_of_upgrades():
	rng.randomize()
	var randomAmount = rng.randi_range(0,100)
	if randomAmount <= 80:
		canSelectUpgrades = 1
	elif randomAmount > 80 and randomAmount <= 95:
		canSelectUpgrades = 2
	elif randomAmount > 95:
		canSelectUpgrades = 3
	set_amount_text()

func set_amount_text():
	amount.text = "Choose " + str(canSelectUpgrades)

func switch_upgrades_visibility():
	check_for_amount_of_upgrades()
	set_cards()
	visible = true
	print(upgrades)

func set_cards():
	for card in cards:
		upgrades.append(choose_rarity())
	set_text()

func set_text():
	if upgrades[0] != null:
		Title1.text = upgrades[0].title
		Desc1.text = upgrades[0].description
		choose_color(Title1, upgrades[0])
	if upgrades[1] != null:
		Title2.text = upgrades[1].title
		Desc2.text = upgrades[1].description
		choose_color(Title2, upgrades[1])
	if upgrades[2] != null:
		Title3.text = upgrades[2].title
		Desc3.text = upgrades[2].description
		choose_color(Title3, upgrades[2])
	

func choose_rarity():
	rng.randomize()
	var rarityNumber = rng.randi_range(0,100)
	if rarityNumber <= 60:
		rarity = 0
	elif rarityNumber > 60 and rarity <= 85:
		rarity = 1
	elif rarityNumber > 85 and rarity <=  95:
		rarity = 2
	elif rarityNumber > 95:
		rarity = 3
	var upgrade = choose_upgrade()
	return upgrade

func choose_upgrade():
	rng.randomize()
	if Upgrades.allUpgrades[rarity] != []:
		var randomUpgrade = int(rng.randi_range(0,Upgrades.allUpgrades[rarity].size() - 1))
		if upgrades.has(Upgrades.allUpgrades[rarity][randomUpgrade]):
			choose_upgrade()
		else:
			return Upgrades.allUpgrades[rarity][randomUpgrade]
		

func choose_color(text, upgrade):
	match upgrade.rarity:
		"basic":
			text.set("custom_colors/font_color", basic_color)
		"rare":
			text.set("custom_colors/font_color", rare_color)
		"epic":
			text.set("custom_colors/font_color", epic_color)
		"legendary":
			text.set("custom_colors/font_color", legendary_color)

func apply_upgrade(upgrade, card):
	if upgrade:
		Upgrades.apply_upgrade(upgrade)
		canSelectUpgrades -= 1
		set_amount_text()
		card.visible = false
		if canSelectUpgrades == 0:
			GlobalGameHandler.select_next_level()

func _on_Button1_pressed():
	apply_upgrade(upgrades[0], card1)

func _on_Button2_pressed():
	apply_upgrade(upgrades[1], card2)

func _on_Button3_pressed():
	apply_upgrade(upgrades[2], card3)


func _on_SkipButton_pressed():
	GlobalGameHandler.select_next_level()
