FROM rosalab/rosa13:latest

RUN dnf --nogpgcheck --refresh --assumeyes --nodocs --setopt=install_weak_deps=False upgrade \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && dnf --nogpgcheck --assumeyes --setopt=install_weak_deps=False --nodocs install mock git coreutils curl sudo builder-c 'dnf-command(builddep)' 'dnf5-command(builddep)' procps-ng tar locales-en \
 findutils util-linux wget rpmdevtools sed grep xz gnupg hostname python3-yaml python3-magic \
 && sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
 && echo "%mock ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && adduser omv \
 && usermod -a -G mock omv \
 && cp -a /etc/skel /home/omv \
 && chown -R omv:omv /home/omv \
 && chown -R omv:mock /etc/mock \
 && dnf --assumeyes autoremove \
 && dnf clean all \
 && rm -rf /var/cache/dnf/* \
 && rm -rf /var/lib/dnf/yumdb/* \
 && rm -rf /var/lib/dnf/history/* \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /usr/share/licenses /tmp/*

RUN rm -rf /var/lib/dnf/yumdb/* \
 && rm -rf /var/cache/dnf/* \
 && rm -rf /var/lib/rpm/__db.*

ENTRYPOINT ["/usr/bin/builder"]
