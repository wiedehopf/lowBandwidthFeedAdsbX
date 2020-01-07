# lowBandwidthFeedAdsbX
Feed ADS-B to adsbexchange.com using minimal bandwidth.
MLAT feed not included.


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
