#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

cp layouts/robots.txt.tmp layouts/robots.txt
curl -sSL https://raw.githubusercontent.com/ai-robots-txt/ai.robots.txt/main/robots.txt >> layouts/robots.txt
