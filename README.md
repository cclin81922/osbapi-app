# Installation

```
go get -u github.com/cclin81922/osbapi-app/cmd/osbapiapp
export PATH=$PATH:~/go/bin
```

# Command Line Usage

```
osbapiapp
```

# Deploy osbapiapp Using Helm

```
make provision-svc
make bind-svc
make deploy-app
```

# For Developer

Run all tests

```
go get -u github.com/cclin81922/osbapi-baas/cmd/osbapibaas
export PATH=$PATH:~/go/bin
osbapibaas -port=8443

echo "127.0.0.1   localhost.localdomain" >> /etc/hosts
go test github.com/cclin81922/osbapi-app/cmd/osbapiapp
```
