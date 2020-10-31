
CM_INTELLIJ_VERSION="2020.2.3"
SCRIPT_DIR=$(dirname $(readlink -f "$0"))

installDefault() {
    echo "Atualizando e instalando os pacotes padrao"
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y \
        net-tools \
        vim \
        git \
        wget \
        curl \
        tree \
        build-essential \
        python2.7 \
        docker.io

    echo "Instalando nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
    source ~/.bashrc
    nvm install node

    echo "Instalando sdkman e dependências"
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    source ~/.bashrc
    sdk install java
}

installChrome() {
    echo "Instalando o chrome" 
    sudo apt install -y libxss1 libappindicator1 libindicator7
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
}

installVSCode() {
    echo "Instalando o VSCode"
    wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
    sudo apt install -y ./vscode.deb
}

installIntelliJ() {
    INTELLIJ_VERSION=$CM_INTELLIJ_VERSION

    echo "Instalando o IntelliJ $INTELLIJ_VERSION"
    if [[ ! -f "/tmp/install/${INTELLIJ_VERSION}.tar.gz" ]]; then
        echo "Baixando versão $INTELLIJ_VERSION"
        wget -O "/tmp/install/${INTELLIJ_VERSION}.tar.gz" "https://download.jetbrains.com/idea/ideaIU-$INTELLIJ_VERSION.tar.gz"
    else
        echo "Versão $INTELLIJ_VERSION já existe"
    fi

    if [[ -d "/opt/IntelliJ/${INTELLIJ_VERSION}" ]]; then
        echo "Removendo instalação anterior"
        rm -rf "/opt/IntelliJ/${INTELLIJ_VERSION}"
    fi

    echo "Instalando nova versão"
    mkdir -p "/opt/IntelliJ/${INTELLIJ_VERSION}"
    tar -xzf "/tmp/install/${INTELLIJ_VERSION}.tar.gz" -C "/opt/IntelliJ/${INTELLIJ_VERSION}"

    echo "Criando link para o atual"
    rm -rf /opt/IntelliJ/current
    ln -s /opt/IntelliJ/${INTELLIJ_VERSION}/idea*/ /opt/IntelliJ/current
}

installFunctions() {
    echo "Copiando funções e aliases"
    cd $SCRIPT_DIR/.bash_functions ~/.bash_functions
    cp $SCRIPT_DIR/.bash_aliases ~/.bash_aliases
    cp $SCRIPT_DIR/.gitconfig ~/.gitconfig

    if ! grep -q '~/.bash_functions' ~/.bashrc; then
        echo "Aplicando funções no .bashrc"
        cat >> ~/.bashrc <<'EOL'
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

PS1='${debian_chroot:+($debian_chroot)}:\[\033[01;34m\]\W\[\033[00m\]\$ '
EOL
    fi

}


list="
all
default
chrome
vscode
intellij
functions
"

if ! $(echo $list | grep -qw "$1"); then
  echo "Use um dos seguintes valores: $list"
  exit 0
fi

if [[ ! -d /tmp/install ]]; then
  sudo chown "$USER:$USER" /opt
  mkdir -p /tmp/install
fi
cd /tmp/install

if [[ "$1" == "default" ]] || [[ "$1" == "all" ]]; then
  installDefault
fi

if [[ "$1" == "chrome" ]] || [[ "$1" == "all" ]]; then
  installChrome
fi

if [[ "$1" == "vscode" ]] || [[ "$1" == "all" ]]; then
  installVSCode
fi

if [[ "$1" == "intellij" ]] || [[ "$1" == "all" ]]; then
  installIntelliJ
fi

if [[ "$1" == "functions" ]] || [[ "$1" == "all" ]]; then
  installFunctions
fi
