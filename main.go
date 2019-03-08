// hello-go-deploy-gce main.go

package main

import (
	"fmt"
	"time"
)

// Addthis Adds two ints together
func addThis(a int, b int) (temp int) {
	temp = a + b
	return
}

// Looping forever - For the testing Marathon and Mesos
func main() {
	var a = 0
	var b = 1
	for {
		a = addThis(a, b)
		fmt.Println("Hello everyone, the count is:", a)
		time.Sleep(2000 * time.Millisecond)
	}
}
