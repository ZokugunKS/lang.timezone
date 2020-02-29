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
			saveInMilliseconds: item[8] * 3600 * 1000
			letters: item[9]
		))
	}

	return rules
} // }}}

func $getDSTCutoverTime(rule: Rule, year: Number, zrule: ZoneRule): Number ~ ParseError { // {{{
	if const zcache = rule.cache[zrule.name] {
		if const time = zcache[year] {
			return time
		}
	}
	else {
		rule.cache[zrule.name] = {}
	}

	lateinit const offset: Number

	if rule.atTime == 'u' {
		offset = 0
	}
	else {
		offset = zrule.offsetInMinutes * 60000
	}

	const date = new Date(year, rule.in, $getDSTCutoverDayOfMonth(rule, year), rule.atHour, 0, 0)

	const time = date.getTime() - offset

	rule.cache[zrule.name][year] = time

	return time
} // }}}

func $getDSTCutoverDayOfMonth(rule: Rule, year: Number): Number ~ ParseError { // {{{
	const date = new Date(year, rule.in, 1)

	if rule.onType == 0 {
		date.plusDays(rule.onDayOfMonth)

		if date.getMonth() != rule.in {
			date.minusDays(date.getDay())
		}
	}
	else if rule.onType == 1 {
		date.plusMonths(1).past($days[rule.onDayOfWeek])
	}
	else if rule.onType == 2 {
		date.plusDays(rule.onDayOfMonth).futureOrPresent($days[rule.onDayOfWeek])
	}

	return date.getDay()
} // }}}

func $getRule(time: Number, rules: Array<Rule>, zrule: ZoneRule): Rule? ~ ParseError { // {{{
	let bestRule: Rule? = null
	let bestCutover = Number.MIN_VALUE

	const year = $getYear(time)

	const crules = [rule for const rule in rules when year >= rule.from && year < rule.to]

	if crules.length == 1 {
		if const cutover = $getDSTCutoverTime(crules.last(), year, zrule) {
			if cutover <= time {
				bestCutover = cutover
				bestRule = crules.last()
			}
		}
	}
	else {
		crules.sort((a, b) => a.in - b.in)

		for const rule in crules {
			const cutover = $getDSTCutoverTime(rule, year - 1, zrule)

			if time >= cutover > bestCutover {
				bestCutover = cutover
				bestRule = rule
			}
		}

		for const rule in crules {
			const cutover = $getDSTCutoverTime(rule, year, zrule)

			if time >= cutover > bestCutover {
				bestCutover = cutover
				bestRule = rule
			}
		}
	}

	return bestRule
} // }}}

func $getYear(time: Number): Number { // {{{
  	const kSecPerDay = 24 * 60 * 60
  	const kMsPerDay = kSecPerDay * 1000
	const kDaysIn4Years = 4 * 365 + 1
	const kDaysIn100Years = 25 * kDaysIn4Years - 1
	const kDaysIn400Years = 4 * kDaysIn100Years + 1
	const kDays1970to2000 = 30 * 365 + 7
	const kDaysOffset = 1000 * kDaysIn400Years + 5 * kDaysIn400Years - kDays1970to2000
	const kYearsOffset = 400000

	auto days = Math.floor(time / kMsPerDay)

	days += kDaysOffset
	auto year = 400 * Math.floor(days / kDaysIn400Years) - kYearsOffset
	days %= kDaysIn400Years

	days += days > 0 ? -1 : 0
	auto yd1 = Math.floor(days / kDaysIn100Years)
	days %= kDaysIn100Years
	year += 100 * yd1

	days++
	auto yd2 = Math.floor(days / kDaysIn4Years)
	days %= kDaysIn4Years
	year += 4 * yd2

	days += days > 0 ? -1 : 0
	auto yd3 = Math.floor(days / 365)
	year += yd3

	return year
} // }}}

