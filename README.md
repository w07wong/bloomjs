# Bloom.js

In this internet-based earthwork, ground motion along the Hayward Fault in California is detected by a seismograph, transmitted continuously via the Internet and processed to generate an evolving field of circular blooms.

This project is a port of the original Bloom flash based animation to JavaScript.

# Project Structure

Bloom.js uses the following folders and files to render animations:
  - /css
    - style.css
  - /js
    - jquery-2.1.3.js
    - main.js
  - /palettes
    - palette9.jpg
  - index.html

Included in the project folders are ActionScript files that were part of the old Bloom Flash animation.

### main.js

This file renders blooms and animates them based on seismic data from http://californiareportcard.org/naturalFrequencies/naturalFrequencies.py. Every 250 milliseconds, the program GETs data from the server, processes it and generates Blooms of random size and shape based on the numbers.

The function poll() is an AJAX request which calls processData() on the response from the server.  While data is constantly polled and processed, the yimmy() function is also running in the background.  Every 300 milliseconds, yimmy() refreshes animations with update2() and main().

update2() handles Bloom creation.  This function takes processed data, and if the data represents movement in at the Hayward Fault, calls createBloom().  The responsibilities of createBloom() are: choose random starting X and Y coordinates for a Bloom, choose ranodm colors for the Bloom, choose a random number of rings and call g_circle_t() to create Bloom objects.  Note that Bloom objects are just cricles.

The parameters required to create a Bloom are:
  - counter (used as a Bloom's id)
  - opacity (starting opacity of the Bloom)
  - ring (number of rings used to set dynamic blur)
  - wait (how long to wait before rendering a Bloom, currently set to 0)
  - X (starting x-coordinate)
  - y (starting y-coordinate)
  - min_r (starting radius of the circle)
  - max_r (ending radius of a circle)
  - red (circle colors values)
  - green
  - blue
  - max_time (amount of time the circle should stay displayed)
  - invisflag (whether or not a circle should be rendered)

All Bloom objects are stored in an array called circle_array.  As noted previously, main() helps refresh animations through update() which calls update_circle_state().  The last function takes a Bloom object and renders it from a point to a full circle, bluring it in as the circle grows and fading it out once the circle as reached max radius.  Circle growth follows a logarithmic function, so the rate of growth is fast initially but slows down as the radius reaches its maximum.

There are various functions that handle color functionality.  Bloom colors are derived from palette9.jpg located inside the folder palettes.  If you wish to use more images to generate colors for Blooms, simply modify the randomPaletteIndex variable in createBloom().

### index.html
This file sets up 10 HTML canvas objects.  Nine are used to store the nine palette images and the last canvas is used to render Blooms.

When the page loads, it calls yimmy.init() and yimmy.start().  The init function allows for any variables to be passed to main.js and start() begins the animation.

# How to Run The Program
To run the code locally, I used
http-server from NPM.  
```
$ npm install http-server
$ http-server
```
Cross-Origin Resource Sharing (CORS) prevents domains not given read access by a server from GET-ting data with REST calls.  To test the animation locally, comment out the AJAX request under poll() in main.js and uncomment the three lines below the request as well as the test array (var a) at the top of the file.

In order to run this real time, the code needs to be loaded onto the same provider as http://memento.ieor.berkeley.edu/flutter/, or onto a domain that is allowed to fetch data from http://californiareportcard.org/naturalFrequencies/naturalFrequencies.py.
