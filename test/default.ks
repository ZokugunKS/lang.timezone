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
})