func $getZoneRule(time: Number, rules: Array<ZoneRule>): ZoneRule? { // {{{
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
				offsetInHours: rule[0]
				offsetInMinutes: (rule[0] * 60) + rule[1]
				offsetInSeconds: (((rule[0] * 60) + rule[1]) * 60) + rule[2]
				offsetInMilliseconds: ((rule[0] * 3600) + (rule[1] * 60) + rule[2]) * 1000
				offsetHours: rule[0]
				offsetMinutes: rule[1]
				offsetSeconds: rule[2]
				name: rule[3]
				format: rule[4]
				until: rule.length == 6 ? rule[5] : Number.MAX_VALUE
			))
		}
	} // }}}
	getAbbreviation(date: Date): String? => this.getAbbreviation(date.getTime())
	getAbbreviation(time: Number): String? { // {{{
		if const zrule = $getZoneRule(time, @rules) {
			if ?$rules[zrule.name] {
				if const rule = try $getRule(time, $rules[zrule.name], zrule) {
					return zrule.format.replace('%s', rule.letters)
				}
			}

			return zrule.format.replace('%s', '')
		}
		else {
			return null
		}
	} // }}}
	getDSTDifference(time1: Number, time2: Number, timeUnit: TimeUnit = TimeUnit::MINUTES): Number => this.getDSTOffset(time1, timeUnit) - this.getDSTOffset(time2, timeUnit)
	getDSTOffset(date: Date, timeUnit: TimeUnit = TimeUnit::MINUTES): Number => this.getDSTOffset(date.getTime(), timeUnit)
	getDSTOffset(time: Number, timeUnit: TimeUnit = TimeUnit::MINUTES): Number { // {{{
		if const zrule = $getZoneRule(time, @rules) {
			if const rules = $rules[zrule.name] {
				if const rule = try $getRule(time, rules, zrule) {
					switch timeUnit {
						TimeUnit::HOURS => return rule.saveInHours
						TimeUnit::MINUTES => return rule.saveInMinutes
						TimeUnit::SECONDS => return rule.saveInSeconds
						TimeUnit::MILLISECONDS => return rule.saveInMilliseconds
					}
				}
			}
		}

		return 0
	} // }}}
	getUTCOffset(date: Date, timeUnit: TimeUnit = TimeUnit::MINUTES): Number => this.getUTCOffset(date.getTime(), timeUnit)
	getUTCOffset(time: Number, timeUnit: TimeUnit = TimeUnit::MINUTES): Number { // {{{
		if const zrule = $getZoneRule(time, @rules) {
			if const rules = $rules[zrule.name] {
				if const rule = try $getRule(time, rules, zrule) {
					switch timeUnit {
						TimeUnit::HOURS => return zrule.offsetInHours + rule.saveInHours
						TimeUnit::MINUTES => return zrule.offsetInMinutes + rule.saveInMinutes
						TimeUnit::SECONDS => return zrule.offsetInSeconds + rule.saveInSeconds
						TimeUnit::MILLISECONDS => return zrule.offsetInMilliseconds + rule.saveInMilliseconds
					}
				}
			}

			switch timeUnit {
				TimeUnit::HOURS => return zrule.offsetInHours
				TimeUnit::MINUTES => return zrule.offsetInMinutes
				TimeUnit::SECONDS => return zrule.offsetInSeconds
				TimeUnit::MILLISECONDS => return zrule.offsetInMilliseconds
			}
		}

		return 0
	} // }}}
	getUTCTimestamp(time: Number, beforeDSTFallBack: Boolean): Number ~ Error { // {{{
		if const zrule = $getZoneRule(time, @rules) {
			if const rules = $rules[zrule.name] {
				const offset = zrule.offsetInSeconds * 1000

				time -= offset

				const year = $getYear(time)

				const crules = [rule for const rule in rules when year >= rule.from && year < rule.to]

				crules.sort((a, b) => a.in - b.in)

				let nextBestRule: Rule? = null
				let bestRule: Rule? = null
				let bestCutover = Number.MIN_VALUE

				for const rule in crules {
					const cutover = $getDSTCutoverTime(rule, year - 1, zrule)

					if time >= cutover > bestCutover {
						nextBestRule = bestRule

						bestCutover = cutover
						bestRule = rule
					}
				}

				for const rule in crules {
					const cutover = $getDSTCutoverTime(rule, year, zrule)

					if time >= cutover > bestCutover {
						nextBestRule = bestRule

						bestCutover = cutover
						bestRule = rule
					}
				}

				if bestRule.saveInMinutes < nextBestRule.saveInMinutes {
					if time - bestCutover <= Math.max(bestRule.saveInMilliseconds, nextBestRule.saveInMilliseconds) {
						if beforeDSTFallBack {
							time -=nextBestRule.saveInMilliseconds
						}
					}
					else {
						time -= bestRule.saveInMilliseconds
					}
				}
				else {
					if time - bestCutover >= Math.max(bestRule.saveInMilliseconds, nextBestRule.saveInMilliseconds) {
						time -= bestRule.saveInMilliseconds
					}
				}
			}
		}

		return time
	} // }}}
	isUTC(): Boolean => this == Timezone.UTC || @name == 'Etc/UTC'
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

export Date, DateField, Timezone, TimeUnit, WeekField, ParseError