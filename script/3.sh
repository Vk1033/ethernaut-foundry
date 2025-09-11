#!/bin/bash

source .env

TARGET=10

while true; do
  # Send the flip transaction
  cast send 0x015b7FDc38701DA8a05AC377e39E9a4689880f77 "flip()" --private-key $PRIVATE_KEY --rpc-url $SEPOLIA_RPC_URL

  # Get current consecutive wins
  WINS=$(cast call 0xfd904399fA779D81E66cD10670667dD405a2a33C "consecutiveWins()(uint256)" --rpc-url $SEPOLIA_RPC_URL)

  echo "Consecutive Wins: $WINS"

  # Stop when target is reached
  if [ "$WINS" -ge "$TARGET" ]; then
    echo "Reached $TARGET consecutive wins! Stopping."
    break
  fi

  # Wait for next block
  sleep 12
done
