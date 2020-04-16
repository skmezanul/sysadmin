#!/bin/bash

## i360deploy/av-deploy INFO
# Short Description :Deploy imunify360/ImunifyAV
# Description       :Installs imunify360/ImunifyAV repository
# Copyright         :Cloud Linux Zug GmbH
# License           :Cloud Linux Commercial License

# Do not edit/move/reformat this line except for actual version bump
# it is used by old versions of deploy scripts to check for update
version="2.10"

readonly package="imunify-antivirus"
readonly imunify360="imunify360-firewall"
readonly imunify_av="imunify-antivirus"


if [[ "$package" != "$imunify360" ]] && [[ "$package" != "$imunify_av" ]]; then
  exit 1
fi

if [[ "$package" = "$imunify360" ]]; then
    PRODUCT="Imunify360"
    COMMAND="imunify360-agent"
    STAND_ALONE_URL="https://docs.imunify360.com/stand_alone"
fi
if [[ "$package" = "$imunify_av" ]]; then
    PRODUCT="ImunifyAV"
    COMMAND="imunify-antivirus"
    STAND_ALONE_URL="https://docs.imunifyav.com/stand_alone_mode"
fi
set -o pipefail
# fail if any error: will not
#set -e
# error for unbound variable: not for now
#set -eu

run_with_retries()
{
    cmd=$1
    expected_error_text=$2
    ignore_res=$3

    timeout=15
    nattempts=10

    for ((i=1;i<=nattempts;i++)); do
        output=$( { $cmd ; } 2>&1 )
        res=$?
        if [ $res -eq 0 ] && [[ "$ignore_res" != "true" ]]; then
            echo "$output"
            break
        else
            if echo "$output" | grep -q "$expected_error_text"; then
                echo "$output"
                echo -n "Attempt #$i/$nattempts: to run $cmd."
                [ $i -ne $nattempts ] && echo "Retrying in $timeout seconds.."
                sleep $timeout
            else
                echo "$output"
                break
            fi
        fi
    done
    return $res
}

