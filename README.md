# deprecated

please use the main feed scripts located here: https://github.com/adsbxchange/adsb-exchange#ads-b-exchange-setup-scripts-airplane
if you're already running this, run the uninstall.

You can edit /etc/default/adsbexchange and change
```
REDUCE_INTERVAL="0.5"
```
to
```
REDUCE_INTERVAL="2.5"
```
or longer to reduce data usage.
You might also want to disable MLAT:
```
sudo systemctl disable --now adsbexchange-mlat
```


# lowBandwidthFeedAdsbX
Feed ADS-B to adsbexchange.com using minimal bandwidth.
MLAT feed not included.

This feed client requires readsb or dump1090 to be already running and offering beast data on port 30005.
If you are feeding FA for example, this is already the case.

If you are only feeding FR24, then a reconfiguration is most likely required, this would take care of that:
 https://github.com/wiedehopf/adsb-scripts/wiki/Automatic-installation-for-readsb


## Approximate bandwidth requirement per month

With the default interval of 2.5 seconds and an average of 10 aircraft in range of your receiver, the data used will be around 1 GB per month.
For a more typical 50 aircraft in view (average, not peak), the data usage will be 5 GB per month.

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
