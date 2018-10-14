package main

import (
    "fmt"
    "log"
    "time"
    "github.com/cclin81922/osbapi-sdk/pkg/osbapisdk"
)

func main() {
    for now := range time.Tick(3 * time.Second) {
        message := fmt.Sprintf("%s", now)
        reply, err := osbapisdk.Echo(message)
        if err != nil {
            log.Println(err)
        } else {
            log.Println(reply)
        }
    }
}
