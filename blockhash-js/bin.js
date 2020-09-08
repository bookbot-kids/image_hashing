#!/usr/bin/env node
var blockhash = require('.');


var PNG = require('png-js');
var jpeg = require('jpeg-js');
var fs = require('fs');
var path = require('path');
var tiff = require('decode-tiff');

var inputPath = process.argv[2];
var ext = path.extname(inputPath);
data = new Uint8Array(fs.readFileSync(inputPath));
if(ext == ".jpg") {
	var imgData = jpeg.decode(data, {maxMemoryUsageInMB: 1024, maxResolutionInMP: 500});
	hash = blockhash.blockhashData(imgData, 16, 2);
	console.log(hash);
} else if(ext == ".png") {
	var png = new PNG(data);
	var imgData = {
	    width: png.width,
	    height: png.height,
	    data: new Uint8Array(png.width * png.height * 4)
	};

	png.decodePixels(function(pixels) {
	    png.copyToImageData(imgData, pixels);
	    hash = blockhash.blockhashData(imgData, 16, 2);
		console.log(hash);
	});
} else if(ext == ".tiff") {
	var imgData = tiff.decode(data);
	hash = blockhash.blockhashData(imgData, 16, 2);
	console.log(hash);
}


