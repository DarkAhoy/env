
#!/bin/sh

[ -d $HOME/opt/starship ] && export PATH=$PATH:$HOME/opt/starship
[ -d $HOME/opt/minikube ] && export PATH=$PATH:$HOME/opt/minikube
[ -d /usr/local/go ] && export PATH=$PATH:/usr/local/go/bin
[ -d $HOME/go/bin ] && export PATH=$PATH:$HOME/go/bin
[ -d $HOME/.scripts ] && export PATH=$PATH:$HOME/.scripts
[ -d $HOME/Library/Python/3.9/bin ] && export PATH=$PATH:$HOME/Library/Python/3.9/bin
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env
[ -d $HOME/src/depot_tools ] && export PATH=$PATH:/$HOME/src/depot_tools
[ -d /opt/homebrew/opt/libpq/bin ] && export PATH=$PATH:/opt/homebrew/opt/libpq/bin


