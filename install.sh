#!/usr/bin/env bash

repo="git@github.com:sistematico/sf-scripts.git"
examples="git@github.com:sistematico/tailwind-examples.git"
dest="$HOME/github"

[ $EUID -eq 0 ] && echo "Este script não pode rodar como root." && exit

[ ! -d $dest ] && mkdir $dest

if [ ! -d $dest/sf-scripts ]; then
  echo "Clonando o repositório $repo em $dest/sf-scripts"
  git clone $repo $dest/sf-scripts > /dev/null 2> /dev/null
else
  echo "O diretório $dest/sf-scripts já existe."
fi

if [ ! -d $dest/tailwind-examples ]; then
  echo "Clonando o repositório $examples em $dest/tailwind-examples"
  git clone $examples $dest/tailwind-examples > /dev/null 2> /dev/null
else
  echo "O diretório $dest/tailwind-examples já existe."
fi

cd /usr/local/bin/

sfscripts=( bootstrap breeze html jetstream laravel livv vite vscode ) 

for s in "${sfscripts[@]}"; do
  echo -e "[\e[1;35m*\e[0m] Criando link simbólico para sf-${s}..."
  sudo ln -fs $HOME/github/sf-scripts/$s/sf-$s 2> /dev/null
done

# Upgrade
echo -e "[\e[1;35m*\e[0m] Atualizando o Composer..."
composer self-update --no-interaction --quiet 2> /dev/null

echo -e "[\e[1;35m*\e[0m] Atualizando o npm..."
sudo npm install npm -g 1> /dev/null 2> /dev/null

echo -e "[\e[1;35m*\e[0m] Atualizando o pnpm..."
pnpm add -g pnpm 1> /dev/null 2> /dev/null

echo -e "[\e[1;35m*\e[0m] Atualizando o Laravel Installer..."
composer global require laravel/installer --no-interaction --quiet 2> /dev/null

echo -e "[\e[1;30m*\e[0m] Instalação concluida, use sf-[SCRIPT] e crie algo novo!"