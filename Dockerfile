# Usage:
# docker run -it --rm -v `pwd`:/work -w /work u1and0/golang

FROM u1and0/neovim:latest

# gopath setting
ENV GOPATH="/root/go"\
    PATH="$PATH:$GOPATH/bin"

# Install go
RUN pacman -Syu --noconfirm go &&\
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns
# pacman -Scc の代わり

# Install go tools
RUN go get\
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
        github.com/josharian/impl
    # rm -rf ${GOPATH}/src/*  勉強のためあえて消さない 以下同様

RUN nvim +GoInstallBinaries +q
    # rm -rf ${GOPATH}/src/*

# Update my dotfiles
# Include `ghq` source
RUN git remote rm origin &&\
    git remote add --fetch origin https://github.com/u1and0/dotfiles.git &&\
    git checkout develop && git pull

# Install GO-REPL
RUN go get\
    github.com/motemen/gore/cmd/gore \
    github.com/mdempsky/gocode \
    github.com/k0kubun/pp
RUN sudo -u aur yay -Syu --noconfirm ghq


ENV GO111MODULE="on"
WORKDIR "${GOPATH}/src"
CMD ["/bin/bash"]

LABEL maintainer="u1and0 <e01.ando60@gmail.com>"\
      description="my golang env with neovim"\
      description.ja="自分用golang開発環境with neovim"\
      version="vim-go:v1.3.0"
