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
	saveInMinutes: Number
	saveInSeconds: Number
	letters: String
}

struct ZoneRule {
	offsetInMinutes: Number
	offsetInSeconds: Number
	offsetHours: Number
	offsetMinutes: Number
	offsetSeconds: Number
	name: String
	format: String
	until: Number
}