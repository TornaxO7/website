+++
title = "Systemd"
[extra]
homepage = "https://systemd.io/"
logo_url = "https://brand.systemd.io/assets/svg/systemd-logomark.svg"
+++

Ok, this might sound stupid why I listed `systemd` here but the reason is, thanks to [NixOS]
and being part of it, I learned a lot while [refactoring the crowdsec module](https://github.com/NixOS/nixpkgs/pull/446307) and editing my config about
how to work with systemd.

Also thanks to [NixOS] alone I started to understand how many features `systemd` has (and why some people claim that it sucks):
Yes it has _a lot_ of features but they are also useful!

You can

- manage your network settings with [systemd-network]
- prepare directories, links, files with [systemd-tmpfiles]
- create your [services]
- [read the system logs](https://man7.org/linux/man-pages/man8/systemd-journald.service.8.html)
- use it as your [boot manager](https://man7.org/linux/man-pages/man7/systemd-boot.7.html)

and so much more. It's **huge**!

[NixOS]: https://nixos.org/
[systemd-network]: https://man7.org/linux/man-pages/man5/systemd.network.5.html
[systemd-tmpfiles]: https://man7.org/linux/man-pages/man8/systemd-tmpfiles.8.html
[services]: https://man7.org/linux/man-pages/man5/systemd.service.5.html
