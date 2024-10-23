#!/bin/bash

# Check if a Slackware release is provided
if [ $# -ne 1 ]; then
    echo "Specify Slackware release"
    exit 1
fi

# Initialize variables to find the fastest mirror
#fastest_mirror=""
#fastest_time=999999


declare -A mirror_times
# List of rsync mirrors
mirrors=(
    "rsync://slackware.zero.com.ar/slackware/"
    "rsync://ftp.iinet.net.au/pub/slackware/"
    "rsync://ftp.swin.edu.au/slackware/"
    "rsync://mirror.digitalpacific.com.au/slackware/"
    "rsync://mirror.internode.on.net/slackware/"
    "rsync://syd.mirror.rackspace.com/slackware/"
    "rsync://mirror.telepoint.bg/slackware/"
    "rsync://mirrors.linux-bulgaria.org/slackware/"
    "rsync://mirrors.netix.net/slackware/"
    "rsync://mirrors.slackware.bg/slackware/"
    "rsync://mirrors.unixsol.org/slackware/"
    "rsync://slackware.telecoms.bg/slackware/"
    "rsync://ftp.slackware-brasil.com.br/slackware/"
    "rsync://linorg.usp.br/slackware/"
    "rsync://mirrors.slackware.devl.club/slackware/"
    "rsync://slackjeff.com.br/slackware/"
    "rsync://mirror.datacenter.by/slackware/"
    "rsync://mirror.csclub.uwaterloo.ca/slackware/"
    "rsync://mirror.its.dal.ca/slackware/"
    "rsync://mirrors.bfsu.edu.cn/slackware/"
    "rsync://mirrors.ucr.ac.cr/slackware/"
    "rsync://ftp.linux.cz/pub/linux/slackware/"
    "rsync://download.dlackware.com/slackware/"
    "rsync://ftp.tu-chemnitz.de/ftp/pub/linux/slackware/"
    "rsync://ftp6.gwdg.de/pub/linux/slackware/"
    "rsync://linux.rz.rub.de/slackware/"
    "rsync://mirror.de.leaseweb.net/slackware/"
    "rsync://mirror.netcologne.de/slackware/"
    "rsync://mirrors.dotsrc.org/slackware/"
    "rsync://mirror.cedia.org.ec/slackware/"
    "rsync://nephtys.lip6.fr/ftp/pub/linux/distributions/slackware/"
    "rsync://slackware.mirrors.ovh.net/ftp.slackware.com/"
    "rsync://lon.mirror.rackspace.com/slackware/"
    "rsync://mirror.bytemark.co.uk/slackware/"
    "rsync://rsync.mirrorservice.org/ftp.slackware.com/pub/slackware/"
    "rsync://slackware.uk/slackware/"
    "rsync://ftp.cc.uoc.gr/slackware/"
    "rsync://ftp.ntua.gr/slackware/"
    "rsync://hkg.mirror.rackspace.com/slackware/"
    "rsync://mirror-hk.koddos.net/slackware/"
    "rsync://mirror.slackware.hr/slackware/"
    "rsync://quantum-mirror.hu/slackware/"
    "rsync://iso.ukdw.ac.id/iso/slackware/"
    "rsync://repo.ukdw.ac.id/slackware/"
    "rsync://mirror.garr.it/slackware/"
    "rsync://ftp.nara.wide.ad.jp/slackware/"
    "rsync://ftp.riken.go.jp/slackware/"
    "rsync://repo.jing.rocks/slackware/"
    "rsync://rsync.slackware.jp/slackware/"
    "rsync://mirrors.atviras.lt/slackware/"
    "rsync://slackware.laukas.lt/slackware/"
    "rsync://mirrors.qontinuum.space/slackware/"
    "rsync://mirror.ihost.md/slackware/"
    "rsync://mirror.lagoon.nc/slackware/"
    "rsync://bear.alienbase.nl/mirrors/slackware/"
    "rsync://ftp.nluug.nl/slackware/"
    "rsync://mirror.koddos.net/slackware/"
    "rsync://mirror.nl.leaseweb.net/slackware/"
    "rsync://ftp.slackware.org.nz/slackware/"
    "rsync://mirror.rise.ph/slackware/"
    "rsync://mirror.onet.pl/pub/mirrors/slackware/"
    "rsync://slackware.pl/slackware/"
    "rsync://sunsite.icm.edu.pl/slackware/"
    "rsync://ftp.rnl.tecnico.ulisboa.pt/pub/slackware/"
    "rsync://mirrors.nav.ro/slackware/"
    "rsync://mirrors.nxthost.com/slackware/"
    "rsync://mirror1.sox.rs/slackware/"
    "rsync://mirror.tspu.edu.ru/slackware/"
    "rsync://mirror.yandex.ru/slackware/"
    "rsync://slackware.tsu.ru/slackware/"
    "rsync://mirror.lyrahosting.com/slackware/"
    "rsync://ftp.acc.umu.se/mirror/slackware.com/"
    "rsync://ftpmirror.infania.net/slackware/"
    "rsync://download.nus.edu.sg/slackware/"
    "rsync://mirror.wheel.sk/slackware/"
    "rsync://depo.turkiye.linux.web.tr/slackware/"
    "rsync://ftp.linux.org.tr/slackware/"
    "rsync://ifconfig.com.ua/slackware/"
    "rsync://slackware.ip-connect.info/slackware/"
    "rsync://dfw.mirror.rackspace.com/slackware/"
    "rsync://ftp.slackware.com/slackware/"
    "rsync://ftp.ussg.indiana.edu/slackware/"
    "rsync://mirror.fcix.net/slackware/"
    "rsync://mirror.slackbuilds.org/slackware/"
    "rsync://mirror2.sandyriver.net/pub/slackware/"
    "rsync://mirrors.kernel.org/slackware/"
    "rsync://mirrors.ocf.berkeley.edu/slackware/"
    "rsync://mirrors.syringanetworks.net/slackware/"
    "rsync://mirrors.xmission.com/slackware/"
    "rsync://plug-mirror.rcac.purdue.edu/slackware/"
    "rsync://rsync.lug.udel.edu/slackware/"
    "rsync://slackblog.com/slackware/"
    "rsync://slackware.cs.utah.edu/slackware/"
    "rsync://slackware.mirrors.tds.net/slackware/"
    "rsync://ftp.is.co.za/IS-Mirror/ftp.slackware.com/pub/"
    "rsync://ftp.wa.co.za/pub/slackware/"
    "rsync://mirror.ac.za/slackware/"
    "https://repo.ukdw.ac.id/slackware/"
)

# Loop through mirrors and ping each one
for mirror in "${mirrors[@]}"; do
    # Extract the hostname (remove protocol and path)
    hostname=$(echo "$mirror" | awk -F'/' '{print $3}')
    
    # Ping the mirror hostname and get the average response time
    ping_time=$(ping -c 1 -W 1 "$hostname" | grep 'time=' | awk -F 'time=' '{print $2}' | awk '{print $1}')
    
    # If the ping was successful and we got a valid time
    if [[ -n "$ping_time" ]]; then
        echo "Pinged $hostname: $ping_time ms"
        # Store the mirror and its ping time in the associative array
        mirror_times["$mirror"]="$ping_time"
    else
        echo "Failed to ping $hostname"
    fi
done

# Check if any mirrors responded
if [ ${#mirror_times[@]} -eq 0 ]; then
    echo "No mirrors responded."
    exit 1
fi

# Sort the mirrors by their ping times and print the top 3
echo "Top 3 fastest mirrors:"
for mirror in "${!mirror_times[@]}" ; do
    echo "$mirror ${mirror_times[$mirror]}"
done | sort -k2 -n | head -n 3


echo "test......over"
exit

# Change to the specified directory
cd "$1" || { echo "Failed to change directory to $1"; exit 1; }

# Perform rsync with the fastest mirror found
# shellcheck disable=SC2154
if rsync --delete -rlptDvz "$fastest_mirror/slackware-$1" .; then
    echo "Successfully synced with $fastest_mirror"
else
    echo "Failed to sync with $fastest_mirror"
fi
