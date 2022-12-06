# woodpecker-ansible-vyos-ci

This repository contains a simple python alpine docker image to verify our 
[ansible-vyos](https://docs.ansible.com/ansible/latest/collections/vyos/vyos/index.html) 
configuration changes before they get deployed to the productive routers. We use it for 
the continuous integration with [woodpecker](https://woodpecker-ci.org/) in our internal gitea.

I decided to make this project public, even though it contains some internal details, for educational purpose.
You won't be able to directly use this image yourself!

Thank you [@TheCataliasTNT2k](https://github.com/thecataliastnt2k) for the python implementation of this project.

Checkout the first (static) part of our ci: [github.com/secshellnet/ansible-vyos-validator](https://github.com/secshellnet/ansible-vyos-validator).

## Information regarding [`ansible.patch`](./ansible.patch)
The [ansible vyos collection](https://docs.ansible.com/ansible/latest/collections/vyos/vyos/index.html) has some weird bugs. The sequence ESC+m appears randomly in the running_configuration, which ansible gathers on every job. The patch removes these sequences from the received data, to prevent ansible from running into errors.

You can generate such a patch using `diff -u original changed > ansible.patch`, I suggest adjusting the file paths (first two lines). Afterwards you may apply the patch using `patch filename < ansible.patch`.