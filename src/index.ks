/**
 * zokugun.lang.timezone.js
 * Version 1.0.0
 * April 27th, 2014
 *
 * Copyright (c) 2014 Baptiste Augrain
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 **/
require|import '@zokugun/lang'
require|import '@zokugun/lang.date'(...)

include './types.ks'

const $days = { // {{{
	su: 'sunday'
	mo: 'monday'
	tu: 'tuesday'
	we: 'wednesday'
	th: 'thursday'
	fr: 'friday'
	sa: 'saturday'
} // }}}

const $zones: Dictionary<Timezone> = {}
const $links: Dictionary<String> = {}
const $rules: Dictionary<Array<Rule>> = {}

func $createRule(items: Array<Dictionary>): Array<Rule> { // {{{
	const rules = []

	for const item in items {
		rules.push(Rule(
			from: item[0]
			to: item[1] + 1
			in: item[2]
			onType: item[3]
			onDayOfWeek: item[4]
			onDayOfMonth: item[5] - 1
			atHour: item[6]
			atTime: item[7]
			saveInHours: item[8]
			saveInMinutes: item[8] * 60
			saveInSeconds: item[8] * 3600
			letters: item[9]
		))
	}

	return rules
} // }}}

func $getLocalCutoverTime(rule: Rule, year: Number, lastAtHour: Number, zrule: ZoneRule): Number ~ ParseError { // {{{
	lateinit const date: Date

	if rule.atTime == 'u' {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour + zrule.offsetHours, zrule.offsetMinutes, zrule.offsetSeconds)
	}
	else if rule.atTime == 's' {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour, 0, 0)
	}
	else {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour, 0, 0)
	}

	return date.getTime()
} // }}}

func $getUTCCutoverTime(rule: Rule, year: Number, zrule: ZoneRule): Number ~ ParseError { // {{{
	lateinit const offset: Number

	if rule.atTime == 'u' {
		offset = 0
	}
	else {
		offset = zrule.offsetInMinutes * 60000
	}

	const date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour, 0, 0)

	return date.getTime() - offset
} // }}}

func $getDSTCutoverDayOfMonth(rule: Rule, year: Number): Number ~ ParseError { // {{{
	const date = new Date(year, rule.in, 1)

	if rule.onType == 0 {
		date.add('day', rule.onDayOfMonth)

		if date.getMonth() != rule.in {
			date.rewind('day', date.getDayOfMonth())
		}
	}
	else if rule.onType == 1 {
		date.add('month', 1).past($days[rule.onDayOfWeek])
	}
	else if rule.onType == 2 {
		date.add('day', rule.onDayOfMonth).futureOrPresent($days[rule.onDayOfWeek])
	}

	return date.getDayOfMonth()
} // }}}

func $getCutover(date: Date, rules: Array<Rule>, zrule: ZoneRule): Cutover? ~ ParseError { // {{{
	let bestRule: Rule? = null
	let bestCutover = Number.MIN_VALUE

	const year = date.getYear()
	const time = date.getTime()

	const crules = []
	for const rule in rules {
		if year >= rule.from && year < rule.to {
			crules.push(rule)
		}
	}

	if date.isUTC() {
		if crules.length == 1 {
			if const cutover = $getUTCCutoverTime(crules.last(), year, zrule) {
				if cutover <= time {
					bestCutover = cutover
					bestRule = crules.last()
				}
			}
		}
		else {
			crules.sort((a, b) => a.in - b.in)

			for const rule in crules {
				const cutover = $getUTCCutoverTime(rule, year - 1, zrule)

				if time >= cutover > bestCutover {
					bestCutover = cutover
					bestRule = rule
				}
			}

			for const rule in crules {
				const cutover = $getUTCCutoverTime(rule, year, zrule)

				if time >= cutover > bestCutover {
					bestCutover = cutover
					bestRule = rule
				}
			}
		}
	}
	else {
		if crules.length == 1 {
			if const cutover = $getLocalCutoverTime(crules.last(), year, 0, zrule) {
				if cutover <= time {
					bestCutover = cutover
					bestRule = crules.last()
				}
			}
		}
		else {
			crules.sort((a, b) => a.in - b.in)

			let lastAtHour = 0

			for const rule in crules {
				const cutover = $getLocalCutoverTime(rule, year - 1, lastAtHour, zrule)

				if time >= cutover > bestCutover {
					bestCutover = cutover
					bestRule = rule
				}

				lastAtHour = rule.saveInHours
			}

			for const rule in crules {
				const cutover = $getLocalCutoverTime(rule, year, lastAtHour, zrule)

				if time >= cutover > bestCutover {
					bestCutover = cutover
					bestRule = rule
				}

				lastAtHour = rule.saveInHours
			}
		}
	}

	if bestRule == null {
		return null
	}
	else {
		return Cutover(
			rule: bestRule
			cutover: bestCutover
			delta: time - bestCutover
		)
	}
} // }}}

