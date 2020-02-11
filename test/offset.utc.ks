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

describe('offset.utc', func() {
	describe('paris', func() { // {{{
		const tz = Timezone.get('Europe/Paris')

		it('2000-3-26T01:59:59', func() { // {{{
			const d = new Date(2000, 3, 26, 0, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(1 * 60)
		}) // }}}

		it('2000-3-26T02:00:00', func() { // {{{
			const d = new Date(2000, 3, 26, 1, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(2 * 60)
		}) // }}}

		it('2000-10-29T02:59:59', func() { // {{{
			const d = new Date(2000, 10, 29, 0, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(2 * 60)
		}) // }}}

		it('2000-10-29T03:00:00', func() { // {{{
			const d = new Date(2000, 10, 29, 1, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(1 * 60)
		}) // }}}
	}) // }}}

	describe('ny', func() { // {{{
		const tz = Timezone.get('America/New_York')

		it('2008-3-9T01:59:59', func() { // {{{
			const d = new Date(2008, 3, 9, 6, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('2008-3-9T02:00:00', func() { // {{{
			const d = new Date(2008, 3, 9, 7, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(-4 * 60)
		}) // }}}

		it('2008-11-2T01:59:59', func() { // {{{
			const d = new Date(2008, 11, 2, 6, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(-4 * 60)
		}) // }}}

		it('2008-11-2T02:00:00', func() { // {{{
			const d = new Date(2008, 11, 2, 7, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}
	}) // }}}

	describe('melbourne', func() { // {{{
		const tz = Timezone.get('Australia/Melbourne')

		it('2008-4-6T02:59:59', func() { // {{{
			const d = new Date(2008, 4, 5, 15, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(11 * 60)
		}) // }}}

		it('2008-4-6T03:00:00', func() { // {{{
			const d = new Date(2008, 4, 5, 16, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(10 * 60)
		}) // }}}

		it('2008-10-5T01:59:59', func() { // {{{
			const d = new Date(2008, 10, 4, 15, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(10 * 60)
		}) // }}}

		it('2008-10-5T02:00:00', func() { // {{{
			const d = new Date(2008, 10, 4, 16, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(11 * 60)
		}) // }}}
	}) // }}}

	describe('santiago', func() { // {{{
		const tz = Timezone.get('America/Santiago')

		it('2008-03-29T23:59:59', func() { // {{{
			const d = new Date(2008, 3, 30, 1, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(-3 * 60)
		}) // }}}

		it('2008-03-30T00:00:00', func() { // {{{
			const d = new Date(2008, 3, 30, 3, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(-4 * 60)
		}) // }}}

		it('2008-10-11T23:59:59', func() { // {{{
			const d = new Date(2008, 10, 12, 3, 59, 59)

			expect(tz.getUTCOffset(d)).to.equal(-4 * 60)
		}) // }}}

		it('2008-10-12T00:00:00', func() { // {{{
			const d = new Date(2008, 10, 12, 4, 0, 0)

			expect(tz.getUTCOffset(d)).to.equal(-3 * 60)
		}) // }}}
	}) // }}}
})
