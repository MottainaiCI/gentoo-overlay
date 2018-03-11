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
	EGIT_COMMIT="93bbc827550854e0235d1b5b7e7ec2eec6034d94"
	EGIT_CHECKOUT_DIR="${S}"
fi

inherit golang-build systemd user
DESCRIPTION="Distributed Task Build Service"
HOMEPAGE="https://mottainaici.github.com/"

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd"

DEPEND=""
RDEPEND="dev-vcs/git"

pkg_setup() {
	enewgroup mottainai
	enewuser mottainai-server -1 -1 "/var/lib/mottainai/" "mottainai"
}

src_install() {
	local LIB_DIR="/var/lib/mottainai/"
	local SRV_DIR="/srv/mottainai"

	use systemd && systemd_dounit "${FILESDIR}/mottainai-server.service"

	dodir /etc/mottainai
	insinto /etc/mottainai
	doins "${FILESDIR}/mottainai-server.yaml"

	dodir "${LIB_DIR}"
	insinto "${LIB_DIR}"

	cp -R templates "${ED}${LIB_DIR}"
	cp -R public "${ED}${LIB_DIR}"
	fowners -R mottainai-server:mottainai "${LIB_DIR}"
	fperms -R 664 "${LIB_DIR}"
	fperms -R 770 "${LIB_DIR}/templates"
	fperms -R 644 "${LIB_DIR}/public"

	dodir "${SRV_DIR}/web"
	dodir "${SRV_DIR}/web/artefact"
	dodir "${SRV_DIR}/web/namespace"
	dodir "${SRV_DIR}/web/storage"
	dodir "${SRV_DIR}/web/db"

	fowners -R mottainai-server:mottainai "${SRV_DIR}"
	fperms -R 774 "${SRV_DIR}"

	dobin mottainai-server
}
