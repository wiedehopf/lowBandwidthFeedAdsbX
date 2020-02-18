# lowBandwidthFeedAdsbX
Feed ADS-B to adsbexchange.com using minimal bandwidth.
MLAT feed not included.

This feed client requires dump1090 to be already running and offering beast data on port 30005.
If you are feeding FA for example, this is already the case.

If you are only feeding FR24, then a reconfiguration is most likely required, this would take care of that:
 https://github.com/wiedehopf/adsb-scripts/wiki/Automatic-installation-for-dump1090-fa


## Approximate bandwidth requirement

With the default interval of 2.5 seconds and an average of 10 aircraft in range of your receiver, the data used will be around 1 GB.
For a more typical 50 aircraft in view (average, not peak), the data usage will be 5 GB.

You can change that interval in the configuration file to further reduce data usage.

The "normal" adsbexchange feed client including MLAT uses around 10 times as much data.

## Installation

```
sudo bash -c "$(wget -q -O - https://raw.githubusercontent.com/wiedehopf/lowBandwidthFeedAdsbX/master/install.sh)"
```

## Status

```
sudo systemctl status lbw-feed-adsbx
```

## Logs
```
sudo journalctl -eu lbw-feed-adsbx
```


## Configuration file for advanced users

```
/etc/default/lbw-feed-adsbx
```


## Deinstallation

```
sudo bash -c "$(wget -q -O - https://raw.githubusercontent.com/wiedehopf/lowBandwidthFeedAdsbX/master/uninstall.sh)"
```
