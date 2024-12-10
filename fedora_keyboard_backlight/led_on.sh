#!/bin/bash

# Define your sudo password here
SUDO_PASSWORD=""


# Get the current Scroll Lock LED devices (they might change)
scroll_led_paths=$(ls /sys/class/leds/ | grep -E 'input[0-9]+::scrolllock')

# Loop through each found device
for scroll_led_path in $scroll_led_paths; do
  # echo "scroll_led_path = $scroll_led_path"
  
  # Check if the brightness file exists for the current device
  brightness_path="/sys/class/leds/$scroll_led_path/brightness"
  if [ -f "$brightness_path" ]; then
    # echo "brightness_path = $brightness_path"
    
    # Read the current brightness state (1 = on, 0 = off)
    current_brightness=$(cat $brightness_path)
    
    # Log current brightness if debug is enabled
    if [ "$debug" = true ]; then
      echo "Current brightness = $current_brightness"
    fi
    
    # If the Scroll Lock LED is off (0), turn it back on (set to 1)
    if [ "$current_brightness" -eq 0 ]; then
      # Pass the sudo password to the tee command
    # echo "$SUDO_PASSWORD" | sudo -S sh -c "echo 1 > $brightness_path" > /dev/null
      echo 1 | sudo tee $brightness_path > /dev/null
      if [ $? -eq 0 ]; then
        echo "Scroll Lock LED turned ON"
      else
        echo "Failed to turn on Scroll Lock LED"
      fi    
    fi
  else
    echo "No brightness file found for $scroll_led_path"
  fi
done
