# Swap File Manager - Magisk Module

Automatically creates and manages a 1GB swap file on rooted Android devices.

## Features
- Creates 1GB swap file at `/data/swap.img`
- Automatically sets swap priority below ZRAM
- Survives reboots via Magisk service script
- Logs all activity to `/data/local/tmp/logs/swap.log`

## Requirements
- Rooted device with Magisk
- Tested on: Redmi Note 9 (MIUI 12, Android 10)

## Installation
1. Download latest ZIP from [Releases](../../releases)
2. Open Magisk → Modules → Install from storage
3. Select the ZIP and reboot

## Verify after reboot
```bash
su -c "cat /proc/swaps"
```

## Log location

```bash 
/data/local/tmp/logs/swap.log
```

## Compatibility
- Android 9+ recommended
- Any device with Magisk installed
- ZRAM priority is automatically detected — no hardcoded values

## Author
Yash Saxena
