#!/bin/bash
# mudler@gentoo.org
set -e
set -x
set -v

BRANCH="${BRANCH:-develop}"
#SERVER_SHA=$(curl https://api.github.com/repos/MottainaiCI/mottainai-server/commits/master |  jq -r '.  | .sha')
#AGENT_SHA=$(curl https://api.github.com/repos/MottainaiCI/mottainai-agent/commits/master |  jq -r '.  | .sha')
#CLI_SHA=$(curl https://api.github.com/repos/MottainaiCI/mottainai-cli/commits/master |  jq -r '.  | .sha')
DATE=$(date +'%Y%m%d')

for repo in "mottainai-server" "mottainai-cli" "mottainai-agent" "replicant"
do

	SHA=$(curl "https://api.github.com/repos/MottainaiCI/$repo/commits/$BRANCH" |  jq -r '.  | .sha')
	cp -rfv "dev-util/$repo/$repo-9999.ebuild" "dev-util/${repo}/${repo}-0.0_pre${DATE}.ebuild"
	CURRENT_SHA=$(grep -Po 'EGIT_COMMIT="\K.*(?=")' "dev-util/${repo}/${repo}-0.0_pre${DATE}.ebuild")
	sed -i "s:${CURRENT_SHA}:${SHA}:g" "dev-util/${repo}/${repo}-0.0_pre${DATE}.ebuild"
	pushd "dev-util/${repo}"
		git add "${repo}-0.0_pre${DATE}.ebuild"
		repoman commit -m "dev-util/$repo: Pin to $BRANCH-$DATE"
	popd
done
