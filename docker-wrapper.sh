#!/bin/bash
# Docker wrapper script for Jenkins

export PATH="/usr/local/bin:$PATH"
exec /usr/local/bin/docker "$@"
