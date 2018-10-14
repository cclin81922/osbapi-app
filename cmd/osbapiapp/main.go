package main

import (
    "log"
    "time"
    "github.com/cclin81922/osbapi-sdk/pkg/osbapisdk"
)

func main() {
    for now := range time.Tick(3 * time.Second) {
        reply, err := osbapisdk.Echo(now)
        if err != nil {
            log.Println(err)
        } else {
            log.Println(reply)
        }
    }
}
