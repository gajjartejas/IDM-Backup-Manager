# IDM Backup Manager (AutoIt v3)

[![Language: AutoIt](https://img.shields.io/badge/Language-AutoIt%20v3-blue.svg)](https://www.autoitscript.com/)
[![License: ISC](https://img.shields.io/badge/License-ISC-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)]()
[![Compatible: AutoIt v3.3.18+](https://img.shields.io/badge/Compatible-AutoIt%20v3.3.18%2B-blueviolet.svg)]()

An open-source configuration backup and migration utility written in AutoIt v3 for managing download queues, categories, temporary directories, and configuration settings.

---

## ⚠️ Legal Disclaimer & Trademark Notice

* **Independent Software**: This project is an independent, community-developed utility created for configuration management and personal data migration.
* **No Affiliation**: This project is **not** affiliated with, endorsed by, authorized by, or in any way associated with **Tonec Inc.** or the official developers of **Internet Download Manager (IDM)**.
* **Trademarks**: "Internet Download Manager" and "IDM" are registered trademarks of Tonec Inc. All product and company names, trademarks, and registered trademarks cited herein are the property of their respective holders. Their reference in this project is strictly for software interoperability and identification purposes only.
* **No Bypass or Cracking**: This project contains **no** crack tools, keygens, patchers, serials, or trial reset mechanisms. It solely manages user configuration and queue metadata backups.

---

## 📋 Features

* **Complete Profile Backup**: Backup download lists, incomplete downloads metadata, schedule queues, and custom category rules.
* **Multi-Profile Support**: Manage multiple backup archives and restore them across machines or clean OS reinstalls.
* **Password Sanitizer**: Clean stored server and site authentication credentials prior to sharing or migrating configuration profiles.
* **Modern AutoIt v3.3.18+ Compatibility**: Updated syntax, standard includes, and error-free Au3Check validation.
* **Automated Build Pipeline**: Includes PowerShell (`build.ps1`) and CMD (`build.bat`) build automation.

---

## 📁 Repository Structure

```
├── IDM Backup Manager.au3    # Main application entry point script
├── Forms/                    # Koda Form Designer definitions (.kxf)
├── Includes/                 # Modular AutoIt helper libraries (.au3)
├── Resources/                # Application icons, GUI bitmaps, and assets
├── Help/                     # User documentation and manual (.docx, .htm, images)
├── Build/                    # Inno Setup open-source installer script (installer.iss)
├── build.ps1                 # Automated PowerShell compilation & packaging pipeline
├── build.bat                 # One-click Windows batch compilation launcher
├── History.txt               # Chronological version changelog
├── CmdLine.txt               # Command line arguments specification
├── LICENSE                   # Open-source ISC license
├── README.md                 # Project documentation
└── .gitignore                # Git ignore rules for build artifacts & temp files
```

---

## 🛠️ Building from Source

### Requirements
* [AutoIt v3](https://www.autoitscript.com/site/autoit/downloads/) (v3.3.8 or v3.3.18+ installed)
* [Inno Setup 6](https://jrsoftware.org/isinfo.php) (optional, for building the Windows Setup installer: `winget install JRSoftware.InnoSetup -e`)
* [SciTE4AutoIt3](https://www.autoitscript.com/site/autoit-script-editor/) (optional, for editing)

### One-Click Build
Run either of the automated build scripts:

- **PowerShell**:
  ```powershell
  # Builds both portable executable and Inno Setup installer (if installed)
  .\build.ps1

  # Build 64-bit architecture
  .\build.ps1 -Arch x64

  # Build standalone executable only (skip setup installer)
  .\build.ps1 -NoInstaller
  ```

- **Command Prompt**:
  ```cmd
  build.bat
  ```

The build pipeline will:
1. Automatically locate your local AutoIt installation.
2. Run syntax verification with `Au3Check.exe` (verifies 0 errors / 0 warnings).
3. Compile the executable into `bin\IDM Backup Manager.exe` with embedded icon and metadata.
4. Compile the Windows setup installer into `bin\IDM_Backup_Manager_Setup.exe` via Inno Setup 6.

---

## 📦 External Dependencies & 7-Zip Engine

To keep the Git repository lightweight and free of tracked binary blobs, third-party binary libraries are excluded from source control:

1. **7-Zip Compression Libraries (`7-zip32.dll`, `7-zip64.dll`)**:
   - **Automated**: The build script (`build.ps1` / `build.bat`) automatically downloads the verified 7-Zip archiver DLLs directly from the project release assets into `bin\` if not present.
   - **Packaged**: The Inno Setup installer packages these DLLs alongside the main application executable, ensuring the installed program runs out-of-the-box.
   - **Direct Download**: If building offline or setting up manually, download them from the [v1.1.0 Release Assets](https://github.com/gajjartejas/IDM-Backup-Manager/releases/tag/v1.1.0) and place them in the `bin/` directory.

2. **Optional Tools**:
   - **UPX Executable Packer (`upx.exe`)**: If compressing compiled binaries, obtain UPX from [upx.github.io](https://upx.github.io/).
   - **Resource Hacker (`ResHacker.exe`)**: If customizing resource icons, obtain it from [Angus Johnson's official site](http://www.angusj.com/resourcehacker/).

---

## 📄 License

This software is released under the ISC / Permissive Open Source License. See [LICENSE](LICENSE) for full details.

```
Copyright (c) 2012-2016, Gajjar Tejas

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.
```
