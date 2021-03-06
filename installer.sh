#!/usr/bin/env bash

repo="https://github.com/sistematico/sf-scripts"
examples="https://github.com/sistematico/tailwind-examples"
dest="$HOME/github"

[ $EUID -eq 0 ] && echo "Este script não pode rodar como root." && exit

[ ! -d $dest ] && mkdir $dest

if [ ! -d $dest/sf-scripts ]; then
  echo "Clonando o repositório $repo em $dest/sf-scripts"
  git clone $repo $dest/sf-scripts > /dev/null 2> /dev/null
else
  echo "O diretório $dest/sf-scripts já existe."
  exit
fi

if [ ! -d $dest/sf-scripts ]; then
  echo "Clonando o repositório $examples em $dest/tailwind-examples"
  git clone $examples $dest/tailwind-examples > /dev/null 2> /dev/null
fi

cd /usr/local/bin/

sfscripts=( bootstrap breeze html jetstream laravel livv vite vscode ) 

for s in "${sfscripts[@]}"; do
  echo "Criando link simbólico para sf-${s}..."
  sudo ln -fs /home/$USER/github/sf-scripts/$s/sf-$s 2> /dev/null
done

# Upgrade
echo -e "[\e[1;35m*\e[0m] Upgrading Composer..."
sudo composer self-update --no-interaction --quiet 2> /dev/null

echo -e "[\e[1;35m*\e[0m] Upgrading npm..."
sudo npm install npm -g 2> /dev/null

echo -e "[\e[1;35m*\e[0m] Upgrading pnpm..."
sudo pnpm add -g pnpm 1> /dev/null 2> /dev/null

echo -e "[\e[1;35m*\e[0m] Upgrading Laravel Installer..."
sudo composer global require laravel/installer --no-interaction --quiet 2> /dev/null

echo "Instalação concluida, use sf-[SCRIPT] e crie algo novo!"