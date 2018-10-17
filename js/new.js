function createBloom2(counter, iParam) {
    windowHeight = canvas.height;
    windowWidth = canvas.width;
    var svgW = windowWidth;
    var svgH = windowHeight;

    var numRings = getRandomInt(Math.floor((10 + Math.abs(smoothedData[iParam] / 10)) / 10), NUM_RINGS_PER_BLOOM);

    // Assume time differences between sensor readings are uniform
    var firstDerivative1 = smoothedData[iParam] - smoothedData[iParam - 1];
    var firstDerivative2 = smoothedData[iParam + 1] - smoothedData[iParam];
    var secondDerivative = firstDerivative2 - firstDerivative1;
    // Y position of bloom = second derivative scaled by some constant
    var y = Math.abs(secondDerivative) * 3 % svgH;
    // X position of bloom; change constnat to modify ratio of time ticks to movement in x axis on screen
    var x = (time / 3) * 300 % svgW;
    x = getRandomInt(0, svgW);
    
    var randomPaletteIndex = getRandomInt(0, NUM_PALETTES);
    // randomPaletteIndex = NUM_PALETTES - 1;
    randomPaletteIndex = 1;
    var randomContext = contexts[randomPaletteIndex];

    var colors = [];

    var w = getImgWidth(randomPaletteIndex);
    var h = getImgHeight(randomPaletteIndex);
    var randomX = getRandomInt(0, w);
    var randomY = getRandomInt(0, h);

    for (var i = 0; i < numRings; i++) {
        randomX = mod((randomX - getRandomInt(0, Math.floor(w / 3))), w);
        randomY = mod((randomY - getRandomInt(0, Math.floor(h / 3))), h);
        var pixelData = randomContext.getImageData(randomX, randomY, 1, 1).data;
        while (!isColorValid2(pixelData[0], pixelData[1], pixelData[2])) {
            randomX = mod((randomX - getRandomInt(0, Math.floor(w / 3))), w);
            randomY = mod((randomY - getRandomInt(0, Math.floor(h / 3))), h);
            pixelData = randomContext.getImageData(randomX, randomY, 1, 1).data;
        }
        colors.push(rgb2hsv(pixelData[0], pixelData[1], pixelData[2]));
    }

    colors.sort(sortByHue);
    for (var i = 0; i < colors.length; i++) {
        colors[i] = {
            h: colors[i].h,
            s: Math.floor(colors[i].s, 100),
            v: colors[i].v
        }
    }

    var rgbColors = [];
    for (var i = 0; i < colors.length; i++) {
        rgbColors.push(HSVtoRGB(colors[i]));
    }

    // Initial Radius
    var init_r = 1;
    var max_radius = init_r + Math.abs(smoothedData[iParam] / 10)
    var init_max_radius = init_r + Math.abs(smoothedData[iParam] / 100);
    var i = numRings;
    
    for (var j = numRings - 1; j >= 1; j--) {
        console.log(j);
        circle_array.push(new g_circle_t2(counter, 1, j, 0, x, y, init_r, init_r + init_max_radius + 5 * j, rgbColors[j].r, rgbColors[j].g, rgbColors[j].b, max_radius * 2, 0));
    }

    // circle_array.push(new g_circle_t2(counter, 1, 1, 100, x, y, init_r, init_r + getRandomInt(max_radius / 2 , max_radius), rgbColors[0].r, rgbColors[0].g, rgbColors[0].b, max_radius * 2, 0));
    
    // circle_array.push(new g_circle_t2(counter, 1 - ((Math.floor((numRings - 1 - i) / 3)) + 1) / 3 * 0.5 , (numRings - 1 - i) * 12 + Math.floor((numRings - 1 - i) / 3) * 16, x, y, init_r, init_r + max_radius * (2 * i/3 + 1 + ((numRings - 1) / 3)) / numRings, rgbColors[i-1].r, rgbColors[i-1].g, rgbColors[i-1].b, max_radius * 2, 1));

    // var radius_of_largest_ring = (init_r + max_radius * (2 * (numRings - 1) / 3 + 1 + ((numRings - 1) / 3)) / numRings) * Math.log(21.5);
    // x = Math.min(svgW - radius_of_largest_ring, Math.max(x, radius_of_largest_ring));
    // y = Math.min(svgH - radius_of_largest_ring, Math.max(y, radius_of_largest_ring));

    // for (i = numRings - 1; i >= 0; i--) {
        // circle_array.push(new g_circle_t2(counter, 1 - ((Math.floor((numRings - 1 - i) / 3)) + 1) / 3 * 0.5 , (numRings - 1 - i) * 12 + Math.floor((numRings - 1 - i) / 3) * 16 * 0, x, y, init_r, init_r + max_radius * 2 * (2 * (i*0.1)/3 + 1 + ((numRings - 1) / 3)) / numRings, rgbColors[i].r, rgbColors[i].g, rgbColors[i].b, max_radius * 2, 0));
    // }
}

