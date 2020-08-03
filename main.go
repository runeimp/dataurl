package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/url"
	"os"
)

/*
 * CONSTANTS
 */
const (
	appName    = "dataURL"
	appVersion = "0.1.0"
)

/*
 * DERIVED CONSTANTS
 */
var (
	appLabel = fmt.Sprintf("%s v%s", appName, appVersion)
)

/*
 * MAIN ENTRYPOINT
 */
func main() {
	debug := false
	output := ""
	filesToProcess := []string{}

	for i := 0; i < len(os.Args); i++ {
		if i > 0 {
			switch os.Args[i] {
			case "-d", "-debug", "--debug":
				debug = true
			case "-h", "-help", "--help":
				fmt.Println("USAGE: dataurl path/to/file/to/encode")
				os.Exit(0)
			case "-v", "-ver", "-version", "--version":
				fmt.Println(appLabel)
				os.Exit(0)
			default:
				filesToProcess = append(filesToProcess, os.Args[i])
			}
		}
	}

	for _, file := range filesToProcess {
		fileData, err := ioutil.ReadFile(file)
		if err != nil {
			log.Fatalln(err.Error())
		}

		if debug {
			fmt.Printf("===> %s <===\n", file)
		}

		output = string(fileData)
		output = "data:text/html," + url.QueryEscape(output)
		fmt.Println(output)
	}
}
