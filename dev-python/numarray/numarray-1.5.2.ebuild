# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils fortran

DESCRIPTION="Large array processing extension module for Python"
SRC_URI="mirror://sourceforge/numpy/${P}.tar.gz
doc? mirror://sourceforge/numpy/${PN}-1.5.html.tar.gz"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/numarray"
DEPEND=">=dev-lang/python-2.3
	lapack? ( sci-libs/blas-atlas virtual/lapack )"
IUSE="doc lapack"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"

FORTRAN="gfortran g77"

src_unpack() {
	unpack ${A}
	use doc && mv ${PN}-1.5 html
	# various patches inspired from Debian packaging.
	# include Python.h from header files using the PyObject_HEAD macro.
	epatch "${FILESDIR}"/${P}-includes.patch

	# fix Makefile for html docs
	epatch "${FILESDIR}"/${P}-html.patch

	# fix hard-coded path in numinclude
	epatch "${FILESDIR}"/${P}-numinclude.patch

	cd ${S}
	if use lapack; then
		local myblas="/usr/$(get_libdir)/blas/atlas"
		[ -d "/usr/$(get_libdir)/blas/threaded-atlas" ] && \
			myblas=${myblas/threaded-/}
		# fix default location and lib names
		sed -i \
			-e 's:/usr/local/lib/atlas:${myblas}:g' \
			-e 's:/usr/local/include/atlas:/usr/include/atlas:g' \
			-e 's:f77blas:blas:g' \
			cfg_packages.py
		# fix gfortran for > gcc-4
		if  [[ ${FORTRANC} == gfortran ]]; then
			sed -i \
				-e "s:g2c:gfortran:g" \
				cfg_packages.py
		fi
	fi
}

src_install() {
	distutils_src_install
	dodoc Doc/*.txt LICENSE.txt Doc/release_notes/ANNOUNCE-${PV:0:3}
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r Examples
		dohtml ${WORKDIR}/html
	fi
}
