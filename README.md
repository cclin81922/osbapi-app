# Prerequisite

osbapi-broker is up and running. See https://github.com/cclin81922/osbapi-broker

# Bind service

```console
$ make provision-svc
# make bind-svc
```

# Deploy app using Helm

```console
$ TAG=latest PULL=Never make deploy-app
```

