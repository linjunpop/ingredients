# Ingredients

## Server Provision

### Setup

* $ knife solo init
* $ berks install --path chef/cookbooks

### Provision server

```shell
$ knife solo bootstrap vagrant@192.168.33.10 -i ~/.vagrant.d/insecure_private_key
```

## Deploy

$ bin/cap deploy
