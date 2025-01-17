# Base image
FROM archlinux:base-devel

# Install dependencies
RUN pacman -Syu --needed --noconfirm pacman-contrib namcap git base-devel openssh

# Add multilib repository
RUN printf '[multilib]\nInclude = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
RUN pacman -Sy

# Setup user
RUN useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
WORKDIR /home/builder
USER builder

# Install paru
RUN git clone https://aur.archlinux.org/paru-bin.git
RUN cd paru-bin && makepkg -si --noconfirm

# Copy files
COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh
COPY ssh_config /ssh_config

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
