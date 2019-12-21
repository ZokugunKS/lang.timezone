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

	let line, lastZone
	for line in data.lines() {
		if (line = line.trim()).length != 0 && line[0] != '#' {
			if line.startsWith('Rule') {
				compileRule(line.split(/\s+/), region)
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

	return region
} // }}}

func compileRule(data: Array<String>, region) { // {{{
	let rules = region.rules[data[1]]
	if !?rules {
		rules = region.rules[data[1]] = []
	}

	const rule = []

	rule.push(try! data[2].toInt())

	if data[3] == 'only' {
		rule.push(rule[0])
	}
	else if data[3] == 'max' {
		rule.push(9999)
	}
	else {
		rule.push(try! data[3].toInt())
	}

	rule.push($months.indexOf(data[5]))

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

	rule.push(try! data[7].substringBefore(':', 0, data[7]).toInt())

	rule.push(data[7].endsWith('u') || data[7].endsWith('g') || data[7].endsWith('z') ? 'u' : data[7].endsWith('s') ? 's' : 'w')

	rule.push(try! data[8].substringBefore(':', 0, data[8]).toInt())

	if data.length == 10 && data[9] != '-' {
		rule.push(data[9])
	}
	else {
		rule.push('')
	}

	rules.push(rule)
} // }}}

func compileZone(data, region) { // {{{
	//console.log('zone', data)
	let zone = region.zones[data[1]]
	if !?zone {
		zone = region.zones[data[1]] = []
	}

	data.shift()
	data.shift()

	compileZoneRule(data, zone)

	//console.log(zone)
	return zone
} // }}}

func compileZoneRule(data: Array<String>, zone) { // {{{
	// console.log('zrule', data)
	const rule = []

	const info = data[0].split(':')

	rule.push(try! info[0].toInt())

	if info.length == 1 {
		rule.push(0)
		rule.push(0)
	}
	else {
		rule.push(try! info[1].toInt())

		if info.length == 2 {
			rule.push(0)
		}
		else {
			rule.push(try! info[2].toInt())
		}
	}

	if data[1] == '-' {
		rule.push('')
	}
	else {
		rule.push(data[1])
	}

	rule.push(data[2])

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

	//console.log(rule)
	zone.push(rule)
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
	//console.log(region)

	let text = `Timezone.add({\n`
	text += print(region.zones)
	text += '}, ' + JSON.stringify(region.links, null, '\t') + ', {\n'
	text += print(region.rules)
	text += '})\n'
	//console.log(text)

	fs.writeFileSync(path.join('src', `tz.\(name).ks`), text, {
		encoding: 'utf8'
	})

	console.info(`tz.\(name).ks generated`)
}