init_vars()
{
    scriptname=$(basename "$0")
    log=/var/log/${scriptname%.*}.log
    lock=/var/lock/${scriptname%.*}.lck

    wget="/usr/bin/wget"
    wget_options="-q"
    uninstall=false
    conversion=false
    beta=false

    # Update checker URL
    checksite="https://repo.imunify360.cloudlinux.com/defense360/"
    checksite_forcurl='https://defense360:nraW!F%40%24x4Xd6HHQ@repo.imunify360.cloudlinux.com/defense360/'
    upgradeurl="$checksite$scriptname"
    script="$scriptname"
    dry_run="0"
    script="$1"
    case "$script" in
        ./*) script="$(pwd)/$(basename "$script")" ;;
        /*) script="$script" ;;
        *) script="$(pwd)/$script" ;;
    esac
    script_run_args="$2"

    assumeyes=false
    modifying_call=false
    yum_beta_option=""
    yum_beta_repo_enable=0
    apt_force=""

    apt_allow_unauthenticated=""
    if [[ "$package" = "$imunify360" ]]; then
        # Virtuozzo 7 with kernel 3.10.0 or later has support for ipset in Container
        VZ_VERSION_LONG=3.10.0-327.10.1.vz7.12.8
        # Inside VZ version is provided without release
        VZ_VERSION_BRIEF=3.10.0

        datadir=/opt/alt/python35/share/imunify360

    fi
}

reopen_log()
{
    echo "-- $(date -R): $script $script_run_args --" >> "$log"
    chmod 0600 "$log"
}

detect_ostype()
{
    echo -n "Detecting ostype... "
    if [ ! -f /etc/os-release ]; then
        ostype=centos
    else
        source /etc/os-release
        if echo "$ID" "$ID_LIKE" | grep debian >/dev/null
        then
            ostype=debian
        else
            ostype=centos
        fi
    fi
    echo $ostype
}

is_ubuntu()
{
    source /etc/os-release
    [ "$ID" == "ubuntu" ]
}

is_debian()
{
    source /etc/os-release
    [ "$ID" == "debian" ]
}

check_debian_pkg_presence()
{
    test "$(dpkg-query --show --showformat='${db:Status-Status}\n' "$1" 2>/dev/null)" = "installed"
}

check_centos_pkg_presence()
{
    rpm --query "$1" >/dev/null
}

remove_debian_imunify()
{
    apt-get remove --autoremove --dry-run "$package"
    yesno "apt-get --AUTOREMOVE to remove $package plus \
    aforementioned packages [y] or just $package [n]"
    local res=$?
    if [ $res = 0 ]; then
        local autoremove="--autoremove"
    else
        local autoremove=""
    fi
    apt-get remove $autoremove -y "$package"
}

remove_centos_imunify()
{
    local yum_phprepo_option=--disablerepo=imunify360-alt-php,imunify360-ea-php-hardened
    yum remove -y $yum_beta_option $yum_phprepo_option \
    "$package" --setopt=clean_requirements_on_remove=1
}

get_debian_pkgs_manager() {
    pkgs_manager="apt-get"
}

get_centos_pkgs_manager() {
    pkgs_manager="yum"
}

remove_debian_pkgs()
{
    run_with_retries "apt-get remove -y $*" "Could not get lock"
}

remove_centos_pkgs()
{
    yum remove -y "$@"
}

install_debian_pkgs()
{
    local pkgs=$*
    run_with_retries "apt-get install -y $apt_allow_unauthenticated $apt_force $pkgs" "Could not get lock"

}

install_centos_pkgs()
{
    local pkgs=$*
    local yum_phprepo_option=--disablerepo=imunify360-alt-php,imunify360-ea-php-hardened
    yum install -y $yum_beta_option $yum_phprepo_option $pkgs
}

install_debian_ipset()
{
    install_debian_pkgs ipset
}

install_centos_ipset()
{
    yum install -y ipset
}

detect_first_install()
{
    if check_${ostype}_pkg_presence "$package" >/dev/null
    then
        first_install=false
    else
        first_install=true
    fi
}

is_systemctl_avail()
{
    command -v systemctl >/dev/null 2>&1
}

exit_with_error()
{
    echo "$@" | tee -a "$log"
    rm -rf "$lock"
    exit 1
}
check_exit_code() { if [ $? -ne "$1" ]; then exit_with_error "$2"; fi; }

# $1 = Message prompt
# Returns ans=0 for yes, ans=1 for no
yesno() {
    local YES=0
    local NO=1
    local PENDING=2

    if [ $dry_run -eq 1 ]; then
        echo "Would be asked here if you wanted to"
        echo "$1 (y/n - y is assumed)"
        local ans=$YES
    elif [ "$assumeyes" = "true" ]; then
        local ans=$YES
    else
        local ans=$PENDING
    fi

    while [ $ans -eq $PENDING ]; do
        echo -n "Do you want to $1 (y/n) ?" ; read -r reply
        case "$reply" in
            Y*|y*) ans=$YES ;;
            N*|n*) ans=$NO ;;
            *) echo "Please answer y or n" ;;
        esac
    done

    return "$ans"
}

# $1 = Full URL to download
# $2 = Optional basename to save to (if omitted, then = basename $1)
#      Also allow download to fail without exit if $2 is set
download_file() {
    if [ "$2" = "" ]; then
        dlbase="$(basename "$1")"
    else
        dlbase="$2"
    fi

    if [ $dry_run -eq 1 ]; then
        echo "Would download this URL to $dlbase :"
        echo "$1" ; echo
        return
    fi

    old_dlbase="$dlbase.old"
    if [ -f "$dlbase" ]; then
        rm -f "$old_dlbase"
        mv -f "$dlbase" "$old_dlbase"
    fi

    echo "Downloading $dlbase (please wait)"
    $wget $wget_options -O "$dlbase" "$1"

    if [ ! -s "$dlbase" ]; then
        if [ -f "$old_dlbase" ]; then
            mv -f "$old_dlbase" "$dlbase"
        fi
        if [ "$2" = "" ]; then
            echo "Failed to download $dlbase"
            rm -f "$lock"
            exit 1
        fi
    fi
}

# Make sure that we are running the latest version
# $* = Params passed to script
check_version() {
    echo "Checking for an update to $scriptname"
    script_from_repo="$scriptname.repo_version"
    download_file "$upgradeurl" "$script_from_repo"
    newversion=$(grep  "^version=" "$script_from_repo" | sed 's/[^0-9.]*//g')
    if [ -z "$newversion" ]; then
        newversion=$version
    fi

    if [ $dry_run -eq 1 ]; then
        echo "Would check if this running script (version $version) is out of date."
        echo "If it's been superseded, the new version would be downloaded and you'd be asked"
        echo "if you want to upgrade to it and run the new version."
        echo
        return
    fi

    local latest_version
    latest_version=$(echo -e "$version\\n$newversion" | sort --reverse --version-sort | head -1)
    if [ "$latest_version" = "$version" ]; then
        echo "$scriptname is already the latest version ($version) - continuing"
        rm -f "$script_from_repo"
    else
        echo "New version ($newversion) of $scriptname detected"
        if yesno "run $scriptname $newversion now"
        then
            echo "OK, executing $script_from_repo $*"
            mv -f "$script_from_repo" "$scriptname"
            chmod u+x "$scriptname"
            echo "Download of $scriptname $newversion successful"
            rm "$lock"
            echo "Run $script $script_run_args"
            exec "$script" --skip-version-check "$script_run_args"
            error "Failed to run $script $script_run_args"
        else
            echo "New version of script is available: $upgradeurl"
            echo "It was downloaded to $script_from_repo"
            echo "If you prefer to use current version, run it with \"--skip-version-check\" key."
            exit 1
        fi
    fi
}

