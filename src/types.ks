#![rules(dont-assert-new-struct)]

struct Rule {
	from: Number
	to: Number
	in: Number
	onType: Number
	onDayOfWeek: String
	onDayOfMonth: Number
	atHour: Number
	atTime: String
	saveInHours: Number
	saveInMilliseconds: Number
	saveInMinutes: Number
	saveInSeconds: Number
	letters: String
	cache: Dictionary	= {}
}

struct ZoneRule {
	offsetInHours: Number
	offsetInMilliseconds: Number
	offsetInMinutes: Number
	offsetInSeconds: Number
	offsetHours: Number
	offsetMinutes: Number
	offsetSeconds: Number
	name: String
	abbr: {
		type: Number
		format: String?
		value: String?
		values: Array<String>?
	}
	until: Number
}