# image_hashing

# How to build blockhash-js binary
- Clone repo https://github.com/commonsmachinery/blockhash-js into folder `blockhash-js`
- Install package by command `npm install -g pkg`
- In `blockhash-js/package.json`, add `"bin": "bin.js",`
- Make sure to copy `bin.js` file into `blockhash-js`
- `cd` to the `blockhash-js` folder
- Run `npm install` to install dependencies
- Run `pkg .` to generate binaries for mac, linux, windows

# How to build blockhash-python binary
- Clone repo https://github.com/commonsmachinery/blockhash-python
- Install `pyinstaller` by running `pip install pyinstaller`
- Install `image` module by `pip install image`
- `cd` to the cloned repo, and type `pyinstaller --onefile blockhash.py`
- Go to `dist/blockhash` to get the executable file
- If there is an error like `OSError: Python library not found: libpython3.7m.dylib, Python, .Python, libpython3.7.dylib, Python3`, try to reinstall python via `env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.7.3` then reinstall `pyinstaller` by `pip uninstall pyinstaller` and `pip install pyinstaller`
- If the binary has error `../../../include/python3.7m/pyconfig.h could not be extracted`, then try to reinstall `pyinstaller` as above step, then follow [this issue](https://github.com/pyinstaller/pyinstaller/issues/2367#issuecomment-410377854) to edit in `/Users/{username}/.pyenv/versions/3.7.3/Python.framework/Versions/3.7/lib/python3.7/site-packages/PyInstaller` folder. After that, run `pyinstaller --onefile blockhash.py` again
- Run the same commands on windows to build exe binary