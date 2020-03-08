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
	describe('chicago', func() {
		const tz = Timezone.get('America/Chicago')

		it('1880-1-1', func() { // {{{
			const d = new Date(1880, 1, 1)

			expect(tz.getUTCOffset(d)).to.equal(-350)
		}) // }}}

		it('1890-1-1', func() { // {{{
			const d = new Date(1890, 1, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1940-4-1', func() { // {{{
			const d = new Date(1940, 4, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1940-5-1', func() { // {{{
			const d = new Date(1940, 5, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1940-10-1', func() { // {{{
			const d = new Date(1940, 10, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1942-2-1', func() { // {{{
			const d = new Date(1940, 10, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1942-3-1', func() { // {{{
			const d = new Date(1942, 3, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1943-2-1', func() { // {{{
			const d = new Date(1943, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1944-2-1', func() { // {{{
			const d = new Date(1944, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1945-2-1', func() { // {{{
			const d = new Date(1945, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1945-9-1', func() { // {{{
			const d = new Date(1945, 9, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1945-10-1', func() { // {{{
			const d = new Date(1945, 10, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1946-2-1', func() { // {{{
			const d = new Date(1946, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1946-5-1', func() { // {{{
			const d = new Date(1946, 5, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1950-4-1', func() { // {{{
			const d = new Date(1950, 4, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}

		it('1950-5-1', func() { // {{{
			const d = new Date(1950, 5, 1)

			expect(tz.getUTCOffset(d)).to.equal(-5 * 60)
		}) // }}}

		it('1950-10-1', func() { // {{{
			const d = new Date(1950, 10, 1)

			expect(tz.getUTCOffset(d)).to.equal(-6 * 60)
		}) // }}}
	})

	describe('hongkong', func() {
		const tz = Timezone.get('Asia/Hong_Kong')

		it('1970-2-1', func() { // {{{
			const d = new Date(1970, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}

		it('1970-6-1', func() { // {{{
			const d = new Date(1970, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(9*60)
		}) // }}}

		it('1970-11-1', func() { // {{{
			const d = new Date(1970, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}

		it('1973-2-1', func() { // {{{
			const d = new Date(1973, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}

		it('1973-6-1', func() { // {{{
			const d = new Date(1973, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(9*60)
		}) // }}}

		it('1973-11-1', func() { // {{{
			const d = new Date(1973, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}

		it('1973-12-31', func() { // {{{
			const d = new Date(1973, 12, 31)

			expect(tz.getUTCOffset(d)).to.equal(9*60)
		}) // }}}

		it('1974-2-1', func() { // {{{
			const d = new Date(1974, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(9*60)
		}) // }}}

		it('1974-11-1', func() { // {{{
			const d = new Date(1974, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}

		it('1977-6-1', func() { // {{{
			const d = new Date(1977, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}

		it('1979-6-1', func() { // {{{
			const d = new Date(1979, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(9*60)
		}) // }}}

		it('1980-6-1', func() { // {{{
			const d = new Date(1980, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(8*60)
		}) // }}}
	})

	describe('honolulu', func() {
		const tz = Timezone.get('Pacific/Honolulu')

		it('1890-1-1', func() { // {{{
			const d = new Date(1890, 1, 1)

			expect(tz.getUTCOffset(d)).to.equal(-631)
		}) // }}}

		it('1900-1-1', func() { // {{{
			const d = new Date(1900, 1, 1)

			expect(tz.getUTCOffset(d)).to.equal(-10.5 * 60)
		}) // }}}

		it('1933-5-1', func() { // {{{
			const d = new Date(1933, 5, 1)

			expect(tz.getUTCOffset(d)).to.equal(-9.5 * 60)
		}) // }}}

		it('1933-6-1', func() { // {{{
			const d = new Date(1933, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(-10.5 * 60)
		}) // }}}

		it('1947-1-1', func() { // {{{
			const d = new Date(1947, 1, 1)

			expect(tz.getUTCOffset(d)).to.equal(-10.5 * 60)
		}) // }}}

		it('1947-7-1', func() { // {{{
			const d = new Date(1947, 7, 1)

			expect(tz.getUTCOffset(d)).to.equal(-10 * 60)
		}) // }}}

		it('2000-7-1', func() { // {{{
			const d = new Date(2000, 7, 1)

			expect(tz.getUTCOffset(d)).to.equal(-10 * 60)
		}) // }}}
	})

	describe('melbourne', func() {
		const tz = Timezone.get('Australia/Melbourne')

		it('2006-2-1', func() { // {{{
			const d = new Date(2006, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(11*60)
		}) // }}}

		it('2006-6-1', func() { // {{{
			const d = new Date(2006, 6, 1)

			expect(tz.getUTCOffset(d)).to.equal(10*60)
		}) // }}}

		it('2006-11-1', func() { // {{{
			const d = new Date(2006, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(11*60)
		}) // }}}

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
	})

	describe('newyork', func() {
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
	})

	describe('nicosia', func() {
		const tz = Timezone.get('Asia/Nicosia')

		it('1997-2-1', func() { // {{{
			const d = new Date(1997, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1997-4-1', func() { // {{{
			const d = new Date(1997, 4, 1)

			expect(tz.getUTCOffset(d)).to.equal(3*60)
		}) // }}}

		it('1997-11-1', func() { // {{{
			const d = new Date(1997, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1998-2-1', func() { // {{{
			const d = new Date(1998, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1998-4-1', func() { // {{{
			const d = new Date(1998, 4, 1)

			expect(tz.getUTCOffset(d)).to.equal(3*60)
		}) // }}}

		it('1998-11-1', func() { // {{{
			const d = new Date(1998, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1999-2-1', func() { // {{{
			const d = new Date(1999, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1999-4-1', func() { // {{{
			const d = new Date(1999, 4, 1)

			expect(tz.getUTCOffset(d)).to.equal(3*60)
		}) // }}}

		it('1999-11-1', func() { // {{{
			const d = new Date(1999, 11, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}
	})

	describe('paris', func() {
		const tz = Timezone.get('Europe/Paris')

		it('1939-2-1', func() { // {{{
			const d = new Date(1939, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(0)
		}) // }}}

		it('1939-5-1', func() { // {{{
			const d = new Date(1939, 5, 1)

			expect(tz.getUTCOffset(d)).to.equal(1*60)
		}) // }}}

		it('1939-12-1', func() { // {{{
			const d = new Date(1939, 12, 1)

			expect(tz.getUTCOffset(d)).to.equal(0)
		}) // }}}

		it('1940-2-1', func() { // {{{
			const d = new Date(1940, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(0)
		}) // }}}

		it('1940-5-1', func() { // {{{
			const d = new Date(1940, 5, 1)

			expect(tz.getUTCOffset(d)).to.equal(1*60)
		}) // }}}

		it('1940-7-1', func() { // {{{
			const d = new Date(1940, 7, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1941-2-1', func() { // {{{
			const d = new Date(1941, 2, 1)

			expect(tz.getUTCOffset(d)).to.equal(2*60)
		}) // }}}

		it('1942-12-1', func() { // {{{
			const d = new Date(1942, 12, 1)

			expect(tz.getUTCOffset(d)).to.equal(1*60)
		}) // }}}

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
	})

	describe('santiago', func() {
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
	})
})
