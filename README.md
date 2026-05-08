# Swap File Manager - Magisk Module

![Magisk](https://img.shields.io/badge/Magisk-24%2B-orange)
![Android](https://img.shields.io/badge/Android-9%2B-green)

Automatically creates and manages a configurable swap file on rooted Android devices using Magisk.

## Features

- Creates swap file automatically after boot
- Volume-key based installer selection
- Choose swap size during installation:
  - 512MB
  - 1024MB
  - 2048MB
- Automatically enables swap on every boot
- Automatically applies swappiness
- Automatically keeps ZRAM at higher priority
- Creates persistent config file:
  `/data/adb/swap-manager.conf`
- Logs all activity to:
  `/data/local/tmp/logs/swap.log`

---

## Requirements

- Rooted Android device
- Magisk installed
- Kernel with swapfile support

---

## Installation

1. Download latest ZIP from Releases
2. Open Magisk
3. Go to Modules
4. Tap "Install from storage"
5. Select module ZIP
6. Choose swap size using volume keys:
   - Volume Up = Next option
   - Volume Down = Select
7. Reboot device

---

## Verify After Reboot

```bash
su -c "cat /proc/swaps"
```

Expected output should contain:

```text
/data/swap.img
```

## Log Location 

```bash
/data/local/tmp/logs/swap.log
```

## Config File

```bash
/data/adb/swap-manager.conf
```

Example:

```properties
SWAP_SIZE_MB=1024
SWAPPINESS=100
```

## Compatibility 

- Android 9+
- Magisk 24+
- Works with ZRAM-enabled devices
- System automatically handles swap priority
- Tested on:
  - Redmi Note 9
  - MIUI 12
  - Android 10/11

# Notes 

- Swap file is created only if missing
- Existing swap file is reused on reboot
- ZRAM remains preferred automatically
- No hardcoded swap priorities used

## Author 

Yash Saxena