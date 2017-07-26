#!/bin/bash

rm -rf $(docker volume ls -qf dangling=true)