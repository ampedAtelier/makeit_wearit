# code.py
#
# Programmable Sewn Circuits Workshop
# Components:
# * Adafruit Gemma M0 (product ID: 3501)
# * Flora NeoPixels v2 (product ID: 1260)
# The program's two animation that can be toggled
# by touching the A1 pad on the Gemma.
#
# CircuitPython looks for a code file on the board to run.
# There are four options: code.txt, code.py, main.txt and main.py.
# CircuitPython looks for those files, in that order,
# and then runs the first one it finds.
#
# Status Light:
# Green: a code file is running
# White: REPL is running, press Ctrl+D to reload code file
# see https://learn.adafruit.com/adafruit-gemma-m0/troubleshooting

import board
import digitalio
import neopixel
import random
import time
import touchio

from adafruit_debouncer import Debouncer

# Set Up
# Built in red LED
led = digitalio.DigitalInOut(board.D13)
led.direction = digitalio.Direction.OUTPUT

# Reference to 4 NeoPixels
# see https://learn.adafruit.com/adafruit-gemma-m0/circuitpython-neopixel
pixels = neopixel.NeoPixel(board.D1, 4, brightness=0.1)

# Capacitive touch on A1
# https://learn.adafruit.com/adafruit-gemma-m0/circuitpython-cap-touch-2
touch = touchio.TouchIn(board.A1)

# Touch Debouncing
# https://learn.adafruit.com/debouncer-library-python-circuitpython-buttons-sensors/overview
def touch_value():
    return touch.value

touchSignal = Debouncer(touch_value)

# Here is where you can put in your favorite colors that will appear!
# RGB format
# They will be picked out randomly.
myColors = [(232, 100, 255), (200, 200, 20), (30, 200, 200)]
#            purple,          yellow,         blue

# Helper to give us a nice color swirl
def wheel(pos):
    # Input a value 0 to 255 to get a color value.
    # The colours are a transition r - g - b - back to r.
    if (pos < 0) or (pos > 255):
        return [0, 0, 0]
    if (pos < 85):
        return [int(pos * 3), int(255 - (pos*3)), 0]
    elif (pos < 170):
        pos -= 85
        return [int(255 - pos*3), 0, int(pos*3)]
    else:
        pos -= 170
        return [0, int(pos*3), int(255 - pos*3)]

def flashRandom(wait):
    # pick a random favorite color!
    aColor = random.choice(myColors)
    red = aColor[0]
    green = aColor[1]
    blue = aColor[2]
    # get a random pixel
    randPixel = random.randrange(0, len(pixels))
    # print('flashRandom: randPixel =', randPixel)
    for j in range(5):
        r = red * (j+1)/5
        g = green * (j+1)/5
        b = blue * (j+1)/5
        pixels[randPixel] = (int(r), int(g), int(b))
        pixels.write()
        time.sleep(wait)
    # & fade out in 5 steps
    for j in range(5):
        k = 4-j
        r = red * (k)/5
        g = green * (k)/5
        b = blue * (k)/5
        pixels[randPixel] = (int(r), int(g), int(b))
        pixels.write()
        time.sleep(wait)
    # LEDs will be off when done (they are faded to 0)

def rainbow_cycle(iColor, wait):
    for i in range(pixels.n):
        idx = int((i * 256 / len(pixels)) + iColor)
        pixels[i] = wheel(idx & 255)
    pixels.write()
    time.sleep(wait)

# Main Loop
shouldTwinkle = True
iColor = 0

while True:
    # use pad A1 as capacitive touch to toggle display modes
    touchSignal.update()
    if touchSignal.rose:
        print("Touched!")
        led.value = not led.value
        # toggle displayMode
        shouldTwinkle = not shouldTwinkle
        # time.sleep(0.25)
        pixels.fill((0, 0, 0))

    # lightshow
    if (shouldTwinkle is True):
        flashRandom(0.02)
    else:
        iColor = (iColor+1) % 256		# run from 0 to 255
        rainbow_cycle(iColor, 0.001)    # rainbowcycle with 1ms delay per step
