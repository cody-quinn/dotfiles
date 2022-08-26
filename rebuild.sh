#!/bin/sh

exec sudo nixos-rebuild switch --flake '.#'
