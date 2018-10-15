function createBloom2(counter, iParam) {
    windowHeight = canvas.height;
    windowWidth = canvas.width;
    var svgW = windowWidth;
    var svgH = windowHeight;

    var numRings = NUM_RINGS_PER_BLOOM;
    numRings = Math.floor((10 + Math.abs(smoothedData[iParam] / 10)) / 10);

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
    randomPaletteIndex = NUM_PALETTES - 1;
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
        while (!isColorValid(pixelData[0], pixelData[1], pixelData[2])) {
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
            s: Math.floor(colors[i].s + 50, 100),
            v: colors[i].v
        }
    }

    var rgbColors = [];
    for (var i = 0; i < colors.length; i++) {
        rgbColors.push(HSVtoRGB(colors[i]));
    }

    // Initial Radius
    var init_r = 10;
    var max_radius = init_r + Math.abs(smoothedData[iParam] / 10);
    var i = numRings;
    circle_array.push(new g_circle_t2(counter, 1, 40, x, y, init_r, init_r + max_radius, rgbColors[i-1].r, rgbColors[i-1].g, rgbColors[i-1].b, max_radius * 2, 0));
}

function g_circle_t2(counter, opacity, wait, x, y, min_r, max_r, red, green, blue, max_time, invisflag){
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

    // Radius of the circle
    this.max_r = max_r;
    this.r = min_r;
    this.min_r = min_r;

    console.log(this.r);

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
        if (g_circle.time >= g_circle.max_time) {
            g_circle.is_fading_away = true;
        }

        g_circle.r = Math.min(g_circle.r + 1, g_circle.max_r);

        if (g_circle.is_fading_away) {
            var blur = g_circle.time / g_circle.max_time;
            blur = (1 - (g_circle.time / g_circle.max_time)) * g_circle.opacity;
            console.log(blur);
            g_circle.gradient = 'rgba(' + g_circle.red.toString() + ',' + g_circle.green.toString() + ',' + g_circle.blue.toString() + ',' + blur.toString() + ')';
        }
        g_circle_draw2(g_circle);
        g_circle.time++;
    } else {
        g_circle.wait -= 1;
    }
}