#!/bin/bash
# $1 = node name [products-test-db]
# Create the folder structure and adjust permissions
mkdir /opt/$1 && mkdir /opt/$1/data && mkdir /opt/$1/config && mkdir /opt/$1/log
chown -R 999:docker /opt/$1




