# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils python wxwidgets

DESCRIPTION="Python plotting library with Matlab like syntax"
HOMEPAGE="http://matplotlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? http://matplotlib.sourceforge.net/users_guide_0.87.1.pdf"

# agg: use external agg library
# wxwindows: enable wxpython backend
IUSE="doc gtk tcltk wxwindows agg"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="PYTHON"

DEPEND="virtual/python
		|| (
		dev-python/numpy
		dev-python/numarray
		>=dev-python/numeric-22
		)
		>=media-libs/freetype-2.1.7
		media-libs/libpng
		sys-libs/zlib
		gtk? ( >=dev-python/pygtk-1.99.16 )
		wxwindows? ( >=dev-python/wxpython-2.6 )
		dev-python/pytz
		dev-python/python-dateutil
		agg? ( x11-libs/agg )"

pkg_setup() {
	use tcltk && distutils_python_tkinter
	if use wxwindows; then
		export WX_GTK_VER="2.6"
		need-wxwidgets gtk2
	fi
   
}

src_unpack() {
	unpack ${A}

	cd "${S}"

	# disable autodetection, rely on USE instead
	epatch "${FILESDIR}/${PN}-0.87.2-no-autodetect.patch"
	# tkinter opens a window to determine paths! remove it
	epatch "${FILESDIR}/${P}-tcltk.patch"
	
	sed -i \
		-e "/^BUILD_GTK/s/'auto'/$(use gtk && echo 1 || echo 0)/g" \
		-e "/^BUILD_WX/s/'auto'/$(use wxwindows && echo 1 || echo 0)/g" \
		-e "/^BUILD_TK/s/'auto'/$(use tcltk && echo 1 || echo 0)/g" \
		-e "/^BUILD_AGG/s/'auto'/$(use agg && echo 1 || echo 0)/g" \
		setup.py
}

src_compile() {
	# needs this hack below: why?
	use wxwindows && export WX_CONFIG="${WX_CONFIG}"
	distutils_src_compile
}

src_install() {
	use wxwindows && export WX_CONFIG="${WX_CONFIG}"
	distutils_src_install
	dodoc INTERACTIVE API_CHANGES NUMARRAY_ISSUES
	if use doc ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.py examples/README
		insinto /usr/share/doc/${PF}/examples/data
		doins examples/data/*.dat
		insinto /usr/share/doc/${PF}/
		doins ${DISTDIR}/users_guide_*.pdf
	fi
}
