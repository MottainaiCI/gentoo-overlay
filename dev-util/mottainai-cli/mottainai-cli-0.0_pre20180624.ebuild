# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/MottainaiCI/${PN}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	#SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	#inherit golang-vcs-snapshot
	RESTRICT="mirror"
	inherit golang-vcs git-r3
	EGIT_REPO_URI="https://${EGO_PN}"
	EGIT_COMMIT="19d56ea567655d0a390d3b2820da106a58c9b72d"
	EGIT_CHECKOUT_DIR="${S}"
fi

inherit golang-build
DESCRIPTION="CLI for Mottainai"
HOMEPAGE="https://mottainaici.github.com/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	dobin mottainai-cli
}
