#!/usr/bin/env bash

repo="https://github.com/sistematico/sf-scripts"
dest="$HOME/github"

[ $EUID -eq 0 ] && echo "Este script não pode rodar como root." && exit

[ ! -d $dest ] && mkdir $dest

if [ ! -d $dest/sf-scripts ]; then
  echo "Clonando o repositório $repo em $dest/sf-scripts"
  git clone $repo $dest/sf-scripts 1> /dev/null
else
  echo "O diretório $dest/sf-scripts já existe."
  exit
fi

cd /usr/local/bin/

sfscripts=( bootstrap breeze html jetstream laravel livv vite vscode ) 

for s in "${sfscripts[@]}" do 
  echo "Criando link simbólico para sf-${s}..."
  sudo ln -fs $USER/github/$s/sf-$s 2> /dev/null
done

echo "Instalação concluida, use sf-[SCRIPT] e crie algo novo!"