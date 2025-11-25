# Building BurnBin Executable

This guide explains how to build a standalone executable for BurnBin.

## Quick Build

1. **Run the build script**:
   ```bash
   build_exe.bat
   ```

   This will:
   - Check for PyInstaller (install if missing)
   - Clean previous builds
   - Build the executable
   - Show the output location

2. **Find your executable**:
   - Location: `dist\BurnBin.exe`
   - Size: ~30-50 MB (includes all dependencies)

## Manual Build

If you prefer to build manually:

```bash
# Install PyInstaller
pip install pyinstaller

# Build using the spec file
pyinstaller BurnBin.spec

# Or build with command line options
pyinstaller --onefile --windowed --name BurnBin main.py
```

## What Gets Bundled

The executable includes:
- ✅ All Python dependencies (Flask, Werkzeug, etc.)
- ✅ Tkinter GUI framework
- ✅ All application code

**Not included** (users need these separately):
- ❌ Python interpreter (bundled in EXE)
- ❌ cloudflared (must be installed on user's system)

## Distribution

1. **Distribute the executable**:
   - `dist\BurnBin.exe` - Single file, ready to run
   - No installation required
   - Works on Windows 10/11

2. **User requirements**:
   - Windows 10 or later
   - cloudflared installed (see README.md for installation)

## Troubleshooting

### Build fails with "ModuleNotFoundError"
- Make sure all dependencies are installed: `pip install -r requirements.txt`
- Install PyInstaller: `pip install pyinstaller`

### Executable is very large
- This is normal - PyInstaller bundles Python and all dependencies
- Typical size: 30-50 MB
- You can use UPX compression (already enabled in spec file)

### Executable doesn't run
- Check Windows Defender/antivirus (may flag new executables)
- Ensure cloudflared is installed on the target system
- Check Windows Event Viewer for error details

### Uploads directory not created
- The executable creates the `uploads` folder next to the EXE
- Make sure the EXE has write permissions in its directory

## Advanced Options

Edit `BurnBin.spec` to customize:
- Icon file (add `icon='path/to/icon.ico'`)
- Additional data files
- Hidden imports
- UPX compression settings

