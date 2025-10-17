
#!/bin/sh

[ -d $HOME/opt/starship ] && export PATH=$PATH:$HOME/opt/starship
[ -d $HOME/opt/minikube ] && export PATH=$PATH:$HOME/opt/minikube
[ -d /usr/local/go ] && export PATH=$PATH:/usr/local/go/bin
[ -d $HOME/go/bin ] && export PATH=$PATH:$HOME/go/bin
[ -d $HOME/.scripts ] && export PATH=$PATH:$HOME/.scripts
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env


