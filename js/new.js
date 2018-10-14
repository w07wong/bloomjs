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
    // Y position of bloom = second derivative scaled by some constant
    var secondDerivative = firstDerivative2 - firstDerivative1;
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

    var init_r = 10;

    var y = Math.abs(secondDerivative) * 3 % svgH;
}