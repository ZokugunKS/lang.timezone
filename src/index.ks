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

func $getDSTCutoverTime(rule: Rule, year: Number, lastAtHour: Number, zrule: ZoneRule): Number ~ ParseError { // {{{
	let date: Date

	if rule.atTime == 'u' {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour + zrule.offsetHours, zrule.offsetMinutes, zrule.offsetSeconds)
	}
	else if rule.atTime == 's' {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour, 0, 0)
	}
	else {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour, 0, 0)
	}

	return date.getEpochTime()
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

func $getRule(date: Date, rules: Array<Rule>, zrule: ZoneRule): Rule? ~ ParseError { // {{{
	let bestRule: Rule? = null

	const year = date.getYear()
	const time = date.getEpochTime()

	const crules = []
	for const rule in rules {
		if year >= rule.from && year < rule.to {
			crules.push(rule)
		}
	}

	if crules.length == 1 {
		if (cutover ?= $getDSTCutoverTime(crules.last(), year, 0, zrule)) && cutover <= time {
			bestRule = crules.last()
		}
	}
	else {
		let bestCutover = Number.MIN_VALUE
		let lastAtHour = 0

		for const rule in crules {
			if time >= (cutover = $getDSTCutoverTime(rule, year - 1, lastAtHour, zrule)) > bestCutover {
				bestCutover = cutover
				bestRule = rule
			}

			lastAtHour = rule.saveInHours
		}

		for const rule in crules {
			if time >= (cutover = $getDSTCutoverTime(rule, year, lastAtHour, zrule)) > bestCutover {
				bestCutover = cutover
				bestRule = rule
			}

			lastAtHour = rule.saveInHours
		}
	}

	return bestRule
} // }}}

func $getZoneRule(date: Number, rules: Array<ZoneRule>): ZoneRule? { // {{{
	for const rule in rules {
		if date < rule.until {
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
		add(zones, links, rules) { // {{{
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
		getOrUTC(name: String): Timezone => Timezone.getOrNull(name) ?? try! Timezone.get('Etc/UTC')
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
		if const zrule = $getZoneRule(date.getEpochTime(), @rules) {
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
	getDSTOffset(date: Date, precise: Boolean = false): Number { // {{{
		if const zrule = $getZoneRule(date.getEpochTime(), @rules) {
			if const rules = $rules[zrule.name] {
				if const rule = try $getRule(date, rules, zrule) {
					return precise ? rule.saveInSeconds : rule.saveInMinutes
				}
			}

			return 0
		}
		else {
			return 0
		}
	} // }}}
	getUTCOffset(date: Date, precise: Boolean = false): Number { // {{{
		if const zrule = $getZoneRule(date.getEpochTime(), @rules) {
			if const rules = $rules[zrule.name] {
				if const rule = try $getRule(date, rules, zrule) {
					return precise ? zrule.offsetInSeconds + rule.saveInSeconds : zrule.offsetInMinutes + rule.saveInMinutes
				}
			}

			return precise ? zrule.offsetInSeconds : zrule.offsetInMinutes
		}
		else {
			return 0
		}
	} // }}}
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

export Date, ParseError, Timezone