// hello-go-deploy-aks main.go

package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	log "github.com/sirupsen/logrus"
)

const toolVersion = "2.0.1"

func checkErr(err error) {

	if err != nil {
		fmt.Printf("Error is %+v\n", err)
		log.Fatal("ERROR:", err)
	}

}

func checkVersion(version bool) {

	if version {
		fmt.Println(toolVersion)
		os.Exit(0)
	}

}

func setLogLevel(debugTrace bool) {

	// SET LOG LEVEL
	if debugTrace {
		log.SetLevel(log.TraceLevel)
	} else {
		log.SetLevel(log.InfoLevel)
	}

	// SET FORMAT
	log.SetFormatter(&log.TextFormatter{})
	// log.SetFormatter(&log.JSONFormatter{})

	// SET OUTPUT (DEFAULT stderr)
	log.SetOutput(os.Stdout)

}

func count() {

	var a = 0
	var b = 1
	for {
		a = addThis(a, b)
		fmt.Println("Hello everyone, the count is:", a)
		time.Sleep(2000 * time.Millisecond)
	}

}

func addThis(a int, b int) (temp int) {

	temp = a + b
	return

}

// Looping forever - For the testing Marathon and Mesos
func main() {

	// FLAGS
	versionPtr := flag.Bool("v", false, "prints current version")
	debugTracePtr := flag.Bool("debug", false, "log trace level")
	flag.Parse()

	// CHECK VERSION
	checkVersion(*versionPtr)

	// SET LOG LEVEL
	setLogLevel(*debugTracePtr)

	// PRINT SOME GOOD STUFF
	log.Trace(" ")
	log.Trace("Version flag = ", *versionPtr)
	log.Trace("Debug flag = ", *debugTracePtr)
	log.Info(" ")
	log.Info("Let's Go!!! (Press return to exit)")
	log.Info(" ")
	fmt.Println(" ")

	go count()

	// PRESS RETURN TO EXIT

	fmt.Scanln()
	log.Info("DONE")

}
