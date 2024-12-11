#!/bin/bash

# PTYXIS KEYBOARD SHORTCUT COMMAND
# ptyxis -x "zsh -c '~/fedora_keyboard_backlight/led_on.sh'"

# You might also want to disable the Caps Lock key (physically if need be).

# Source the sudo password from the secure file
source ~/.fedora_backlight_password.sh
# Make sure to set strict permission for password script `chmod 600  ~/.fedora_backlight_password.sh`

# Ensure the variable is set
if [ -z "$SUDO_PASSWORD" ]; then
  echo "Error: SUDO_PASSWORD is not set. Please check your fedora_backlight_password.sh file."
  exit 1
fi


# Get the current Scroll Lock LED devices (they might change)
scroll_led_paths=$(ls /sys/class/leds/ | grep -E 'input[0-9]+::scrolllock')

# Loop through each found device
for scroll_led_path in $scroll_led_paths; do 
  # Check if the brightness file exists for the current device
  brightness_path="/sys/class/leds/$scroll_led_path/brightness"
  if [ -f "$brightness_path" ]; then

    # Read the current brightness state (1 = on, 0 = off)
    current_brightness=$(cat $brightness_path)

    # Toggle LED on (1) or off (0)
    if [ "$current_brightness" -eq 0 ]; then
      # echo 1 | sudo tee $brightness_path > /dev/null
      # echo "$SUDO_PASSWORD" | sudo -S tee "$brightness_path" <<< 1 > /dev/null
      echo "$SUDO_PASSWORD" | sudo -S bash -c "echo 1 > $brightness_path"
      if [ $? -eq 0 ]; then
        echo "Scroll Lock LED turned ON"
      else
        echo "Failed to turn on Scroll Lock LED"
      fi  
    elif [[ "$current_brightness" -eq 1 ]]; then
       # echo 0 | sudo tee $brightness_path > /dev/null
        # echo "$SUDO_PASSWORD" | sudo -S tee "$brightness_path" <<< 0 > /dev/null
        echo "$SUDO_PASSWORD" | sudo -S bash -c "echo 0 > $brightness_path"
      if [ $? -eq 0 ]; then
        echo "Scroll Lock LED turned OFF"
      else
        echo "Failed to turn off Scroll Lock LED"
      fi        
    fi
  else
    echo "No brightness file found for $scroll_led_path"
  fi
done
