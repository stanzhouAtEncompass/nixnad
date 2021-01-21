# swap ctrl and caps lock
setxkbmap -option ctrl:swapcaps

# correct DNS handling
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"

# set second monitor as primary 
xrandr | grep -q 'HDMI-1 connected' && xrandr --output eDP-1 --auto --output HDMI-1 --primary --auto --above eDP-1
