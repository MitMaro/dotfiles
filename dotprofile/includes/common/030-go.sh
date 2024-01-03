go_version="${GO_VERSION:-1.20}"

export PATH="$(brew --prefix go)@${go_version}/bin:$PATH"
