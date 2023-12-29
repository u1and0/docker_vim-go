# Usage:
# docker run -it --rm -v `pwd`:/work -w /work u1and0/golang

FROM u1and0/zplug:arm64

# Install go
USER root
RUN pacman -Syu --noconfirm go &&\
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns
# pacman -Scc の代わり

# gopath setting
# go install より前に指定する
USER u1and0
ENV GO111MODULE="on"\
    GOPATH="/home/u1and0/go"\
    PATH="$GOPATH/bin:$PATH"

# May be included vim-go GoUpdateBinaries command
# Install go tools
# RUN go install \
#         golang.org/x/tools/gopls@latest \
#         golang.org/x/tools/cmd/goimports@latest \
#         golang.org/x/tools/cmd/guru@latest \
#         golang.org/x/tools/cmd/gorename@latest &&\
#     go clean -cache
# RUN go get -u \
#         github.com/golangci/golangci-lint/cmd/golangci-lint \
#         golang.org/x/lint/golint \
#         github.com/rogpeppe/godef \
#         github.com/kisielk/errcheck \
#         github.com/jstemmer/gotags \
#         github.com/klauspost/asmfmt/cmd/asmfmt \
#         github.com/fatih/motion \
#         github.com/zmb3/gogetdoc \
#         github.com/josharian/impl \

# Install vim-go & LSP server
RUN nvim +GoUpdateBinaries +LspInstallServer +q && go clean -cache

# Install REPL
RUN go install github.com/x-motemen/gore/cmd/gore@latest &&\
    go install github.com/stamblerre/gocode@latest &&\
    go install github.com/codegangsta/gin@latest &&\
    go clean -cache
    # go install github.com/k0kubun/pp@latest &&\

LABEL maintainer="u1and0 <e01.ando60@gmail.com>"\
      description="golang env with neovim"\
      description.ja="golang開発環境with neovim"\
      version="vim-go:v3.0.1"
