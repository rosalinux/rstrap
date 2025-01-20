#!/bin/bash

create_dnf_conf() {
  local path="$1"
  local release="$2"
  local arch="$3"
  local abf_downloads="https://abf-downloads.rosa.ru"

  mkdir -p "$path/etc/dnf"

  cat > "$path/etc/dnf/dnf.conf" <<EOL
[main]
keepcache=1
debuglevel=2
reposdir=/dev/null
retries=20
obsoletes=1
gpgcheck=0
assumeyes=1
syslog_ident=mock
syslog_device=
install_weak_deps=0
metadata_expire=60s
best=1

[${release}_main_release]
name=${release}_main_release
baseurl=${abf_downloads}/${release}/repository/${arch}/main/release
gpgcheck=0
enabled=1

[${release}_main_updates]
name=${release}_main_updates
baseurl=${abf_downloads}/${release}/repository/${arch}/main/updates
gpgcheck=0
enabled=1
EOL
  echo "dnf.conf has been created at $path/etc/dnf/dnf.conf"
}

install_packages() {
  local path="$1"
  local arch="$2"

  local config_path="$path/etc/dnf/dnf.conf"
  local pkgs="basesystem-minimal passwd systemd openssh-server dnf rosa-repos"

  dnf --config "$config_path" --nodocs --forcearch "$arch" --installroot "$path" install $pkgs
}

execute_in_chroot() {
  local path="$1"
  local command="$2"

  chroot "$path" /bin/bash -c "$command"
}

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 --arch=<arch> --distro=<distro> --path=<path>"
  exit 1
fi

for arg in "$@"
do
  case $arg in
    --arch=*)
      arch="${arg#*=}"
      shift
      ;;
    --distro=*)
      release="${arg#*=}"
      shift
      ;;
    --path=*)
      path="${arg#*=}"
      shift
      ;;
    *)
      echo "Invalid argument: $arg"
      exit 1
      ;;
  esac
done

if [[ -z $arch || -z $release || -z $path ]]; then
  echo "Error: Missing one or more required arguments"
  exit 1
fi

create_dnf_conf "$path" "$release" "$arch"
install_packages "$path" "$arch"
execute_in_chroot "$path" "passwd -d root"
# enable sshd example
# execute_in_chroot "$path" "systemctl enable sshd"
