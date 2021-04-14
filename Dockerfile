FROM archlinux/base

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm reflector
RUN reflector --verbose --latest 50 --sort rate --save /etc/pacman.d/mirrorlist
RUN pacman -S --noconfirm base-devel pacman-contrib git sudo

RUN sed -i '/MAKEFLAGS=/s/^#//g' /etc/makepkg.conf
RUN sed -i '/MAKEFLAGS/s/-j1/-j$(($(nproc)+1))/g' /etc/makepkg.conf

RUN useradd -m builduser
RUN echo 'builduser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/builduser

RUN cd /home/builduser && \
    su -c 'git clone https://aur.archlinux.org/yay-bin.git' builduser && \
    cd yay-bin && \
    su -c 'makepkg -sri --noconfirm' builduser && \
    cd .. && rm -rf yay

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
