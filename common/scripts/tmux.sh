#!/usr/bin/env bash

BROWSER="firefox"
SESSION="laravel"

\tmux has-session -t $SESSION 2> /dev/null
if [ $? == 0 ]; then
  \tmux attach -t $SESSION
  \tmux detach -s $SESSION
else
  \tmux new-session -d -s $SESSION -n artisan
  # \tmux new-window -t $SESSION -n artisan
  \tmux new-window -t $SESSION -n npm
  \tmux new-window -t $SESSION -n les

  \tmux send-keys -t $SESSION:les "laravel-echo-server start" ENTER
  \tmux send-keys -t $SESSION:artisan "php artisan serve" ENTER
  \tmux send-keys -t $SESSION:npm "npm run dev" ENTER
fi

#$BROWSER http://localhost:8000
