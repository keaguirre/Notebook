FROM rockylinux:9
RUN dnf update -y && \
    dnf upgrade -y && \
    dnf install -y ncurses && \
    dnf install -y wget && \
    dnf install -y git && \
    dnf install -y vim && \
    dnf install -y man-db

    #install bat
RUN mkdir /bat && \
    curl -o /bat/bat.zip -L https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz && \
    tar -xvzf /bat/bat.zip && \
    mv bat-v0.24.0-x86_64-unknown-linux-musl /usr/local/bat && \
    echo 'alias bat="/usr/local/bat/bat"' >> /root/.bashrc && \
    exec bash

    # install starship
RUN dnf install -y 'dnf-command(copr)' && \
    dnf copr enable -y atim/starship && \
    dnf install -y starship && \
    echo 'eval "$(starship init bash)"' >> /root/.bashrc && \
    mkdir -p /root/.config && \
    curl -o /root/.config/starship.toml https://raw.githubusercontent.com/keaguirre/LinuxCheatSheet/main/starship.toml && \
    exec bash


# install, java, jboss
RUN dnf install -y java-1.8.0-openjdk.x86_64 && \
    java -version
    #alternatives --display java


# run
#docker run -it --name rocky-container rockylinux:9
#docker run -it -w /root --name rocky-container -v C:\Users\kevin\OneDrive\Escritorio\mirrorvol:/root rockylinux:9