# wgproton

A container for keeping open ports via NAT-PMP on [ProtonVPN](https://protonvpn.com)

## Usage

```
podman run --cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_MODULE --sysctl='net.ipv4.conf.all.src_valid_mark=1' -v /tmp/protonportmapping:/portmapping -v /tmp/protonwgconfig:/config ghcr.io/dezza/wgproton:latest
```

### Environment variables

```
PORT1=50001 # default values ...
PORT2=50002
PORT3=50003
PORT4=50004
PORT5=50005 # use `null` to disable a port

# optional
ROUTESUBNET= # read 'Routing' section below
ROUTEGATEWAY=
ROUTEDEV=
```

### Portmapping directory

In `/portmapping` there will be 5 files visible

```sh
[ct@host wgproton]$ ls /tmp/protonportmapping
1  2  3  4  5
```

and each of these will contain the public port mapped:

```sh
[ct@host wgproton]$ cat /tmp/protonportmapping/*
34901
52345
40123
41123
56543
```

## Routing

**NOTE:** If you are using a network driver that isn't [pasta](https://passt.top/passt/about/) this shouldn't be necessary.

The necessity for these environment-variables became apparent when I tried to switch from default `--network slirp4netns` to `--network pasta` (available with [podman --network mode](https://docs.podman.io/en/latest/markdown/podman-run.1.html#network-mode-net)). For some reason pasta does not add a default route to your local subnet. This means that if you want to reach your hosted services locally via exposed ports `--publish|-p|--expose` you will have to add a route to your local subnet. If no environment variable is supplied for `ROUTESUBNET` this script simply isn't executed and no route will be added. The effect will be that no matter if you publish your ports while using `--network pasta` your services will not be available if you try to access the port on the local IP.

The minimal viable setup is simply setting the `ROUTESUBNET` variable e.g. `ROUTESUBNET=10.0.0.0/24` this will then be passed to `ip route add` and make your services available for your network.

The environment variables `ROUTEGATEWAY` and `ROUTEDEV` shouldn't be necessary normally they will be inferred the default gateway and device of `ip route` but they exist as an option for being explicit.

## Credits

[linuxserver.io](https://linuxserver.io) container: `linuxserver/wireguard` that this image is based on

Stefano Brivio (sbrivio), helping with pasta route.

Olivier Duclos ([odyssey](https://sleepycat.fr/)), reviewing and suggesting improvements to scripts
