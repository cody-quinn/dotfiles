#!/bin/sh

nix flake update
exec ./rebuild.sh