function g_circle_t2(counter, opacity, ring, wait, x, y, min_r, max_r, red, green, blue, max_time, invisflag){
    // Center coordinates of the circle
    this.id = counter;

    this.x = x;
    this.y = y;

    this.invisflag = invisflag;

    this.opacity = opacity;

    /*
    // Speed of the growth of the circle by [rad/sec]
    this.speed = 3;
    */
    this.time = 0;
    this.max_time = max_time;

    this.ring = ring;

    // Radius of the circle
    this.max_r = max_r;
    this.r = min_r;
    this.min_r = min_r;

    // Max radius of the circle before it starts shrinking
    
    this.is_fading_away = false;

    this.red = red;
    this.green = green;
    this.blue = blue;
    
    this.gradient = 'rgba(' + this.red.toString() + ',' + this.green.toString() + ',' + this.blue.toString() + ',1)';

    this.wait = wait;

    this.lineWidth = this.max_r / 12;
}

function g_circle_draw2(g_circle){

    ctx.beginPath();

    ctx.arc(g_circle.x, g_circle.y, g_circle.r, 0, 2*Math.PI, false);
    
    ctx.fillStyle = g_circle.gradient;
    ctx.strokeStyle = g_circle.gradient;
    ctx.fill();
}

function update_circle_state2(g_circle) {
    if (g_circle.wait <= 0) {
        if (g_circle.time >= g_circle.max_time + NUM_RINGS_PER_BLOOM -  g_circle.ring) {
            g_circle.is_fading_away = true;
        }

        // TODO: Need to slow down near ending
        // g_circle.r = Math.min(Math.pow(g_circle.ring, 0.01) * (g_circle.r + 0.2), g_circle.max_r);
        if (g_circle.r >= g_circle.max_r) {
            g_circle.r = g_circle.max_r;
        } else {
            g_circle.r = g_circle.r + 1;
            // g_circle.r = -1 * Math.pow(g_circle.r, 2) + 2;
            console.log(-1 * Math.pow(g_circle.r, 2) + 2);
        }        
        if (g_circle.is_fading_away) {
            var blur = 6 / Math.pow(Math.E, g_circle.time / g_circle.max_time);
            g_circle.gradient = 'rgba(' + g_circle.red.toString() + ',' + g_circle.green.toString() + ',' + g_circle.blue.toString() + ',' + blur.toString() + ')';
        } else {
            var blur = Math.pow(2 / Math.pow(Math.E, g_circle.time / g_circle.max_time), -1);
            g_circle.gradient = 'rgba(' + g_circle.red.toString() + ',' + g_circle.green.toString() + ',' + g_circle.blue.toString() + ',' + blur.toString() + ')';
        }
        g_circle_draw2(g_circle);
        g_circle.time++;
    } else {
        g_circle.wait -= 1;
    }
}

function update_circle_state3(g_circle) {
    if (g_circle.wait <= 0) {
        if (g_circle.is_fading_away) {
                var blur = 8 / Math.pow(Math.E, g_circle.time / g_circle.max_time);
                g_circle.gradient = 'rgba(' + g_circle.red.toString() + ',' + g_circle.green.toString() + ',' + g_circle.blue.toString() + ',' + blur.toString() + ')';
                if (blur <= 0.0005) {
                    console.log('flicker');
                    for (var i = circle_array.length - 1; i >= 0; i--) {
                        if (circle_array[i].id == g_circle.id) {
                            circle_array.splice(i, 1);
                            return;
                        }
                    }
                    return;
                }
                g_circle_draw2(g_circle);
        } else {
            if (g_circle.time >= g_circle.max_time ) {
                g_circle.is_fading_away = true;
            }
            g_circle.r = g_circle.max_r * Math.log(1.5 + (g_circle.time / g_circle.max_time) * 20);
            var blur = Math.pow(2 / Math.pow(Math.E, g_circle.time / g_circle.max_time), -1);
            g_circle.gradient = 'rgba(' + g_circle.red.toString() + ',' + g_circle.green.toString() + ',' + g_circle.blue.toString() + ',' + blur.toString() + ')';

            if (g_circle.invisflag == 1) {
                g_circle.gradient = 'rgba(' + g_circle.red.toString() + ',' + g_circle.green.toString() + ',' + g_circle.blue.toString() + ',' + '0' + ')';
            }
            g_circle_draw2(g_circle);
        }
        g_circle.time++;
    } else {
        g_circle.wait--;
    }
}

function isColorValid2(r, g, b) {
    var isWhite = r > 200 && g > 200 && b > 200;
    var isBlack = r < 70 && g < 70 && b < 70;
    var isGray = Math.abs(r - g) < 40 && Math.abs(r - b) < 40 && Math.abs(g - b) < 40;
    if (isWhite || isBlack || isGray) {
        return false;
    } else {
        return true;
    }

}