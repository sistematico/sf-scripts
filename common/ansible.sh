#!/usr/bin/env bash

[ $1 ] && ansible-playbook -i "$1", ansible.yml