#!/bin/bash

# mise がある環境では Node.js の管理を mise に任せる。
if command -v mise > /dev/null 2>&1; then
  return 0
fi

if [ -e "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
