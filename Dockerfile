# Usage:
# docker run -it --rm -v `pwd`:/work -w /work u1and0/golang

FROM u1and0/neovim:latest

# Install go
RUN : "pacman -Syu --noconfirmとしないのは :: libsystemd を core/systemd-libs に置き換えますか？ [Y/n] するため" &&\
    yes | pacman -Syu go &&\
    yes | pacman -Scc
RUN go get \
        github.com/nsf/gocode \
        github.com/alecthomas/gometalinter \
        golang.org/x/tools/cmd/goimports \
        golang.org/x/tools/cmd/guru \
        golang.org/x/tools/cmd/gorename \
        golang.org/x/lint/golint \
        github.com/rogpeppe/godef \
        github.com/kisielk/errcheck \
        github.com/jstemmer/gotags \
        github.com/klauspost/asmfmt/cmd/asmfmt \
        github.com/fatih/motion \
        github.com/zmb3/gogetdoc \
        github.com/zmb3/gogetdoc \
        github.com/josharian/impl &&\
    rm -rf ${GOPATH}/src/*

# Install go binraries associated with vim-go
RUN nvim +GoInstallBinaries +q &&\
    rm -rf ${GOPATH}/src/*

# Reinstall packages required by zplug
RUN pacman -Syu --noconfirm zsh awk git fd ripgrep &&\
    yes | pacman -Scc &&\
    rm -rf /root/.zplug &&\
    git clone --depth 1 https://github.com/zplug/zplug /root/.zplug

# Install zplug plugins
RUN zsh -ic "source /root/.zshrc &&\
            source /root/.zplug/init.zsh &&\
            source /root/.zplug.zsh &&\
            zplug install"

RUN chsh -s /usr/bin/zsh root
RUN pacman -Syu --noconfirm rsync &&\
    yes | pacman -Scc

# gopath setting
ENV GOPATH="/root/go" \
    PATH="$PATH:$GOPATH/bin" \
    GO111MODULE=on

CMD /usr/bin/zsh

LABEL maintainer="u1and0 <e01.ando60@gmail.com>"\
      description="my golang env with neovim"\
      description.ja="自分用golang開発環境with neovim"\
      version="vim-go:zplug1.2.0"
