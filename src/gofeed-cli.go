package main

import (
	"log"
	"os"
	"fmt"
	"path/filepath"
	"strings"
	cli "github.com/urfave/cli"
	gofeed "github.com/mmcdole/gofeed"
)

var (
	app_version = "0.0.1"
	app_author  = "https://github.com/KEINOS/gofeed-cli/graphs/contributors"
	url_test    = "https://qiita.com/KEINOS/feed.atom"
)

func main() {
	app := NewAppCli()

	// Set Global Options
	app.Flags = []cli.Flag{
		FlagOptionCount(),
		FlagOptionJson(),
	}
	// Set Commands
	app.Commands = []cli.Command{
		CmdParseURL(),
		CmdParseString(),
	}

	// Default action
	app.Action = func(context *cli.Context) error {
		PrintError("Syntax error: Unknown command or option given.")
		cli.ShowAppHelpAndExit(context, 1)
		return nil
	}

	// Run app
	err := app.Run(os.Args)

	if err != nil {
		PrintError("Error occured while running the app.")
		log.Fatal(err)
	}
}

func CmdParseString() cli.Command {
	return cli.Command {
		Name:    "ParseString",
		Aliases: []string{"string"},
		Usage:   "Parse the contents of a given string into JSON.",
		Action:  func(context *cli.Context) error {
			if context.NArg() == 0 {
				PrintError("Missing argument.")
				cli.ShowAppHelpAndExit(context, 1)
				return nil
			}
			str_json  := context.Args()[0]
			fp        := gofeed.NewParser()
			feed, err := fp.ParseString(str_json)
			if err == nil {
				fmt.Println(feed)
				return nil
			}
			return err
		},
	}
}

func CmdParseURL() cli.Command {
	return cli.Command {
		Name:    "ParseURL",
		Aliases: []string{"url"},
		Usage:   "Parse the contents of a given URL into JSON.",
		Action:  func(context *cli.Context) error {
			if context.NArg() == 0 {
				PrintError("Missing argument.")
				cli.ShowAppHelpAndExit(context, 1)
				return nil
			}
			str_url   := context.Args()[0]
			fp        := gofeed.NewParser()
			feed, err := fp.ParseURL(str_url)
			if err == nil {
				fmt.Println(feed)
				return nil
			}
			return err
		},
	}
}

func FlagOptionCount() cli.StringFlag {
	return cli.StringFlag{
		Name:  "count, c",
		Usage: "Number of items to return. (WIP)",
	}
}

func FlagOptionJson() cli.BoolFlag {
	return cli.BoolFlag{
		Name:  "json, j",
		Usage: "Returns output in JSON format. (Default)",
	}
}

func GetNameExe() string {
	return GetNameFileWithNoExt(os.Args[0])
}

func GetNameFileWithNoExt(path_file string) string {
    return filepath.Base(path_file[:len(path_file)-len(filepath.Ext(path_file))])
}

func NewAppCli() *cli.App {
	app := cli.NewApp()
	app.Name  = "CLI for GoFeed"
	app.Usage = "Parses Feeds such as XML and Atom to JSON."
	app.Version = app_version
	app.Author  = app_author

	return app
}

func PrintError(message string) {
	fmt.Fprintf(os.Stderr, "* " + strings.TrimSpace(message) + "\n\n")
}
