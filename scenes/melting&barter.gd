extends Node

func process_melting():
	if not Global.is_melting_on:
		return
	
	var melting_level = Global.upgrades[Global.upgrade_names[3]] 
	
	for i in range(melting_level): 
		var resource = Global.resource_names[i] 
		for tier in range(Global.TIERS_AMOUNT - 1): 
			var available_amount : Big = Global.resources[resource][tier]
			var converted_amount := available_amount.dividedBy(Big.new(5))
			
			if converted_amount.isGreaterThanOrEqualTo(Big.new(1)): 
				Global.resources[resource][tier].minusEquals(converted_amount.times(Big.new(5)))
				Global.resources[resource][tier + 1].plusEquals(converted_amount)

func process_barter():
	if not Global.is_barter_on:
		return
	
	var barter_level = Global.upgrades[Global.upgrade_names[4]] 
	
	for i in range(barter_level): 
		if i + 1 >= Global.resource_names.size():
			break 
		
		var lower_resource = Global.resource_names[i]
		var higher_resource = Global.resource_names[i + 1]
		
		var available_amount :Big = Global.resources[lower_resource][Global.TIERS_AMOUNT - 1]
		var converted_amount = available_amount.dividedBy(Big.new(5))
		
		if converted_amount.isGreaterThanOrEqualTo(Big.new(1)):
			Global.resources[lower_resource][Global.TIERS_AMOUNT - 1].minusEquals( Big.new((converted_amount.toFloat() * 5) as int) )
			Global.resources[higher_resource][0].plusEquals(Big.new(converted_amount.toFloat() as int))

func _process(_delta: float) -> void:
	process_melting()
	process_barter()