save_debian_repo()
{
    install_debian_pkgs gnupg-curl
    apt-key adv --fetch-keys https://repo.imunify360.cloudlinux.com/defense360/RPM-GPG-KEY-CloudLinux

    echo "deb [arch=amd64] https://repo.imunify360.cloudlinux.com/imunify360/ubuntu/$VERSION_ID/ $VERSION_CODENAME main" \
        > /etc/apt/sources.list.d/imunify360.list

    if [ "$beta" = "true" ]; then
        echo "deb [arch=amd64] https://repo.imunify360.cloudlinux.com/imunify360/ubuntu-testing/$VERSION_ID/ $VERSION_CODENAME main" \
            > /etc/apt/sources.list.d/imunify360-testing.list
    fi

    if ! apt-get update 2>&1 | tee -a "$log"; then
        test "$dev_install" = true
        check_exit_code 0 "apt-get update error."
    fi
}

save_centos_repo()
{
    local RPM_KEY=$checksite/RPM-GPG-KEY-CloudLinux
    local RPM_KEY_forcurl=$checksite_forcurl/RPM-GPG-KEY-CloudLinux

    cat >/etc/yum.repos.d/imunify360.repo <<-EOF
[imunify360]
name=EL-$1 - Imunify360
baseurl=$checksite/el/$1/updates/x86_64/
enabled=1
gpgcheck=1
gpgkey=$RPM_KEY
EOF

    # add testing repo as disabled by default
    cat >/etc/yum.repos.d/imunify360-testing.repo <<-EOF
[imunify360-testing]
name=EL-$1 - Imunify360
baseurl=$checksite/el/$1/updates-testing/x86_64/
enabled=$yum_beta_repo_enable
gpgcheck=1
gpgkey=$RPM_KEY
EOF

    rpm --import "$RPM_KEY_forcurl" 2>&1 | tee -a "$log"
    check_exit_code 0 "RPM import error."
    modifying_call=true
}

remove_debian_repo()
{
    rm /etc/apt/sources.list.d/imunify360.list \
        /etc/apt/sources.list.d/imunify360-testing.list \
        /etc/apt/sources.list.d/imunify360-alt-php.list 2>/dev/null
}

remove_centos_repo()
{
    rm /etc/yum.repos.d/imunify360.repo \
    /etc/yum.repos.d/imunify360-testing.repo \
    /etc/yum.repos.d/imunify360-ea-php-hardened \
    /etc/yum.repos.d/imunify360-alt-php 2>/dev/null
}

remove_acronis_agent()
{
    [ ! -e /usr/bin/restore_infected ] && return

    if /usr/bin/restore_infected acronis extra is_installed 2> /dev/null
    then
        if yesno "remove Acronis agent"
        then
            /usr/bin/restore_infected acronis extra uninstall > /dev/null || :
        fi
    fi
}

