#!/bin/bash
set -e

name="lbw-feed-adsbx"
repo="https://github.com/wiedehopf/lowBandwidthFeedAdsbX"
ipath="/usr/local/share/$name"

current_path=$(pwd)

mkdir -p $ipath


if ! id -u "$name" &>/dev/null
then
    adduser --system --home "$ipath" --no-create-home --quiet "$name"
fi


commands="git gcc make ld"
packages="git build-essential"
install=""

for CMD in $commands; do
	if ! command -v "$CMD" &>/dev/null
	then
        install=1
	fi
done

if [[ -n "$install" ]]
then
	echo "Installing required packages: $packages"
	apt-get update || true
	if ! apt-get install -y $packages
	then
		echo "Failed to install required packages: $install"
		echo "Exiting ..."
		exit 1
	fi
	hash -r || true
fi

if ! [ -f $ipath/readsb ]; then
	rm -rf /tmp/readsb &>/dev/null || true
	git clone --single-branch --depth 1 --branch net-only https://github.com/wiedehopf/readsb.git /tmp/readsb
	cd /tmp/readsb
    apt install -y libncurses5-dev
	make
	cp readsb $ipath
    cd /tmp
	rm -rf /tmp/readsb &>/dev/null || true
fi

cd "$current_path"

if [[ "$1" == "test" ]]
then
	rm -r $ipath/test 2>/dev/null || true
	mkdir -p $ipath/test
	cp -r ./* $ipath/test
	cd $ipath/test

elif git clone --depth 1 $repo $ipath/git 2>/dev/null || cd $ipath/git
then
	cd $ipath/git
	git checkout -f master
	git fetch
	git reset --hard origin/master

else
	echo "Unable to download files, exiting! (Maybe try again?)"
	exit 1
fi

cp default "/etc/default/$name"
cp default $ipath

cp 1090.service "/lib/systemd/system/$name.service"

systemctl enable "$name"
systemctl restart "$name"
