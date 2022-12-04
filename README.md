# woodpecker-ansible-vyos-ci

This repository contains a simple python alpine docker image to verify our 
[ansible-vyos](https://docs.ansible.com/ansible/latest/collections/vyos/vyos/index.html) 
configuration changes before they get deployed to the productive routers. We use it for 
the continuous integration with [woodpecker](https://woodpecker-ci.org/) in our internal gitea.

I decided to make this project public, even though it contains some internal details, for educational purpose.
You won't be able to directly use this image yourself!

Thank you [@TheCataliasTNT2k](https://github.com/thecataliastnt2k) for the python implementation of this project.

Checkout the first (static) part of our ci: [github.com/secshellnet/ansible-vyos-validator](https://github.com/secshellnet/ansible-vyos-validator).
