# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bowtie/bowtie-0.10.1.ebuild,v 1.3 2009/09/22 11:43:28 maekke Exp $

EAPI="2"

inherit toolchain-funcs

ERPIN_BATCH_V=1.4

DESCRIPTION="Easy RNA Profile IdentificatioN, an RNA motif search program"
HOMEPAGE="http://tagc.univ-mrs.fr/erpin/"
SRC_URI="http://rna.igmors.u-psud.fr/download/Erpin/erpin${PV}.serv.tar.gz
	http://rna.igmors.u-psud.fr/download/Erpin/ErpinBatch.${ERPIN_BATCH_V}.tar.gz"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="!sys-cluster/maui" # file collision
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	rm -f erpin${PV}.serv/{bin,lib}/* || die
	rm -f ErpinBatch.${ERPIN_BATCH_V}/erpin* || die
	find -name '*.mk' | xargs sed -i \
		-e 's/strip $@/echo skipping strip $@/' \
		-e '/CFLAGS =/ d' \
		-e "s/CC = .*/CC = $(tc-getCC)/" || die
	sed -i 's/cc -O2/$(tc-getCC) ${CFLAGS}/' erpin${PV}.serv/sum/sum.mk || die
}

src_compile() {
	emake -C erpin${PV}.serv -f erpin.mk || die
}

src_install() {
	dobin erpin${PV}.serv/bin/* || die
	insinto /usr/share/${PN}
	doins -r erpin${PV}.serv/scripts ErpinBatch.${ERPIN_BATCH_V} || die
	exeinto /usr/share/${PN}
	newexe "${FILESDIR}/erpincommand-${PV}.pl" erpincommand.pl || die
	dodoc erpin${PV}.serv/doc/doc*.pdf || die
}
