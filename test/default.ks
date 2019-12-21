#![bin]
#![error(off)]

extern {
	describe:	func
	it:			func
}

import {
	'chai'		for expect
	'..'
}

describe('default', func() {
	it('getTimezoneNames', func() { // {{{
		expect(Timezone.getTimezoneNames()).to.contain('Europe/Paris')
	}) // }}}

	it('get:', func() { // {{{
		const tz = Timezone.get('Europe/Paris')
		expect(tz).to.exist
		expect(tz).to.be.an('object')
	}) // }}}

	it('getUTCOffset 2000-1-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getUTCOffset(new Date(2000, 1, 1))).to.equal(1 * 60)
	}) // }}}

	it('getUTCOffset 2000-7-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getUTCOffset(new Date(2000, 7, 1))).to.equal(2 * 60)
	}) // }}}

	it('getUTCOffset 2000-3-26T01:59:59 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getUTCOffset(new Date(2000, 3, 26, 1, 59, 59))).to.equal(1 * 60)
	}) // }}}

	it('getUTCOffset 2000-3-26T02:00:00 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getUTCOffset(new Date(2000, 3, 26, 2, 0, 0))).to.equal(2 * 60)
	}) // }}}

	it('getUTCOffset 2000-10-29T02:59:59 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getUTCOffset(new Date(2000, 10, 29, 2, 59, 59))).to.equal(2 * 60)
	}) // }}}

	it('getUTCOffset 2000-10-29T03:00:00 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getUTCOffset(new Date(2000, 10, 29, 3, 0, 0))).to.equal(1 * 60)
	}) // }}}

	it('getUTCOffset 2000-1-1 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2000, 1, 1))).to.equal(-5 * 60)
	}) // }}}

	it('getUTCOffset 2000-7-1 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2000, 7, 1))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-1-1 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2008, 1, 1))).to.equal(-5 * 60)
	}) // }}}

	it('getUTCOffset 2008-7-1 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2008, 7, 1))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-3-9T01:59:59 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2008, 3, 9, 1, 59, 59))).to.equal(-5 * 60)
	}) // }}}

	it('getUTCOffset 2008-3-9T02:00:00 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2008, 3, 9, 2, 0, 0))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-11-2T01:59:59 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2008, 11, 2, 1, 59, 59))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-11-2T02:00:00 America/New_York', func() { // {{{
		const tz = Timezone.get('America/New_York')

		expect(tz.getUTCOffset(new Date(2008, 11, 2, 2, 0, 0))).to.equal(-5 * 60)
	}) // }}}

	it('getUTCOffset 2008-1-1 Australia/Melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		expect(tz.getUTCOffset(new Date(2008, 1, 1))).to.equal(11 * 60)
	}) // }}}

	it('getUTCOffset 2008-7-1 Australia/Melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		expect(tz.getUTCOffset(new Date(2008, 7, 1))).to.equal(10 * 60)
	}) // }}}

	it('getUTCOffset 2008-4-6T02:59:59 Australia/Melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		expect(tz.getUTCOffset(new Date(2008, 4, 6, 2, 59, 59))).to.equal(11 * 60)
	}) // }}}

	it('getUTCOffset 2008-4-6T03:00:00 Australia/Melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		expect(tz.getUTCOffset(new Date(2008, 4, 6, 3, 0, 0))).to.equal(10 * 60)
	}) // }}}

	it('getUTCOffset 2008-10-5T01:59:59 Australia/Melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		expect(tz.getUTCOffset(new Date(2008, 10, 5, 1, 59, 59))).to.equal(10 * 60)
	}) // }}}

	it('getUTCOffset 2008-10-5T02:00:00 Australia/Melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		expect(tz.getUTCOffset(new Date(2008, 10, 5, 2, 0, 0))).to.equal(11 * 60)
	}) // }}}

	it('getUTCOffset 2008-1-1 America/Santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		expect(tz.getUTCOffset(new Date(2008, 1, 1))).to.equal(-3 * 60)
	}) // }}}

	it('getUTCOffset 2008-7-1 America/Santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		expect(tz.getUTCOffset(new Date(2008, 7, 1))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-3-29T23:59:59 America/Santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		expect(tz.getUTCOffset(new Date(2008, 3, 29, 23, 59, 59))).to.equal(-3 * 60)
	}) // }}}

	it('getUTCOffset 2008-3-30T00:00:00 America/Santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		expect(tz.getUTCOffset(new Date(2008, 3, 30, 0, 0, 0))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-10-11T23:59:59 America/Santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		expect(tz.getUTCOffset(new Date(2008, 10, 11, 23, 59, 59))).to.equal(-4 * 60)
	}) // }}}

	it('getUTCOffset 2008-10-12T00:00:00 America/Santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		expect(tz.getUTCOffset(new Date(2008, 10, 12, 0, 0, 0))).to.equal(-3 * 60)
	}) // }}}

	it('getAbbreviation 2000-1-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getAbbreviation(new Date(2000, 1, 1))).to.equal('CET')
	}) // }}}

	it('getAbbreviation 2000-7-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getAbbreviation(new Date(2000, 7, 1))).to.equal('CEST')
	}) // }}}

	/* it('getDSTCutoverDates 2000 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')
		const dates = tz.getDSTCutoverDates(new Date(2000, 0, 1), new Date(2000, 11, 31))

		expect(dates).to.exist
		expect(dates).to.be.an.array
		expect(dates[0]).to.equal('')
		expect(dates[1]).to.equal('')
	}) // }}} */
})
