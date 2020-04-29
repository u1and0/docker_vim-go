# Usage:
# docker run -it --rm -v `pwd`:/work -w /work u1and0/golang

FROM u1and0/zplug:latest

# Install go
RUN sudo pacman -Syu --noconfirm go &&\
    pacman -Qtdq | xargs -r sudo pacman --noconfirm -Rcns
# pacman -Scc の代わり

ARG LOUSER=u1and0
USER ${LOUSER}
WORKDIR /home/${LOUSER}

# gopath setting
# go get より前に指定する
ENV GO111MODULE="on"\
    GOPATH="/home/${LOUSER}/go"\
    PATH="$PATH:$GOPATH/bin"

# Install go tools
RUN go get\
        github.com/golangci/golangci-lint \
        golang.org/x/tools/cmd/goimports \
        golang.org/x/tools/cmd/guru \
        golang.org/x/tools/cmd/gorename \
        golang.org/x/lint/golint \
        golang.org/x/tools/gopls \
        github.com/rogpeppe/godef \
        github.com/kisielk/errcheck \
        github.com/jstemmer/gotags \
        github.com/klauspost/asmfmt/cmd/asmfmt \
        github.com/fatih/motion \
        github.com/zmb3/gogetdoc \
        github.com/josharian/impl \
        github.com/stamblerre/gocode
        # rm -rf ${GOPATH}/src/*  # Do not remove cache for source code

# Include `ghq` source
# Install GO-REPL
RUN go get\
    github.com/motemen/gore/cmd/gore \
    github.com/k0kubun/pp &&\
    yay -Syu --noconfirm ghq &&\
    : "Remove cache" &&\
    pacman -Qtdq | xargs -r sudo pacman --noconfirm -Rcns

COPY lazy.toml /home/${LOUSER}/.config/dein/
# 同じlazy.tomlの内容なのに`COPY lazy.toml`しないと
# +GoUpdateBinariesが走らない
RUN nvim +GoUpdateBinaries +q

LABEL maintainer="u1and0 <e01.ando60@gmail.com>"\
      description="golang env with neovim"\
      description.ja="golang開発環境with neovim"\
      version="vim-go:v2.1.0"
