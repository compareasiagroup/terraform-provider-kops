#!/bin/bash

# create placeholders for default SSH keys
for n in $(find . -type d -name *-cluster-* -not -path "*/.terragrunt-cache/*"); do
    mkdir -p ${n}/.ssh/
    touch ${n}/.ssh/{id_rsa,id_rsa.pub}
done
