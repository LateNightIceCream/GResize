#!/bin/sh

activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
activeWinId=${activeWinLine:40}

activeWinDimLine=$(xprop -id $activeWinId | grep "_NET_WM_OPAQUE_REGION")

xwinstuff=$(xwininfo -id $(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}'))
windowCoordXLine=$(echo "$xwinstuff" | grep "Absolute upper-left X")
windowCoordYLine=$(echo "$xwinstuff" | grep "Absolute upper-left Y")

windowCoordX=$(echo "${windowCoordXLine:25}")
windowCoordY=$(echo "${windowCoordYLine:25}")

windowWidthLine=$(echo "$xwinstuff" | grep "Width:")
windowHeightLine=$(echo "$xwinstuff" | grep "Height:")

windowWidth=$(echo "${windowWidthLine:9}")
windowHeight=$(echo "${windowHeightLine:10}")

gr=1.618

# height type (-h) or width type (-w)

# change height based on width
if [ $1 = "-h" ]; then

	windowHeight=$(bc<<<$windowWidth/$gr)

  # scale up
	if [ $2 = "-u" ]; then

	val=$(bc<<<$windowWidth*$gr)
	windowHeight=$(printf "%.0f" $val)

	fi

fi

# change width based on height
if [ $1 = "-w" ]; then

	windowWidth=$(bc<<<$windowHeight/$gr)

	# scale up
	if [ $2 = "-u" ]; then

		val=$(bc<<<$windowHeight*$gr)
		windowWidth=$(printf "%.0f" $val)

	fi

fi

wmctrl -i -r $activeWinId -e "1,$windowCoordX,$windowCoordY,$windowWidth,$windowHeight"