terminate_detached_scans ()
{
    for file in /var/imunify360/aibolit/run/*/pid; do
        test -e "$file" && kill -9 "$(cat "$file")"
    done
    rm -rf /var/imunify360/aibolit/run/
    rm -rf /var/imunify360/aibolit/scans.pickle
}

version()
{
    local lhs=$1
    local op=$2
    local rhs=$3

    case $op in
        -lt) test "$(echo -e "$lhs\\n$rhs" | sort --version-sort | head -1)" = "$lhs" && \
            test "$lhs" != "$rhs"
            return $?
        ;;
        *) echo "function version(): operator $op is not supported."
            return 2
        ;;
    esac
}

check_debian_release()
{
    source /etc/os-release
    if ! ( [[ ("$VERSION_ID" == 9 || "$VERSION_ID" == 10) ]] && is_debian ) && ! ( [[ "$VERSION_ID" == 16.04 || "$VERSION_ID" == 18.04 ]] && is_ubuntu)
    then
        exit_with_error "You are running unsupported version of debian based OS. $PRODUCT supports only Ubuntu 16.04 and 18.04"
    fi

    if [ "$(uname -m)" != x86_64 ]
    then
        exit_with_error "You are running 32bit version of OS. $PRODUCT supports only 64bit version"
    fi
}

check_centos_release ()
{
    rpm -q --whatprovides redhat-release > /dev/null 2>&1
    check_exit_code 0 "There is no package providing /etc/redhat-release, please install redhat-release or centos-release first"

    ARCH=$(uname -i)

    # handle 32bit xen with x86_64 host kernel
    if (! rpm -q glibc.x86_64 > /dev/null 2>&1) || [ "$ARCH" != "x86_64" ] ; then
        exit_with_error "You are running 32bit version of OS. $PRODUCT supports only 64bit version"
    fi

    OS_VERSION="$(rpm -q --qf "%{version}" "$(rpm -q --whatprovides redhat-release)" | cut -c 1)"
    if [ "$OS_VERSION" -eq "5" ]; then
        exit_with_error "Version 5 is not supported, only CentOS/CloudLinux 6 and 7 are supported at the moment"
    fi
    if [ "$OS_VERSION" != 5 ] && [ "$OS_VERSION" != 6 ] && [ "$OS_VERSION" != 7 ]; then
        exit_with_error "Only CentOS/CloudLinux 6 and 7 are supported at the moment"
        if [[ "$package" = "$imunify360" ]] && [ -f /proc/vz/vestat ]; then
            if version "$(uname -r)" -lt $VZ_VERSION_BRIEF; then
                echo "You are inside VZ."
                echo "Virtuozzo 7 with kernel $VZ_VERSION_LONG or later has support for ipset in Containers."
                exit_with_error "Please upgrade your OpenVZ hypervisor kernel version to $VZ_VERSION_LONG or later."
            fi
        fi
    fi
}

backup ()
{
    # Nothing to backup so far.
    :
}

debian_prep ()
{
    apt-get clean 2>&1 | tee -a "$log"
    :
}

centos_prep ()
{
    yum clean all $yum_beta_option 2>&1 | tee -a "$log"
    :
}

detect_panel ()
{
    PANEL=""
    ROOT_PLESK_DIR="/usr/local/psa/admin/"
    ROOT_CPANEL_DIR="/usr/local/cpanel/whostmgr/docroot/"
    ROOT_IWORX_DIR="/usr/local/interworx/"
    ROOT_ISPMGR_DIR="/usr/local/ispmgr/"
    ROOT_DA_DIR="/usr/local/directadmin/"
    INTEGRATION_CONF_PATH="/etc/sysconfig/imunify360/integration.conf"
    if [ -f $INTEGRATION_CONF_PATH ] ; then
        PANEL="generic"
        # sanity check: the integration.conf is a valid ini-like file
        python -c "from ConfigParser import ConfigParser; conf = ConfigParser(); conf.read('$INTEGRATION_CONF_PATH')"  2>/dev/null
        check_exit_code 0 "syntax error in $INTEGRATION_CONF_PATH \
Read the manual https://docs.imunify360.com/stand_alone on how to create a valid config file."
        # sanity check: ui_path should be present in the config
        python -c "from ConfigParser import ConfigParser; conf = ConfigParser(); conf.read('$INTEGRATION_CONF_PATH'); print(conf.get('paths', 'ui_path'))" 2>/dev/null
        check_exit_code 0 "$PRODUCT has detected $INTEGRATION_CONF_PATH file from the stand-alone version of $PRODUCT. \
        Stand-alone version requires \"ui_path\" parameter specified in the $INTEGRATION_CONF_PATH. \
        Read the manual $STAND_ALONE_URL on how to create a valid config file."
    elif [ -d $ROOT_PLESK_DIR ]; then
        PANEL="plesk"
    elif [ -d $ROOT_CPANEL_DIR ]; then
        PANEL="cpanel"
    elif [ -d $ROOT_DA_DIR ]; then
        PANEL="directadmin"
    else
        exit_with_error "$PRODUCT has not detected any compatible hosting panel as well as integration.conf file to run the installation without a panel. \
Please, follow the instructions on $STAND_ALONE_URL"
    fi
}

# Only for imunify360-firewall
check_users() {
    CHECK_GROUPS="ossec"
    CHECK_USERS="ossec ossecr ossecm ossece"

    SYS_GID_MAX=$(awk '/^SYS_GID_MAX/ {print $2}' /etc/login.defs)
    SYS_UID_MAX=$(awk '/^SYS_UID_MAX/ {print $2}' /etc/login.defs)

    # detect SYS_GID_MAX, SYS_UID_MAX indirectly (Ubuntu 16.04)
    GID_MIN=$(awk '/^GID_MIN/ {print $2}' /etc/login.defs)
    UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
    if [ "$SYS_GID_MAX" = "" -a "$GID_MIN" != "" ]; then
        SYS_GID_MAX=$((GID_MIN - 1))
    fi
    if [ "$SYS_UID_MAX" = "" -a "$UID_MIN" != "" ]; then
        SYS_UID_MAX=$((UID_MIN - 1))
    fi

    for grp in $CHECK_GROUPS; do
        gid=$(getent group $grp 2> /dev/null | cut -d ':' -f 3)
        if [ -z "$gid" ]; then
            gid='-1'
        fi
        if [ "$SYS_GID_MAX" != "" ]; then
            if [ "$gid" -gt "$SYS_GID_MAX" ]; then
                exit_with_error "Non-system group $grp already exists"
            fi
            elif [ "$first_install" = "true" -a "$gid" != "-1" ]; then
            exit_with_error "Group $grp already exists"
        fi
    done
    for usr in $CHECK_USERS; do
        uid=$(id -u "$usr" 2>/dev/null || echo -1)
        if [ "$SYS_UID_MAX" != "" ]; then
            if [ "$uid" -gt "$SYS_UID_MAX" ]; then
                exit_with_error "Non-system user $usr already exists"
            fi
            elif [ "$first_install" = "true" -a "$uid" != "-1" ]; then
            exit_with_error "User $usr already exists"
        fi
    done
}


# Only for imunify360-firewall
remove_hardened_php_repos()
{
    if [[ $ostype = centos ]]; then
        ALT_PHP=imunify360-alt-php.repo
        EA_PHP=imunify360-ea-php-hardened.repo
        REPOS_DIR=/etc/yum.repos.d

        # fix permissions
        for REPO in $ALT_PHP $EA_PHP; do
            test -f $REPOS_DIR/$REPO || continue
            chattr -i $REPOS_DIR/$REPO
            chmod 644 $REPOS_DIR/$REPO
        done

        # remove unconditionally
        rm -f $REPOS_DIR/$ALT_PHP
        rm -f $REPOS_DIR/$EA_PHP
    fi
}

print_help ()
{
    cat << EOF >&2
Usage:

  -h, --help            Print this message
  --version             Print script's version and exit
  -k, --key <key>       Deploy $PRODUCT with activation key
  -c, --uninstall	Uninstall $PRODUCT
  --skip-version-check  Do not check for script updates
  --skip-registration   Do not register, just install (the default)
  --dev-install         Turn off software defect reporting
  --beta                Install packages from 'testing' repo
  --check               Check if imunify360 Agent can be installed and exit
  -y, --yes             Assume "yes" as answer to all prompts and run non-interactively
EOF
}

print_version()
{
    echo "$scriptname $version"
}

# Only for imunify360-firewall
set_low_resource_usage_mode_if_necessary()
{
  imunify360_low_mem_limit=2147483648
  # total usable memory in bytes
  mem_total=$(</proc/meminfo awk '$1 == "MemTotal:" { print $2 * 1024 }')
  if (( mem_total < imunify360_low_mem_limit )); then
    # enable "Low Resource Usage" mode
    imunify360-agent config update '{"MOD_SEC": {"ruleset": "MINIMAL"}, "WEBSHIELD": {"enable": false}, "OSSEC": {"active_response": true}}'
  fi
}

# Lets start

# if environment has umask=0000 (if called from plesk extension), all created files have -rw-rw-rw- permission
umask 0022

init_vars "$0" "$*"
reopen_log

if [ -f "$lock" ] ; then
    if [ -d "/proc/$(cat "$lock")" ] ; then
        exit_with_error "$scriptname is already running"
    fi
fi

echo $$ > "$lock"
check_exit_code 0 "Please run $scriptname as root"

options=$(getopt -o ychk: -l yes,uninstall,help,version,check,skip-version-check,skip-registration,beta,dev-install,force,apt-force,key: -- "$@")
res=$?

if [ "$res" != 0 ]; then
    print_help
    rm -f "$lock"
    exit 1
fi

eval set -- "$options"

while true; do
    case "$1" in
        -h|--help)
            print_help
            rm -f "$lock"
            exit 0
        ;;
        --version)
            print_version
            rm -f "$lock"
            exit 0
        ;;
        -y|--yes)
            assumeyes=true
            shift
        ;;
        -c|--uninstall)
            uninstall=true
            shift
        ;;
        -k|--key)
            conversion=true
            activationkey="$2"
            shift 2
        ;;
        --skip-version-check)
            skipversioncheck=true
            shift
        ;;
        --skip-registration)
            registration=false
            shift
        ;;
        --beta)
            beta=true
            yum_beta_option="--enablerepo=imunify360-testing"
            yum_beta_repo_enable=1
            shift
        ;;
        --dev-install)
            dev_install=true
            apt_allow_unauthenticated=--allow-unauthenticated
            shift
        ;;
        --force|--apt-force)  # used for Plesk extension installation
            export DEBIAN_FRONTEND=noninteractive
            apt_force='-o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew'
            shift
        ;;
        --check)
            detect_ostype
            check_${ostype}_release
            EXIT_CODE=$?
            rm -f "$lock"
            exit $EXIT_CODE
        ;;
        --)
            shift
            break
        ;;
        -*)
            echo "$0: error - unrecognized option $1" 1>&2
            print_help
            rm -f "$lock"
            exit 1
        ;;
        *) exit_with_error "Internal error!" ;;
    esac
done

detect_ostype
check_${ostype}_release
detect_first_install
if [[ "$package" = "$imunify360" ]]; then
    check_users
    remove_hardened_php_repos
fi

if [ "$skipversioncheck" = "true" ]; then
    echo "Skipping check version"
else
    check_version "$*"
fi

if [ "$conversion" = "true" ] && [ "$uninstall" = "true" ] ; then
    exit_with_error "invalid combination";
fi

if [ "$conversion" = "false" ] && [ "$registration" != "false" ] ; then
    # Register by IP is the default now
    conversion=true
    activationkey=false
fi

if [ "$uninstall" = "true" ]; then
    remove_acronis_agent
    remove_${ostype}_imunify 2>&1 | tee -a "$log"
    terminate_detached_scans

    remove_${ostype}_repo

    echo "Uninstall complete." | tee -a "$log"
    exit 0
fi

detect_panel

if [[ "$package" = "$imunify_av" ]]; then
    if check_${ostype}_pkg_presence imunify360-firewall; then
        echo "You are trying to install ImunifyAV over Imunify360 that already includes it. You can open Malware Scanner via UI Imunify360 -> Malware Scanner."
        exit 1
    fi
fi

if [[ "$package" = "$imunify360" ]]; then
    if ! check_${ostype}_pkg_presence ipset
    then
        install_${ostype}_ipset 2>&1 | tee -a "$log"
        check_exit_code 0 "Package ipset was not installed."
    fi

    if ! ipset list -n -t >/dev/null
    then
        exit_with_error "Your OS virtualization technology $(systemd-detect-virt 2>/dev/null || virt-what >/dev/null || echo of unknown type) has limited support for ipset in containers. Please, contact Imunify360 Support Team."
    fi

    if check_${ostype}_pkg_presence imunify-antivirus; then
        get_${ostype}_pkgs_manager
        echo "You are about to uninstall ImunifyAV and install Imunify360 that includes Malware Scanner. To get ImunifyAV back run the following commands:
        # $pkgs_manager remove 'imunify360-firewall*'
        # wget https://repo.imunify360.cloudlinux.com/defence360/av-deploy.sh
        # bash ./av-deploy.sh"

        if yesno "Do you agree to proceed with uninstalling ImunifyAV?"; then
            remove_${ostype}_pkgs 'imunify-antivirus' 2>&1 | tee -a "$log"
        else
            exit 1
        fi
    fi
fi

if [ "$first_install" = "true" ]; then
    echo "In a few moments the script will install latest $package" \
    "package (w/dependencies)... (Ctrl-C to cancel)"
    sleep 4
    save_${ostype}_repo "$OS_VERSION"

    install_${ostype}_pkgs $package 2>&1 | tee -a "$log"
    check_exit_code 0 "Package $package was not installed."

    modifying_call=true
fi

case "$PANEL" in
    cpanel)
        if [[ "$package" = "$imunify360" ]]; then
            if [ -f '/etc/cpanel/ea4/is_ea4' ] ; then
                echo "Installing mod_security" | tee -a "$log"
                install_${ostype}_pkgs ea-apache24-mod_security2 | tee -a "$log"
            fi
        fi
        echo "Installing $PRODUCT cPanel plugin..." | tee -a "$log"
        # Disabling ea\alt-php repos as far as, repo.alt.cloudlinux.com
        # requires a few minutes to register the new server_id. That
        # happens, because the repos was generated just a few seconds ago
        # while agent registration.
        # Only after some period of time that the repos became valid.
        install_${ostype}_pkgs "$package-cpanel" 2>&1 | tee -a "$log"
        check_exit_code 0 "Failed to install $PRODUCT cPanel plugin."
        modifying_call=true
        ;;
    directadmin)
        if [[ "$package" = "$imunify360" ]]; then
            pushd /usr/local/directadmin/custombuild/
            da_webserver="$(grep ^webserver= options.conf | sed s/webserver=//)"
            da_modsecurity="$(grep ^modsecurity= options.conf | sed s/modsecurity=//)"
            if [ "$da_webserver" != apache -a "$da_webserver" != litespeed ]
            then
                echo "Imunify modsecurity ruleset is not supported for $da_webserver webserver."
            else
                if [ "$da_modsecurity" != yes ]; then
                    echo "Installing DirectAdmin modsecurity..." | tee -a "$log"
                    # create options.conf backup file before edit
                    # with name e.g. options.conf.bak_2018-03-29.1522323911
                    sed -i.bak_"$(date +%F.%s)" \
                    -e "s/^modsecurity=.*/modsecurity=yes/" \
                    -e "s/^modsecurity_ruleset=.*/modsecurity_ruleset=no/" options.conf
                    ./build modsecurity
                else
                    echo "Installing DirectAdmin modsecurity... already installed!" | tee -a "$log"
                fi
                modifying_call=true
            fi
            popd
        fi
        echo "Installing $PRODUCT DirectAdmin plugin..." | tee -a "$log"
        # Disabling ea\alt-php repos as far as, repo.alt.cloudlinux.com
        # requires a few minutes to register the new server_id. That
        # happens, because the repos was generated just a few seconds ago
        # while agent registration.
        # Only after some period of time that the repos became valid.
        install_${ostype}_pkgs "$package-directadmin" 2>&1 | tee -a "$log"

        check_exit_code 0 "Failed to install $PRODUCT DirectAdmin plugin."
        ;;
    generic)
        echo "Installing $PRODUCT generic panel plugin..." | tee -a "$log"
        install_${ostype}_pkgs "$package-generic" 2>&1 | tee -a "$log"
        check_exit_code 0 "Failed to install $PRODUCT generic panel plugin."
        ;;
    plesk)
        if [[ "$package" = "$imunify360" ]]; then
            if ! /usr/local/psa/bin/server_pref --show-web-app-firewall >/dev/null 2>&1 \
                || ! ls /usr/local/psa/admin/sbin/modsecurity_ctl >/dev/null 2>&1
            then
                # There appears to be a bug in Plesk - when installation is triggered via UI, using Plesk extension,
                # i360deploy process somehow receives a SIGTERM from `plesk installer` process.
                # See comments in https://cloudlinux.atlassian.net/browse/DEF-7450 for details.
                # TODO: re-check this bug after installation is re-worked in https://cloudlinux.atlassian.net/browse/DEF-9061
                if [ "$I360_FROM_PLESK_EXTENSION" != 1 ]; then
                    echo "Installing mod_security" | tee -a "$log"
                    run_with_retries "plesk installer --select-release-current --install-component modsecurity" "BUSY: Update operation was locked by another update process" "true" | tee -a "$log"
                fi
            fi
            install_${ostype}_pkgs imunify360-firewall-plesk | tee -a "$log"
            check_exit_code 0 "Failed to install Imunify360 Plesk plugin."
            modifying_call=true
        fi
        if [[ "$package" = "$imunify_av" ]]; then
            echo "ImunifyAV for Plesk panel is available in Plesk Extension Catalog."
        fi
        ;;
    ispmgr)
        if [[ "$package" = "$imunify_av" ]]; then
            echo "ImunifyAV for ISPmanager is available inside the panel under \"modules\" as it is pre-installed."
        fi
        ;;
    *)
        echo "UI plugin is not installed."
        echo "No supported hosted panel detected and $INTEGRATION_CONF_PATH file is missing."
        ;;
