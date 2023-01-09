#!/usr/bin/env bash

upgrade=0
repo="git@github.com:sistematico/sf-scripts.git"
examples="git@github.com:sistematico/tailwind-examples.git"
dest="$HOME/github"

[ $EUID -eq 0 ] && orig=/usr/local/bin || orig=$HOME/.local/bin

[ ! -d $dest ] && \mkdir -p $dest
[ ! -d $orig ] && \mkdir -p $orig

if [ ! -d $dest/sf-scripts ]; then
    echo -e "[\e[1;33m*\e[0m] Clonando o repositório $repo em $dest/sf-scripts..."
    git clone $repo $dest/sf-scripts >/dev/null 2>/dev/null
else
    echo -e "[\e[1;34m*\e[0m] O diretório $dest/sf-scripts já existe."
fi

if [ ! -d $dest/tailwind-examples ]; then
    echo -e "[\e[1;33m*\e[0m] Clonando o repositório $examples em $dest/tailwind-examples..."
    git clone $examples $dest/tailwind-examples >/dev/null 2>/dev/null
else
    echo -e "[\e[1;34m*\e[0m] O diretório $dest/tailwind-examples já existe."
fi

cd $orig

sfscripts=(bootstrap breeze html jetstream laravel livv vite vite-ts nestjs vscode)

for s in "${sfscripts[@]}"; do
    echo -e "[\e[1;35m*\e[0m] Criando link simbólico para sf-${s}..."
    sudo ln -fs $dest/sf-scripts/$s/sf-$s 2>/dev/null
done

# Upgrade
if [ $upgrade -eq 1 ]; then
    echo -e "[\e[1;35m*\e[0m] Atualizando o Composer..."
    composer self-update --no-interaction --quiet 2>/dev/null

    echo -e "[\e[1;35m*\e[0m] Atualizando o npm..."
    sudo npm install npm -g 1>/dev/null 2>/dev/null

    echo -e "[\e[1;35m*\e[0m] Atualizando o pnpm..."
    sudo npm install -g pnpm 1>/dev/null 2>/dev/null

    echo -e "[\e[1;35m*\e[0m] Atualizando o Laravel Installer..."
    composer global require laravel/installer --no-interaction --quiet 2>/dev/null
fi

echo -e "[\e[1;36m*\e[0m] Instalação concluida, use sf-[SCRIPT] e crie algo novo!"
