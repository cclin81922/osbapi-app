//    Copyright 2018 cclin
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

package main

import (
	"fmt"
	"log"
	"time"

	"github.com/cclin81922/osbapi-sdk/pkg/osbapisdk"
)

func echo(message string) (reply string, err error) {
	return osbapisdk.Echo(message)
}

func main() {
	for now := range time.Tick(3 * time.Second) {
		message := fmt.Sprintf("%s", now)
		reply, err := echo(message)
		if err != nil {
			log.Println(err)
		} else {
			log.Println(reply)
		}
	}
}
