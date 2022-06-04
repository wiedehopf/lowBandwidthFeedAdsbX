#!/bin/bash
set -e

# GENERATE UUID
if [ -f /boot/adsb-config.txt ]; then
    UUID_FILE="/boot/adsbx-uuid"
else
    mkdir -p /usr/local/share/adsbexchange
    UUID_FILE="/usr/local/share/adsbexchange/adsbx-uuid"
    # move old file position
    if [ -f /boot/adsbx-uuid ]; then
        mv -f /boot/adsbx-uuid $UUID_FILE
    fi
fi

function generateUUID() {
    rm -f $UUID_FILE
    sleep 0.$RANDOM; sleep 0.$RANDOM
    UUID=$(cat /proc/sys/kernel/random/uuid)
    echo New UUID: $UUID
    echo $UUID > $UUID_FILE
}

# Check for a (valid) UUID...
if [ -f $UUID_FILE ]; then
    UUID=$(cat $UUID_FILE)
    if ! [[ $UUID =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
        # Data in UUID file is invalid.  Regenerate it!
        echo "WARNING: Data in UUID file was invalid.  Regenerating UUID."
        generateUUID
    else
        echo "Using existing valid UUID ($UUID) from $UUID_FILE"
    fi
else
    # not found generate uuid and save it
    echo "WARNING: No UUID file found, generating new UUID..."
    generateUUID
fi
# GENERATE UUID END

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
	git clone --single-branch --depth 1 --branch stale https://github.com/wiedehopf/readsb.git /tmp/readsb
	cd /tmp/readsb
    apt install -y libncurses-dev
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
