extends PanelContainer

enum ConnectionState {
	DISCONNECTED, # not yet connected to billing service or was already closed
	CONNECTING, # currently in process of connecting to billing service
	CONNECTED, # currently connected to billing service
	CLOSED, # already closed and shouldn't be used again
}

enum PurchaseState {
	UNSPECIFIED,
	PURCHASED,
	PENDING,
}

const CRYSTALINE_BOLSTS_1_SKU = "crystaline_bolts_1"
const CRYSTALINE_BOLSTS_2_SKU = "crystaline_bolts_2"
const CRYSTALINE_BOLSTS_3_SKU = "crystaline_bolts_3"

# @onready var buy_bolts_button_1: Button = $VBoxContainer/Button
# @onready var buy_bolts_button_2: Button = $VBoxContainer2/Button
# @onready var buy_bolts_button_3: Button = $VBoxContainer3/Button

var payment = null
# var item_purchases = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.billing_resume.connect(_on_billing_resume) # No params
		payment.connected.connect(_on_connected) # No params
		payment.disconnected.connect(_on_disconnected) # No params
		payment.connect_error.connect(_on_connect_error) # Response ID (int), Debug message (string)
		# payment.price_change_acknowledged.connect(_on_price_acknowledged) # Response ID (int)
		payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])
		payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)
		payment.sku_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
		payment.sku_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])
		# payment.purchase_acknowledged.connect(_on_purchase_acknowledged) # Purchase token (string)
		# payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error) # Response ID (int), Debug message (string), Purchase token (string)
		payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
		payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)
		payment.query_purchases_response.connect(_on_query_purchases_response) # Purchases (Dictionary[])

		payment.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Gradle Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")

func show_error(text: String) -> void:
	get_node("/root/Node2D/UI/ErrorPop-up").show_error(text)

func _on_buy_bolts_button_1_pressed():
	if payment == null:
		show_error("IAP not supported")
		return

	var response = payment.purchase(CRYSTALINE_BOLSTS_1_SKU)
	if response.status != OK:
		show_error("Please try again later")

func _on_buy_bolts_button_2_pressed():
	if payment == null:
		show_error("IAP not supported")
		return

	var response = payment.purchase(CRYSTALINE_BOLSTS_2_SKU)
	if response.status != OK:
		show_error("Please try again later")

func _on_buy_bolts_button_3_pressed():
	if payment == null:
		show_error("IAP not supported")
		return

	var response = payment.purchase(CRYSTALINE_BOLSTS_3_SKU)
	if response.status != OK:
		show_error("Please try again later")

func _on_connected():
	payment.querySkuDetails([CRYSTALINE_BOLSTS_1_SKU, CRYSTALINE_BOLSTS_2_SKU, CRYSTALINE_BOLSTS_3_SKU], "inapp") # "subs" for subscriptions

func _on_product_details_query_completed(product_details):
	for available_product in product_details:
		print(available_product)

func _on_product_details_query_error(response_id, error_message, products_queried):
	print("on_product_details_query_error id:", response_id, " message: ",
			error_message, " products: ", products_queried)

func _on_disconnected():
	print("Disconnected from billing service")
	await get_tree().create_timer(10).timeout
	payment.startConnection()

func _on_connect_error(response_id, error_message):
	print("connect_error id:", response_id, " message: ", error_message)

func _query_purchases():
	payment.queryPurchases("inapp") # Or "subs" for subscriptions

func _on_query_purchases_response(query_result):
	if query_result.status == OK:
		for purchase in query_result.purchases:
			_process_purchase(purchase)
	else:
		print("queryPurchases failed, response code: ",
				query_result.response_code,
				" debug message: ", query_result.debug_message)

func _on_billing_resume():
	if payment.getConnectionState() == ConnectionState.CONNECTED:
		_query_purchases()

func _on_purchases_updated(purchases):
	for purchase in purchases:
		_process_purchase(purchase)

func _on_purchase_error(response_id, error_message):
	print("purchase_error id:", response_id, " message: ", error_message)
	show_error("Please try again later")


func _process_purchase(purchase):
	if CRYSTALINE_BOLSTS_1_SKU in purchase.products and purchase.purchase_state == PurchaseState.PURCHASED:
		# Add code to store payment so we can reconcile the purchase token
		# in the completion callback against the original purchase
		# item_purchases.put(purchase.purchase_token, purchase.sku)
		Global.premium_resource += 25
		payment.consumePurchase(purchase.purchase_token)
	
	if CRYSTALINE_BOLSTS_2_SKU in purchase.products and purchase.purchase_state == PurchaseState.PURCHASED:
		# Add code to store payment so we can reconcile the purchase token
		# in the completion callback against the original purchase
		# item_purchases.put(purchase.purchase_token, purchase.sku)
		Global.premium_resource += 75
		payment.consumePurchase(purchase.purchase_token)
	
	if CRYSTALINE_BOLSTS_3_SKU in purchase.products and purchase.purchase_state == PurchaseState.PURCHASED:
		# Add code to store payment so we can reconcile the purchase token
		# in the completion callback against the original purchase
		# item_purchases.put(purchase.purchase_token, purchase.sku)
		Global.premium_resource += 125
		payment.consumePurchase(purchase.purchase_token)

func _on_purchase_consumed(purchase_token):
	_handle_purchase_token(purchase_token, true)

func _on_purchase_consumption_error(response_id, error_message, purchase_token):
	print("_on_purchase_consumption_error id:", response_id,
			" message: ", error_message)
	_handle_purchase_token(purchase_token, false)

# Find the sku associated with the purchase token and award the
# product if successful
func _handle_purchase_token(purchase_token, purchase_successful):
	# check/award logic, remove purchase from tracking list
	if purchase_successful:
		show_error("Purchase successful")
		# var sku = item_purchases.get(purchase_token)
		# if sku == CRYSTALINE_BOLSTS_1_SKU:
		# 	Global.premium_resource += 25
		# elif sku == CRYSTALINE_BOLSTS_2_SKU:
		# 	Global.premium_resource += 75
		# elif sku == CRYSTALINE_BOLSTS_3_SKU:
		# 	Global.premium_resource += 125
	else:
		show_error("Please try again later")
