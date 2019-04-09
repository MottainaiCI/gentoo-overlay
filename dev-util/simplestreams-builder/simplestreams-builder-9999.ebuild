# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/MottainaiCI/${PN}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	#inherit golang-vcs-snapshot
	RESTRICT="mirror"
	inherit golang-vcs git-r3
	EGIT_REPO_URI="https://${EGO_PN}"
	EGIT_COMMIT="2df9b7700fc1d6a7510a20783cf48362036e8f7c"
	EGIT_CHECKOUT_DIR="${S}"
fi

inherit golang-build
DESCRIPTION="LXC/LXD Simplestreams Tree Builder"
HOMEPAGE="https://github.com/MottainaiCI/simplestreams-builder"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="app-emulation/distrobuilder"

src_compile() {
	golang-build_src_compile
}

src_install() {
	dobin simplestreams-builder
}
