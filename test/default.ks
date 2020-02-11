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

	it('getAbbreviation 2000-1-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getAbbreviation(new Date(2000, 1, 1))).to.equal('CET')
	}) // }}}

	it('getAbbreviation 2000-7-1 Europe/Paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		expect(tz.getAbbreviation(new Date(2000, 7, 1))).to.equal('CEST')
	}) // }}}
})