esac

if [ "$conversion" = "true" ] ; then
    backup
    ${ostype}_prep

    if [[ "$package" = "$imunify360" ]]; then
        echo -n "Checking if has already been registered... " | tee -a "$log"
        imunify360-agent --console-log-level ERROR rstatus | tee -a "$log"
        rstatus=$?
        if [ "$rstatus" = 11 ] ; then
            exit_with_error "Registration server general error."
        fi
        if [ "$rstatus" = 0 -a "$activationkey" != false ] ; then
            echo -n "Unregister the previous registration key... " | tee -a "$log"
            imunify360-agent --console-log-level WARNING unregister 2>&1 | tee -a "$log"
        fi

        if [ "$activationkey" != false ] ; then
            echo -n "Register by key... " | tee -a "$log"
            imunify360-agent --console-log-level WARNING register "$activationkey" 2>&1 | tee -a "$log"
            check_exit_code 0 "Registration was not successful. Exiting."
        elif [ "$rstatus" != 0 ] ; then
            # "$rstatus" != 0 check because it is no sense to re-register
            # by IP (in comparison with re-register by activation key)
            echo -n "Register by IP... " | tee -a "$log"
            imunify360-agent --console-log-level WARNING register IPL 2>&1 | tee -a "$log"
        fi
        if [[ $? != 0 ]]; then
            echo "Registration was not successful." | tee -a "$log"
        else
            echo "Successfully registered" | tee -a "$log"
        fi
        $datadir/scripts/disable_3rd_party_ids

        if is_systemctl_avail; then
            systemctl enable imunify360.service >&1 | tee -a "$log"
            systemctl start imunify360 >&1 | tee -a "$log"
        else
            /sbin/chkconfig --add imunify360 >&1 | tee -a "$log"
            /sbin/service imunify360 start >&1 | tee -a "$log"
        fi
    fi
    if [[ "$package" = "$imunify_av" ]]; then
        if imunify-antivirus rstatus >/dev/null 2>&1; then
            if [ "$activationkey" == false ]; then
                echo "Already registered" | tee -a "$log"
                exit 0
            fi

            imunify-antivirus unregister >/dev/null 2>&1
        fi

        if [ "$activationkey" != false ] && imunify-antivirus register "$activationkey" >/dev/null 2>&1; then
            echo "Registered by key" | tee -a "$log"
        else
            echo "Not registered" | tee -a "$log"
        fi

        imunify-antivirus rstatus >/dev/null 2>&1

        if is_systemctl_avail; then
            systemctl start "$package" >&1 | tee -a "$log"
        else
            /sbin/service minidaemon start >&1 | tee -a "$log"
        fi
    fi
    check_exit_code 0 "Failed to start $package service."

    agent_start_success=false

    echo "Waiting for $PRODUCT to start..."

    for i in {1..10}; do
        if $COMMAND version |& tee -a "$log"
        then
            echo "$PRODUCT is started" | tee -a "$log"
            agent_start_success=true
            break
        else
            sleep 60
        fi
    done

    if ! $agent_start_success; then
        echo "Something went wrong during $PRODUCT start up" | tee -a "$log"
        exit_with_error "See /var/log/imunify360/error.log for details"
    fi

    if [[ "$package" = "$imunify360" ]]; then
        # agent is started
        if [ "$first_install" = "true" ]; then
            set_low_resource_usage_mode_if_necessary
        fi
        #force-disable WebShield
        if [ "$PANEL" = "generic" ] ; then
            imunify360-agent config update '{"WEBSHIELD": {"enable": false}}'
        fi
    fi

elif ! $COMMAND rstatus >/dev/null 2>&1
then
    echo "You have to register this software with registration key:" | tee -a "$log"
    echo "  $script --key <key>" | tee -a "$log"
fi

if $modifying_call; then
    echo "Success" | tee -a "$log"
    echo "You can find complete log in /var/log/${scriptname%.*}.log"
fi
rm -f "$lock"
exit 0
