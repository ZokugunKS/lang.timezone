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

describe('abbreviation', func() {
	describe('dublin', func() {
		const tz = Timezone.get('Europe/Dublin')

		it('2000-1-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(2000, 1, 1))).to.equal('GMT')
		}) // }}}

		it('2000-7-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(2000, 7, 1))).to.equal('IST')
		}) // }}}
	})

	describe('paris', func() {
		const tz = Timezone.get('Europe/Paris')

		it('1910-1-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(1910, 1, 1))).to.equal('PMT')
		}) // }}}

		it('2000-1-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(2000, 1, 1))).to.equal('CET')
		}) // }}}

		it('2000-7-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(2000, 7, 1))).to.equal('CEST')
		}) // }}}
	})

	describe('chicago', func() {
		const tz = Timezone.get('America/Chicago')

		it('1941-1-1 Pacific/Honolulu', func() { // {{{
			expect(tz.getAbbreviation(new Date(1941, 1, 1))).to.equal('CST')
		}) // }}}

		it('1942-1-1 Pacific/Honolulu', func() { // {{{
			expect(tz.getAbbreviation(new Date(1942, 1, 1))).to.equal('CST')
		}) // }}}

		it('1944-1-1 Pacific/Honolulu', func() { // {{{
			expect(tz.getAbbreviation(new Date(1944, 1, 1))).to.equal('CWT')
		}) // }}}

		it('1945-9-1 Pacific/Honolulu', func() { // {{{
			expect(tz.getAbbreviation(new Date(1945, 9, 1))).to.equal('CPT')
		}) // }}}

		it('1945-10-1 Pacific/Honolulu', func() { // {{{
			expect(tz.getAbbreviation(new Date(1945, 10, 1))).to.equal('CST')
		}) // }}}

		it('1946-5-1 Pacific/Honolulu', func() { // {{{
			expect(tz.getAbbreviation(new Date(1946, 5, 1))).to.equal('CDT')
		}) // }}}
	})

	describe('honolulu', func() {
		const tz = Timezone.get('Pacific/Honolulu')

		it('1890-1-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(1890, 1, 1))).to.equal('LMT')
		}) // }}}

		it('1900-1-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(1900, 1, 1))).to.equal('HST')
		}) // }}}

		it('1933-5-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(1933, 5, 1))).to.equal('HDT')
		}) // }}}

		it('1933-6-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(1933, 6, 1))).to.equal('HST')
		}) // }}}

		it('2000-1-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(2000, 1, 1))).to.equal('HST')
		}) // }}}

		it('2000-7-1', func() { // {{{
			expect(tz.getAbbreviation(new Date(2000, 7, 1))).to.equal('HST')
		}) // }}}
	})
})
