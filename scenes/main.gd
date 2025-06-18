extends Control

@onready var tax_3_value: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel2/GrayMargin/TaxBox/Gray1Vbox/Tax3Value
@onready var gross_input: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/GrossInput
@onready var payout: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/SalaryDiv2/Payout
@onready var leave_out: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/SalaryDiv2/LeaveOut
@onready var payout_slider: HSlider = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/PayoutSlider
@onready var net_sal_val: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/NetSalBox/NetSalVal
@onready var to_swtq: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/NetSalBox/ToSWTQ
@onready var standard_sal_val: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel1/GrayMargin/Gray1Vbox/StandardSal/StandardSalVal
@onready var netto_minsk_val: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/Column2Rows/GrayPanel3/GrayMargin/CalculatedBox/Gray1Vbox/NettoMinskVal
@onready var to_swtq_val_2: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/Column2Rows/GrayPanel3/GrayMargin/CalculatedBox/Gray1Vbox/ToSWTQVal2
@onready var moms_effekt_val: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/Column2Rows/GrayPanel3/GrayMargin/CalculatedBox/Gray1Vbox/MomsEffektVal

@onready var social_value: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel2/GrayMargin/TaxBox/Gray1Vbox/SocialValue
@onready var vacation_value: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel2/GrayMargin/TaxBox/Gray1Vbox/VacationValue
@onready var tax_2_value: SpinBox = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/WindowAlignment/GrayPanel2/GrayMargin/TaxBox/Gray1Vbox/Tax2Value

@onready var bar_chart: Control = $WindowScroller/WindowMargin/WindowBG2/CalculatorMargin/Columns/Column2Rows/BarMargin/BarChart

var standard_tax
var slider_block: bool
const soc_fee := 0.3142
const vac_save := 0.1440
const moms := 0.2500


# Skattetabell 36 2025
var tax_table_36 = {
	10000: 1304.0 / 10000,
	15000: 2424.0/15000,
	20000: 3784.0/20000,
	25000: 5218.0/25000,
	30000: 6678.0/30000,
	35000: 8137.0/35000,
	40000: 9623.0/40000,
	45000: 11423.0/45000,
	50000: 13223.0/50000,
	55000: 15304.0/55000,
	60000: 18104.0/60000,
	65000: 20904.0/65000,
	70000: 23704.0/70000,
	75000: 26504.0/75000,
	80000: 29304.0/80000,
	80001: 0.37,
	83601: 0.38,
	88401: 0.39,
	93801: 0.40,
	99801: 0.41
}

func _on_gross_input_value_changed(value: float) -> void:
	payout.value = gross_input.value * payout_slider.value
	leave_out.value = gross_input.value * (1-payout_slider.value)
	update_net_sal()
	
func _on_payout_slider_value_changed(value: float) -> void:
	if slider_block == true:
		pass
	else:
		payout.value = gross_input.value * payout_slider.value
		leave_out.value = gross_input.value * (1-payout_slider.value)
		update_net_sal()

func _on_payout_value_changed(value: float) -> void:
	leave_out.value = gross_input.value - value
	slider_block = true
	payout_slider.value = value / gross_input.value
	slider_block = false
	tax_3_value.value = get_closest_value(payout.value)
	update_net_sal()

func _on_leave_out_value_changed(value: float) -> void:
	payout.value = gross_input.value - value
	slider_block = true
	payout_slider.value = 1 - value / gross_input.value
	slider_block = false
	update_net_sal()

func update_net_sal():
	net_sal_val.value = payout.value * (1-tax_3_value.value/100)
	to_swtq.value = leave_out.value * (1 + social_value.value/100 + vacation_value.value/100)
	standard_tax = get_closest_value(gross_input.value)
	standard_sal_val.value = gross_input.value * (1 - standard_tax/100)
	netto_minsk_val.value = standard_sal_val.value - net_sal_val.value
	to_swtq_val_2.value = to_swtq.value
	moms_effekt_val.value = to_swtq.value * (1 + tax_2_value.value/100)

func _on_tax_2_value_value_changed(value: float) -> void:
	update_net_sal()

func get_closest_value(input_value: int):
	var closest_key = null
	var smallest_diff = INF
	
	for key in tax_table_36.keys():
		var diff = abs(input_value - key)
		if diff < smallest_diff:
			smallest_diff = diff
			closest_key = key
	
	return tax_table_36[closest_key]*100
	


func _on_reset_pressed() -> void:
	social_value.value = soc_fee*100
	vacation_value.value = vac_save*100
	tax_2_value.value = moms*100
