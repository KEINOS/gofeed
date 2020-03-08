package main

// Requires:
//   go, git, gcc, g++,
//   go get github.com/mmcdole/gofeed
//   go get github.com/urfave/cli
// Build:
//   VERSION_APP=$(git describe --tags)
//   go build \
//     -a \
//      --ldflags "-w -extldflags \"-static\" -X main.appVersion=${VERSION_APP}" \
//      -o /path/to/go/bin/gofeed-cli.go \
//      ./gofeed-cli.go

import (
	"fmt"
	gofeed "github.com/mmcdole/gofeed"
	cli "github.com/urfave/cli"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var (
	// Specify the appVersion in the build process such like:
	//   $ go build -ldflags "-X main.appVersion=v0.0.1" gofeed-cli.go
	appVersion = "dev"
	appAuthor  = "https://github.com/KEINOS/gofeed-cli/graphs/contributors"
	urlTest    = "https://qiita.com/KEINOS/feed.atom"
)

func main() {
	app := NewAppCli()

	// Set Global Options
	app.Flags = []cli.Flag{
		FlagOptionCount(),
		FlagOptionJSON(),
	}
	// Set Commands
	app.Commands = []cli.Command{
		CmdParseURL(),
		CmdParseString(),
	}

	// Default action (When no arg/option given)
	app.Action = func(context *cli.Context) error {
		PrintError("Syntax error: Unknown command or option given.")
		//VarDump(os.Args)
		cli.ShowAppHelpAndExit(context, 1)
		return nil
	}

	// Run app
	err := app.Run(os.Args)

	if err != nil {
		PrintError("Error occurred while running the app.")
		log.Fatal(err)
	}
}

// CmdParseString : Command for `gofeed-cli string`
func CmdParseString() cli.Command {
	return cli.Command{
		Name:    "ParseString",
		Aliases: []string{"string"},
		Usage:   "Parse the contents of a given string into JSON.",
		Action: func(context *cli.Context) error {
			if context.NArg() == 0 {
				PrintError("Missing argument.")
				cli.ShowAppHelpAndExit(context, 1)
				return nil
			}
			strJSON := context.Args()[0]
			fp := gofeed.NewParser()
			feed, err := fp.ParseString(strJSON)
			if err == nil {
				fmt.Println(feed)
				return nil
			}
			return err
		},
	}
}

// CmdParseURL : Command for `gofeed-cli url`
func CmdParseURL() cli.Command {
	return cli.Command{
		Name:    "ParseURL",
		Aliases: []string{"url"},
		Usage:   "Parse the contents of a given URL into JSON.",
		Action: func(context *cli.Context) error {
			if context.NArg() == 0 {
				PrintError("Missing argument.")
				cli.ShowAppHelpAndExit(context, 1)
				return nil
			}
			strURL := context.Args()[0]
			fp := gofeed.NewParser()
			feed, err := fp.ParseURL(strURL)
			if err == nil {
				fmt.Println(feed)
				return nil
			}
			return err
		},
	}
}

// FlagOptionCount : [WIP] Option flag for `gofeed-cli --count`
func FlagOptionCount() cli.StringFlag {
	return cli.StringFlag{
		Name:  "count, c",
		Usage: "Number of items to return. (WIP)",
	}
}

// FlagOptionJSON : Option flag for `gofeed-cli --json`
func FlagOptionJSON() cli.BoolFlag {
	return cli.BoolFlag{
		Name:  "json, j",
		Usage: "Returns output in JSON format. (Default)",
	}
}

// getEnv : Get ENV variable value
func getEnv(key, alternate string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return alternate
}

// GetNameExe : Returns the file name as `gofeed-cli`
func GetNameExe() string {
	return GetNameFileWithNoExt(os.Args[0])
}

// GetNameFileWithNoExt : Returns the file name without extension name
func GetNameFileWithNoExt(pathFile string) string {
	return filepath.Base(pathFile[:len(pathFile)-len(filepath.Ext(pathFile))])
}

// NewAppCli : Returns a CLI app object
func NewAppCli() *cli.App {
	app := cli.NewApp()
	app.Name = "CLI for GoFeed"
	app.Usage = "Parses Feeds such as XML and Atom to JSON."
	app.Version = appVersion
	app.Copyright = appAuthor

	return app
}

// PrintError : Old school error output
func PrintError(message string) {
	fmt.Fprintf(os.Stderr, "* "+strings.TrimSpace(message)+"\n\n")
}

// VarDump : Old school variable dumping for debugging
func VarDump(v ...interface{}) {
	for _, vv := range v {
		fmt.Printf("%#v\n", vv)
	}
}
