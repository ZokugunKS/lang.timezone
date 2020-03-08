#![bin]

extern console

import '@zokugun/lang'
import '@zokugun/lang.date'(...)
import 'fs'
import 'path'

const $months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

func compileLink(data, region) { // {{{
	region.links[data[2]] = data[1]
} // }}}

func compileRegion(data: String) { // {{{
	const region = {
		links: {}
		rules: {}
		zones: {}
	}

	let line, lastZone, rule
	let distribution = null

	for line in data.lines() {
		if (line = line.trim()).length != 0 && line[0] != '#' {
			if line.startsWith('Rule') {
				distribution = compileRule(line.split(/\s+/), region, distribution)
			}
			else if line.startsWith('Link') {
				compileLink(line.split(/\s+/), region)
			}
			else if line.startsWith('Zone') {
				lastZone = compileZone(line.replace(/\s#.*$/, '').trim().split(/\s+/), region)
			}
			else {
				compileZoneRule(line.replace(/\s#.*$/, '').trim().split(/\s+/), lastZone!!)
			}
		}
	}

	if distribution != null {
		completeDistribution(region, distribution)
	}

	return region
} // }}}

func compileRule(data: Array<String>, region, distribution?) { // {{{
	const name = data[1]

	let rules = region.rules[name]
	if !?rules {
		if distribution != null {
			completeDistribution(region, distribution)
		}

		rules = region.rules[name] = []

		distribution = {
			name
			last: 0
			years: {}
			letters: {}
		}
	}

	const rule = []

	// from
	rule.push(try! data[2].toInt())

	// to
	if data[3] == 'only' {
		rule.push(rule[0])
	}
	else if data[3] == 'max' {
		rule.push(9999)
	}
	else {
		rule.push(try! data[3].toInt())
	}

	// in
	rule.push($months.indexOf(data[5]))

	// on
	if data[6].startsWith('last') {
		rule.push(1)
		rule.push(data[6].substr(4, 2).toLowerCase())
		rule.push(0)
	}
	else if data[6].contains('>=') {
		rule.push(2)
		rule.push(data[6].substr(0, 2).toLowerCase())
		rule.push(try! data[6].substr(5).toInt())
	}
	else {
		rule.push(0)
		rule.push('')
		rule.push(try! data[6].toInt())
	}

	// atHour
	rule.push(try! data[7].substringBefore(':', 0, data[7]).toInt())

	// atTime
	rule.push(data[7].endsWith('u') || data[7].endsWith('g') || data[7].endsWith('z') ? 'u' : data[7].endsWith('s') ? 's' : 'w')

	// save
	rule.push(try! data[8].substringBefore(':', 0, data[8]).toInt())

	// letters
	if data.length >= 10 && data[9] != '-' {
		rule.push(data[9])
	}
	else {
		rule.push('')
	}

	rules.push(rule)

	const d = rule[8] == 1 ? 1 : -1

	distribution.last = rule[1] == 9999 ? rule[0] : rule[1]

	for const i from rule[0] to distribution.last {
		if distribution.years[i]? {
			distribution.years[i] += d
		}
		else {
			distribution.years[i] = d
			distribution.letters[i] = rule[9]
		}
	}

	return distribution
} // }}}

func compileZone(data, region) { // {{{
	let zone = region.zones[data[1]]
	if !?zone {
		zone = region.zones[data[1]] = []
	}

	data.shift()
	data.shift()

	compileZoneRule(data, zone)

	return zone
} // }}}

func compileZoneRule(data: Array<String>, zone) { // {{{
	const rule = []

	// offset
	const info = data[0].split(':')

	auto hours = try! info[0].toInt()

	if data[1] == '1:00' {
		data[1] = '-'
		hours += 1
	}

	rule.push(hours)

	const neg = hours < 0 ? -1 : 1

	if info.length == 1 {
		rule.push(0, 0)
	}
	else {
		rule.push(neg * (try! info[1].toInt()))

		if info.length == 2 {
			rule.push(0)
		}
		else {
			rule.push(neg * (try! info[2].toInt()))
		}
	}

	// rule
	if data[1] == '-' {
		rule.push('')
	}
	else {
		rule.push(data[1])
	}

	// abbr
	if data[2].contains('%s') {
		rule.push(0, data[2])
	}
	else if data[2].contains('/') {
		rule.push(1, data[2].split('/'))
	}
	else {
		rule.push(2, data[2])
	}

	// until
	if data.length > 3 {
		let date: Date

		if data.length == 4 {
			date = new Date(data[3], 1, 1)
		}
		else if data.length == 5 {
			date = new Date(try! data[3].toInt(), $months.indexOf(data[4]), 1)
		}
		else if data.length == 6 {
			date = new Date(try! data[3].toInt(), $months.indexOf(data[4]), try data[5].toInt())
		}
		else if data.length == 7 {
			date = new Date(try! data[3].toInt(), $months.indexOf(data[4]), try data[5].toInt(), try! data[6].substringBefore(':').toInt(), try! data[6].substringAfter(':').toInt())
		}
		else {
			console.log(data)
			return
		}

		rule.push(date.getEpochTime())
	}

	zone.push(rule)
} // }}}

func completeDistribution(region, distribution) { // {{{
	let rules = region.rules[distribution.name]

	for const value, year of distribution.years when value == 1 {
		let iYear = try! year.toInt()
		let y = iYear + 1

		while y <= distribution.last && !?distribution.years[y] {
			y++
		}

		rules.push([iYear + 1, y, 0, 3, '', 0, 0, '', 1, distribution.letters[year]])
	}
} // }}}

func print(zones) { // {{{
	const blocks = []

	for const zone, name of zones {
		const rules = []

		for const i from 0 til zone.length {
			rules.push('\t\t' + JSON.stringify(zone[i]))
		}

		blocks.push('\t"' + name + '": [\n' + rules.join(',\n') + '\n\t]')
	}

	return blocks.join(',\n') + '\n'
} // }}}

for const name in ['africa', 'antarctica', 'asia', 'australasia', 'backward', 'etcetera', 'europe', 'northamerica', 'southamerica'] {
	const region = compileRegion(fs.readFileSync(path.join('tzdata', name), {
		encoding: 'utf8'
	}))

	let text = `Timezone.add({\n`
	text += print(region.zones)
	text += '}, ' + JSON.stringify(region.links, null, '\t') + ', {\n'
	text += print(region.rules)
	text += '})\n'

	fs.writeFileSync(path.join('src', `tz.\(name).ks`), text, {
		encoding: 'utf8'
	})

	console.info(`tz.\(name).ks generated`)
}