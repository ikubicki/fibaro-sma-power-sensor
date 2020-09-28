# SMA Power Sensor

This quick application creates power sensor from SMA inverter. It collect data about current PV power of your solar installation.

Data updates every 5 minutes by default.

## Configuration

`URL` - Base url to SMA inverter web interface, eg: `https://192.168.0.255`

`Password` - Password of chosen user

### Optional values

`Right` - name of the user. Defaults to `usr`

`Refresh Interval` - number of minutes defining how often data should be refreshed. This value will be automatically populated on initialization of quick application.

## Integration

This quick application integrates with other SMA dedicated quick app i have provided. It will automatically populate configuration to a new virtual SMA device.