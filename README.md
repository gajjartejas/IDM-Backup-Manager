# IDM Backup Manager (AutoIt v3)

[![Language: AutoIt](https://img.shields.io/badge/Language-AutoIt%20v3-blue.svg)](https://www.autoitscript.com/)
[![License: ISC](https://img.shields.io/badge/License-ISC-green.svg)](LICENSE)
[![Status: Historical Archive](https://img.shields.io/badge/Status-Historical%20Archive%20(2013--2016)-orange.svg)]()

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
* **Modular Codebase**: Contains the complete historical development progression (Builds 1 through 11) developed between 2013 and 2016.

---

## 📁 Repository Structure

```
├── IDM BUILD_11/             # Latest production release version (v1.0.0 / v1.1.0)
│   ├── IDM Backup Manager.au3 # Main AutoIt v3 script
│   ├── Forms/                # Koda Form Designer definitions (.kxf)
│   ├── Includes/             # Core AutoIt helper libraries (.au3)
│   ├── Resources/            # Application icons and GUI assets
│   ├── Help/                 # Documentation and user manuals
│   └── License.txt           # Build license notice
├── IDM BUILD_1/ to 10/       # Chronological development revisions (Builds 1–10)
├── Extra/                    # Release notes and auxiliary packaging specs
└── idm1/ to idm final_3/     # Early prototypes and legacy versions
```

---

## 🛠️ Prerequisites & Building from Source

### Requirements
* [AutoIt v3](https://www.autoitscript.com/site/autoit/downloads/) (v3.3.8 or newer)
* [SciTE4AutoIt3](https://www.autoitscript.com/site/autoit-script-editor/) (recommended for editing and compilation)

### External Tools (Optional)
To maintain compliance with open-source repository guidelines and prevent antivirus heuristic false positives, external binary tools have been excluded from this repository. If compiling or running specific compression features from source:

1. **7-Zip Command Line & DLLs (`7z.exe`, `7-zip32.dll`, `7-zip64.dll`)**:
   - Download the official package from [7-Zip.org](https://www.7-zip.org/).
   - Place `7-zip32.dll` and `7-zip64.dll` into the respective `IDM BUILD_11/` or your system directory.
2. **UPX Executable Packer (`upx.exe`)**:
   - If you want to compress compiled binaries, download UPX from [upx.github.io](https://upx.github.io/).
3. **Resource Hacker (`ResHacker.exe`)**:
   - If customizing embedded application resources, obtain Resource Hacker directly from [Angus Johnson's official site](http://www.angusj.com/resourcehacker/).

---

## 📄 License

This software is released under the ISC / Permissive Open Source License. See [LICENSE](LICENSE) for full details.

```
Copyright (c) 2012-2016, Gajjar Tejas

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.
```
