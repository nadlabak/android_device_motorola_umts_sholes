# This is an example input device configuration file for a built-in
# keyboard that has a DPad.

# The keyboard is internal because it is part of the device.
device.internal = 1

# The keyboard is the default built-in keyboard so it should be assigned
# an id of 0.
keyboard.builtIn = 1

# The keyboard includes a DPad which is mounted on the device.  As the device
# is rotated the orientation of the DPad rotates along with it, so the DPad must
# be aware of the display orientation.  This ensures that pressing 'up' on the
# DPad always means 'up' from the perspective of the user, even when the entire
# device has been rotated.
keyboard.orientationAware = 1
keyboard.layout = sholes-keypad
keyboard.characterMap = sholes-keypad
