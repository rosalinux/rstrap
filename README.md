# rstrap Script README

## Overview

The `rstrap` script is a tool designed to create a chroot environment for a specified architecture and distribution. It sets up the necessary configuration files and installs base packages using DNF package manager.

## Usage

To use the `rstrap` script, run the following command:

```
/usr/bin/rstrap --arch=<arch> --distro=<distro> --path=<path>
```

### Arguments

- `--arch=<arch>`: Specifies the target architecture (e.g., `riscv64`, `loongarch64`, `aarch64`).
- `--distro=<distro>`: Specifies the target distribution (e.g., `rosa13`).
- `--path=<path>`: Specifies the path where the root filesystem will be created.

### Example

```
/usr/bin/rstrap --arch=riscv64 --distro=rosa13 --path=/var/lib/rootfs/rosa13_root
```

## Requirements

To ensure the script works properly, you need to install the following packages:

```
sudo dnf install qemu-riscv64-static qemu-loongarch64-static qemu-aarch64-static
```

Additionally, restart the systemd-binfmt service to enable QEMU binary format support:

```
sudo systemctl restart systemd-binfmt
```

## What the Script Does

1. **Creates `dnf.conf` Configuration File**:
   - The script generates a `dnf.conf` file under the specified path with necessary repository settings.

2. **Installs Base Packages**:
   - It installs essential packages such as `basesystem`, `systemd`, `openssh-server`, `dnf`, and `rosa-repos` into the specified chroot environment using the generated `dnf.conf`.

3. **Sets Up Root Password**:
   - Once the chroot environment is created, the script removes the root password by executing `passwd -d root` inside the chroot.

## Important Notes

- Ensure that you have sufficient permissions to execute the script and to run `dnf` commands with `sudo`.
- The `qemu-*` packages are necessary for emulating different architectures, and restarting `systemd-binfmt` ensures that the binary format support is properly configured.
