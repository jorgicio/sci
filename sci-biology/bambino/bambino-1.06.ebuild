# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2 eutils

DESCRIPTION="Bambino / BAMview / bam_utils to display SAM/BAM files and for SNP/indel detection, report coverage in .wig files"
HOMEPAGE="https://cgwb.nci.nih.gov/goldenPath/bamview/documentation/index.html"

# bug #377305
SRC_URI="https://cgwb.nci.nih.gov/cgi-bin/bambino?download_bambino_jar=bundle -> bambino_core_1.06.jar
		https://cgwb.nci.nih.gov/cgi-bin/bambino?download_bambino_jar=core -> bambino_bundle_1.06.jar"

LICENSE="bambino"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=virtual/jdk-1.6
	sci-biology/picard
	dev-java/jdbc-mysql"

src_install(){
	insinto "${DESTDIR}"/usr/share/"${PN}"/lib
	doins "${DISTDIR}"/bambino_core_"${PV}".jar || die
	doins "${DISTDIR}"/bambino_bundle_"${PV}".jar || die

	einfo "bambino can be run using 'java -jar /usr/share/bambino/lib/bambino_bundle_1.06.jar'"
	einfo "  or 'java -jar /usr/share/bambino/lib/bambino_core_1.06.jar'"
	einfo "More info at "${HOMEPAGE}

}