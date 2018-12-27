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
	EGIT_COMMIT="cc768cc8fb4f865d86993de8286425cefbaaf569"
	EGIT_CHECKOUT_DIR="${S}"
fi

inherit golang-build user systemd
DESCRIPTION="Agent for Mottainai"
HOMEPAGE="https://mottainaici.github.com/"

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd lxd"
DEPEND="lxd? ( app-emulation/lxd )"
RDEPEND="app-emulation/docker
dev-vcs/git"

pkg_setup() {
	enewgroup mottainai
	enewuser mottainai-agent -1 -1 "/srv/mottainai" "mottainai,docker" # :(
}

src_compile() {
	use lxd && EGO_BUILD_FLAGS="-tags lxd"

	golang-build_src_compile
}

src_install() {
	local LIB_DIR="/var/lib/mottainai/"
	local SRV_DIR="/srv/mottainai"

	use systemd && systemd_dounit "${S}/contrib/systemd/mottainai-agent.service"

	dodir /etc/mottainai
	insinto /etc/mottainai
	newins "${S}/contrib/config/mottainai-agent.yaml.example" "mottainai-agent.yaml"

	dodir "${SRV_DIR}/build"

	fowners -R mottainai-agent:mottainai "${SRV_DIR}/build"
	fperms -R 774 "${SRV_DIR}/build"

	dodir "${SRV_DIR}/build_temp"

	fowners -R mottainai-agent:mottainai "${SRV_DIR}/build_temp"
	fperms -R 774 "${SRV_DIR}/build_temp"

	if use lxd; then
		dodir "${SRV_DIR}/build/lxc"
		insinto "${SRV_DIR}/build/lxc"
		doins "${S}/contrib/config/lxc/config.yml"

		fowners -R mottainai-agent:mottainai "${SRV_DIR}/build/lxc"
		fperms -R 774 "${SRV_DIR}/build/lxc"
	fi

	dobin mottainai-agent
}
