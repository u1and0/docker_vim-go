# Usage:
# docker run -it --rm -v `pwd`:/work -w /work u1and0/golang

FROM u1and0/neovim:latest

# gopath setting
ENV GOPATH="/root/go"\
    PATH="$PATH:$GOPATH/bin"

# Install go
RUN pacman -Sy --noconfirm go &&\
    go get\
        github.com/nsf/gocode \
        github.com/alecthomas/gometalinter \
        golang.org/x/tools/cmd/goimports \
        golang.org/x/tools/cmd/guru \
        golang.org/x/tools/cmd/gorename \
        github.com/golang/lint/golint \
        github.com/rogpeppe/godef \
        github.com/kisielk/errcheck \
        github.com/jstemmer/gotags \
        github.com/klauspost/asmfmt/cmd/asmfmt \
        github.com/fatih/motion \
        github.com/zmb3/gogetdoc \
        github.com/zmb3/gogetdoc \
        github.com/josharian/impl &&\
    rm -rf ${GOPATH}/src/*

RUN nvim +GoInstallBinaries +q &&\
    rm -rf ${GOPATH}/src/*

ENTRYPOINT ["/bin/bash"]

LABEL maintainer="u1and0 <e01.ando60@gmail.com>"\
      description="my golang env with neovim"\
      description.ja="自分用golang開発環境with neovim"\
      version="vim-go:v1.2.0"
