# monitord - autorandr made easier

`monitord` runs a script when the display configuration is changed.

In your session startup script, start `monitord` with the command line it will execute when the display configuration changes.

## Example

Here's an example with [i3wm](https://i3wm.org/):

```
exec --no-startup-id monitord /path/to/myscript.sh someargs
```

Each time the display configuration is updated, `myscript.sh someargs` will be run.

`myscript.sh` can do anything.
An example use case would be to use `xrandr` to change the display configuration according to the dock your laptop is currently plugged in.

You could therefore do something like this:

```
# Apply a display configuration according to the dock
# the laptop is currently plugged in.
# The dock is detected by it's network card in this example.

if ip l show enxdaabbccddeeff 2>&1 > /dev/null; then
        # dock a
        nmcli connection up ConnA
        "${HOME}/.screenlayout/preset-a.sh"
elif ip l show enxd11aa22bb33cc 2>&1 > /dev/null; then
        # dock b
        nmcli connection up ConnB
        "${HOME}/.screenlayout/preset-b.sh"
else
        # laptop only
        nmcli connection up WiFi
        "${HOME}/.screenlayout/laptop.sh"
fi
```

## How it works

`monitord` adds a `udev` rule which detects display hardware changes.
When a display change occurs, it triggers a systemd service which sends a signal (SIGUSR1) to all `monitord` processes.

The `monitord` processes are running in the users sessions and only get the permission level of their owner.
