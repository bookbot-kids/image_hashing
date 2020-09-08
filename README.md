# image_hashing

# How to build binary:
- Clone repo https://github.com/commonsmachinery/blockhash-js into folder `blockhash-js`
- Install package by command `npm install -g pkg`
- In `blockhash-js/package.json`, add `"bin": "bin.js",`
- Make sure to copy `bin.js` file into `blockhash-js`
- `cd` to the `blockhash-js` folder
- Run `node install` to install dependencies
- Run `pkg .` to generate binaries for mac, linux, windows
