/**
 * zokugun.lang.timezone.js
 * Version 1.0.0
 * April 27th, 2014
 *
 * Copyright (c) 2014 Baptiste Augrain
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 **/
extern console

import '@zokugun/lang.date'
import '@zokugun/lang/src/object/merge'

const $days = { // {{{
	su: 'sunday'
	mo: 'monday'
	tu: 'tuesday'
	we: 'wednesday'
	th: 'thursday'
	fr: 'friday'
	sa: 'saturday'
} // }}}

const $zones = {}
const $links = {}
const $rules = {}

func $createRule(data) { // {{{
	const rules = []

	for item in data {
		rules.push({
			from: item[0]
			to: item[1] + 1
			in: item[2] - 1
			onType: item[3]
			onDayOfWeek: item[4]
			onDayOfMonth: item[5] - 1
			atHour: item[6]
			atTime: item[7]
			saveInHours: item[8]
			saveInMinutes: item[8] * 60
			saveInSeconds: item[8] * 3600
			letters: item.length == 10 ? item[9] : ''
		})
	}

	return rules
} // }}}

func $getDSTCutoverTime(rule, year, lastAtHour, zrule) { // {{{
	let date: Date

	if rule.atTime == 'u' {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour + zrule.offsetHours, zrule.offsetMinutes, zrule.offsetSeconds)
	}
	else if rule.atTime == 's' {
		date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour, 0, 0)
	}
	else {
		if rule.saveHours {
			date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour + lastAtHour, 0, 0)
		}
		else {
			date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour, 0, 0)
		}
	}

	return date.getTime()
} // }}}

func $getDSTCutoverDayOfMonth(rule, year) { // {{{
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

func $getRule(date, rules, zrule) { // {{{
	let bestRule = null

	const year = date.getFullYear()
	const time = date.getTime()

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
			if (cutover = $getDSTCutoverTime(rule, year - 1, lastAtHour, zrule)) && cutover > bestCutover && cutover <= time {
				bestCutover = cutover
				bestRule = rule
			}

			lastAtHour = rule.saveInHours
		}

		for const rule in crules {
			if (cutover = $getDSTCutoverTime(rule, year, lastAtHour, zrule)) && cutover > bestCutover && cutover <= time {
				bestCutover = cutover
				bestRule = rule
			}

			lastAtHour = rule.saveInHours
		}
	}

	return bestRule
} // }}}

func $getZoneRule(date, rules) { // {{{
	for const rule in rules {
		if date < rule.until {
			return rule
		}
	}
} // }}}

export class Timezone {
	private {
		_name: String
		_rules: Array
	}
	static {
		add(zones, links, rules) { // {{{
			Object.merge($links, links)

			for const name of rules {
				$rules[name] = $createRule(rules[name])
			}

			for const name of zones {
				$zones[name] = new Timezone(name, zones[name])
			}
		} // }}}
		get(name: String): Timezone? { // {{{
			if $zones[name]? {
				return $zones[name]
			}
			else if $links[name]? && $zones[$links[name]]? {
				return $zones[$links[name]]
			}
			else {
				return null
			}
		} // }}}
		getOrUTC(name: String): Timezone => this.get(name) ?? this.get('Etc/UTC')
		getTimezoneNames(): Array<String> => Object.keys($zones)
		isTimezone(value: String) => ?$zones[value] || ?$links[value]
	}
	constructor(@name, rules) { // {{{
		@rules = []

		for const rule in rules {
			@rules.push({
				offsetInMinutes: (rule[0] * 60) + rule[1]
				offsetInSeconds: (rule[0] * 3600) + (rule[1] * 60) + rule[2]
				offsetHours: rule[0]
				offsetMinutes: rule[1]
				offsetSeconds: rule[2]
				name: rule[3]
				format: rule[4]
				until: rule.length == 6 ? rule[5] : Number.MAX_VALUE
			})
		}
	} // }}}
	convertToLocal(date: Date): Date => date.add('second', this.getUTCOffset(date, true))
	convertToTimezone(date: Date, name: String): Date? { // {{{
		if const timezone = Timezone.get(name) {
			return this.convertToTimezone(date, timezone)
		}
		else {
			return null
		}
	} // }}}
	convertToTimezone(date: Date, timezone: Timezone): Date => date.add('second', timezone.getUTCOffset(date.rewind('second', this.getUTCOffset(date, true)), true))
	convertToUTC(date: Date): Date => date.rewind('second', this.getUTCOffset(date, true))
	getAbbreviation(date: Date): String { // {{{
		const zrule = $getZoneRule(date, @rules)

		if ?$rules[zrule.name] {
			if rule ?= $getRule(date, $rules[zrule.name], zrule) {
				return zrule.format.replace('%s', rule.letters)
			}
		}

		return zrule.format.replace('%s', '')
	} // }}}
	getUTCOffset(date: Date, precise: Boolean = false): Number { // {{{
		const zrule = $getZoneRule(date, @rules)

		if $rules[zrule.name]? {
			if rule ?= $getRule(date, $rules[zrule.name], zrule) {
				return precise ? zrule.offsetInSeconds + rule.saveInSeconds : zrule.offsetInMinutes + rule.saveInMinutes
			}
		}

		return precise ? zrule.offsetInSeconds : zrule.offsetInMinutes
	} // }}}
	name() => @name
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