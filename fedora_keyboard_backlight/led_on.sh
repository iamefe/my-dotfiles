#!/bin/bash

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
      echo 1 | sudo tee $brightness_path > /dev/null
      if [ $? -eq 0 ]; then
        echo "Scroll Lock LED turned ON"
      else
        echo "Failed to turn on Scroll Lock LED"
      fi  
    elif [[ "$current_brightness" -eq 1 ]]; then
       echo 0 | sudo tee $brightness_path > /dev/null
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
