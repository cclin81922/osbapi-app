# Installation

```
go get -u github.com/cclin81922/osbapi-app/cmd/osbapiapp
export PATH=$PATH:~/go/bin
```

# Command Line Usage

```
BASE=~/go/src/github.com/cclin81922/osbapi-app/pki/baseurl
CA=~/go/src/github.com/cclin81922/osbapi-app/pki/ca.cert.pem
KEY=~/go/src/github.com/cclin81922/osbapi-app/pki/client.key.pem
CERT=~/go/src/github.com/cclin81922/osbapi-app/pki/client.cert.pem
osbapiapp -base=$BASE -ca=$CA -key=$KEY -cert=$CERT
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
