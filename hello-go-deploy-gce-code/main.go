// hello-go-deploy-gce main.go

package main

import (
	"fmt"
	"time"

	log "github.com/sirupsen/logrus"
)

func main() {

	log.Info("Let's Go!!!")
	log.Info(" ")
	fmt.Println(" ")

	var a = 0
	var b = 1

	for {
		a = a + b
		fmt.Println("Hello everyone, the count is:", a)
		time.Sleep(2000 * time.Millisecond)
	}

}
