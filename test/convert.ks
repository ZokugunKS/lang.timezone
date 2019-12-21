#![bin]
#![error(off)]

extern {
	describe:	func
	it:			func
	console
}

import {
	'chai'		for expect
	'..'
}

describe('convert', func() {
	it('convertToLocal 2000-2-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		const date = tz.convertToLocal(new Date(2000, 1, 31, 23, 0, 0))

		expect(date.getYear()).to.equal(2000)
		expect(date.getMonth()).to.equal(2)
		expect(date.getDayOfMonth()).to.equal(1)
		expect(date.getHours()).to.equal(0)
		expect(date.getMinutes()).to.equal(0)
		expect(date.getSeconds()).to.equal(0)
	}) // }}}

	it('convertToLocal 2000-7-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		const date = tz.convertToLocal(new Date(2000, 6, 30, 22, 0, 0))

		expect(date.getYear()).to.equal(2000)
		expect(date.getMonth()).to.equal(7)
		expect(date.getDayOfMonth()).to.equal(1)
		expect(date.getHours()).to.equal(0)
		expect(date.getMinutes()).to.equal(0)
		expect(date.getSeconds()).to.equal(0)
	}) // }}}

	it('convertToUTC 2000-2-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		const date = tz.convertToUTC(new Date(2000, 2, 1, 0, 0, 0))

		expect(date.getYear()).to.equal(2000)
		expect(date.getMonth()).to.equal(1)
		expect(date.getDayOfMonth()).to.equal(31)
		expect(date.getHours()).to.equal(23)
		expect(date.getMinutes()).to.equal(0)
		expect(date.getSeconds()).to.equal(0)
	}) // }}}

	it('convertToUTC 2000-7-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		const date = tz.convertToUTC(new Date(2000, 7, 1, 0, 0, 0))

		expect(date.getYear()).to.equal(2000)
		expect(date.getMonth()).to.equal(6)
		expect(date.getDayOfMonth()).to.equal(30)
		expect(date.getHours()).to.equal(22)
		expect(date.getMinutes()).to.equal(0)
		expect(date.getSeconds()).to.equal(0)
	}) // }}}

	it('convertToTimezone 2000-2-1 Europe/Paris America/New_York', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		const date = tz.convertToTimezone(new Date(2000, 2, 1, 0, 0, 0), 'America/New_York')

		expect(date.getYear()).to.equal(2000)
		expect(date.getMonth()).to.equal(1)
		expect(date.getDayOfMonth()).to.equal(31)
		expect(date.getHours()).to.equal(18)
		expect(date.getMinutes()).to.equal(0)
		expect(date.getSeconds()).to.equal(0)
	}) // }}}

	it('convertToTimezone 2000-7-1 Europe/Paris America/New_York', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		const date = tz.convertToTimezone(new Date(2000, 7, 1, 0, 0, 0), 'America/New_York')

		expect(date.getYear()).to.equal(2000)
		expect(date.getMonth()).to.equal(6)
		expect(date.getDayOfMonth()).to.equal(30)
		expect(date.getHours()).to.equal(18)
		expect(date.getMinutes()).to.equal(0)
		expect(date.getSeconds()).to.equal(0)
	}) // }}}
})