func $getRule(date: Date, rules: Array<Rule>, zrule: ZoneRule): Rule? ~ ParseError { // {{{
	if const cutover = $getCutover(date, rules, zrule) {
		return cutover.rule
	}
	else {
		return null
	}
} // }}}

func $getZoneRule(date: Date, rules: Array<ZoneRule>): ZoneRule? { // {{{
	const time = date.getTime()

	for const rule in rules {
		if time < rule.until {
			return rule
		}
	}

	return null
} // }}}

class Timezone {
	private {
		@name: String
		@rules: Array<ZoneRule>
	}
	static {
		lateinit const UTC

		add(zones, links, rules): Void { // {{{
			Dictionary.merge($links, links)

			for const _, name of rules {
				$rules[name] = $createRule(rules[name])
			}

			for const _, name of zones {
				$zones[name] = new Timezone(name, zones[name])
			}
		} // }}}
		get(name: String): Timezone ~ ParseError { // {{{
			if const tz = Timezone.getOrNull(name) {
				return tz
			}
			else {
				throw new ParseError(`Unrecognized timezone \(name.quote())`)
			}
		} // }}}
		getOrNull(name: String): Timezone? { // {{{
			if const tz = $zones[name] {
				return tz
			}
			else if const alias = $links[name] {
				if const tz = $zones[alias] {
					return tz
				}
			}

			return null
		} // }}}
		getOrUTC(name: String): Timezone => Timezone.getOrNull(name) ?? Timezone.UTC
		getTimezoneNames(): Array<String> => Object.keys($zones)
		isTimezone(value: String) => ?$zones[value] || ?$links[value]
	}
	constructor(@name, rules) { // {{{
		@rules = []

		for const rule in rules {
			@rules.push(ZoneRule(
				offsetInMinutes: (rule[0] * 60) + rule[1]
				offsetInSeconds: (rule[0] * 3600) + (rule[1] * 60) + rule[2]
				offsetHours: rule[0]
				offsetMinutes: rule[1]
				offsetSeconds: rule[2]
				name: rule[3]
				format: rule[4]
				until: rule.length == 6 ? rule[5] : Number.MAX_VALUE
			))
		}
	} // }}}
	convertToLocal(date: Date): Date { // {{{
		return date.add('second', this.getUTCOffset(date, true))
	} // }}}
	convertToTimezone(date: Date, name: String): Date ~ ParseError { // {{{
		return this.convertToTimezone(date, Timezone.get(name))
	} // }}}
	convertToTimezone(date: Date, timezone: Timezone): Date { // {{{
		const offset = timezone.getUTCOffset(date.rewind('second', this.getUTCOffset(date, true)), true)

		return date.add('second', offset)
	} // }}}
	convertToUTC(date: Date): Date { // {{{
		return date.rewind('second', this.getUTCOffset(date, true))
	} // }}}
	getAbbreviation(date: Date): String? { // {{{
		if const zrule = $getZoneRule(date, @rules) {
			if ?$rules[zrule.name] {
				if const rule = try $getRule(date, $rules[zrule.name], zrule) {
					return zrule.format.replace('%s', rule.letters)
				}
			}

			return zrule.format.replace('%s', '')
		}
		else {
			return null
		}
	} // }}}
	getCutover(date: Date): Cutover? { // {{{
		if const zrule = $getZoneRule(date, @rules) {
			if const rules = $rules[zrule.name] {
				return try $getCutover(date, rules, zrule)
			}
		}

		return null
	} // }}}
	getDSTOffset(date: Date, inSeconds: Boolean = false): Number { // {{{
		if const zrule = $getZoneRule(date, @rules) {
			if const rules = $rules[zrule.name] {
				if const rule = try $getRule(date, rules, zrule) {
					return inSeconds ? rule.saveInSeconds : rule.saveInMinutes
				}
			}

			return 0
		}
		else {
			return 0
		}
	} // }}}
	getUTCOffset(date: Date, inSeconds: Boolean = false): Number { // {{{
		if const zrule = $getZoneRule(date, @rules) {
			if const rules = $rules[zrule.name] {
				if const rule = try $getRule(date, rules, zrule) {
					return inSeconds ? zrule.offsetInSeconds + rule.saveInSeconds : zrule.offsetInMinutes + rule.saveInMinutes
				}
			}

			return inSeconds ? zrule.offsetInSeconds : zrule.offsetInMinutes
		}
		else {
			return 0
		}
	} // }}}
	isUTC(): Boolean => @name == 'Etc/UTC'
	name(): String => @name
}

include './tz.africa'
include './tz.antarctica'
include './tz.asia'
include './tz.australasia'
include './tz.backward'
include './tz.etcetera'
include './tz.europe'
include './tz.northamerica'
include './tz.southamerica'

Timezone.UTC = try! Timezone.get('Etc/UTC')

export Date, ParseError, Timezone