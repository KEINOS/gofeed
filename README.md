[![](https://images.microbadger.com/badges/image/keinos/gofeed-cli.svg)](https://microbadger.com/images/keinos/gofeed-cli "View image info on microbadger.com") [![](https://img.shields.io/docker/cloud/automated/keinos/gofeed-cli.svg)](https://hub.docker.com/r/keinos/gofeed-cli "View on Docker Hub") [![](https://img.shields.io/docker/cloud/build/keinos/gofeed-cli.svg)](https://hub.docker.com/r/keinos/gofeed-cli/builds "View builds on Docker Hub")

# gofeed-cli

A simple CLI of [gofeed](https://github.com/mmcdole/gofeed).

This command parses the content of a given URL/string of RSS/Atom feed (XML) into JSON.

- Docker Image: `keinos/gofeed-cli:latest` [[See available versions](https://hub.docker.com/r/keinos/gofeed-cli/tags)]
- Repositories:
  - Source: https://github.com/KEINOS/gofeed-cli @ GitHub
  - Image: https://hub.docker.com/r/keinos/gofeed-cli @ Docker Hub
- Supported feed types: [See `gofeed` spec](https://github.com/mmcdole/gofeed#features).
- Issues: https://github.com/KEINOS/gofeed-cli/issues @ GitHub

## Usage

Use Docker or build the binary your own from the [source](https://github.com/KEINOS/gofeed-cli/tree/gofeed-cli/src).

### Help

```shellsession
$ //gofeed-cli --help
$ docker run --rm keinos/gofeed-cli --help
NAME:
   CLI for GoFeed - Parses Feeds such as XML and Atom to JSON.

USAGE:
   gofeed-cli [global options] command [command options] [arguments...]

VERSION:
   vX.X.X

AUTHOR:
   https://github.com/KEINOS/gofeed-cli/graphs/contributors

COMMANDS:
     ParseURL, url        Parse the contents of a given URL into JSON.
     ParseString, string  Parse the contents of a given string into JSON.
     help, h              Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --count value, -c value  Number of items to return. (WIP)
   --json, -j               Returns output in JSON format. (Default)
   --help, -h               show help
   --version, -v            print the version
```

### Parse Feed From URL

- Use `ParseURL` (alias `url`) command to parse feeds from URL.

    ```bash
    # Using the own built binary.
    gofeed-cli ParseURL [URL]
    gofeed-cli url [URL]
    ```

    ```bash
    # Using Docker. No need to build but Docker.
    docker run --rm keinos/gofeed-cli ParseURL [URL]
    docker run --rm keinos/gofeed-cli string [URL]
    ```

```shellsession
$ gofeed-cli ParseURL https://sample.com/news.rss
...(parsed contents in JSON here)...

$ gofeed-cli url https://sample.com/news.rss
...(parsed contents in JSON here)...
```

```shellsession
$ docker run --rm keinos/gofeed-cli ParseURL https://sample.com/news.rss
...(parsed contents in JSON here)...

$ docker run --rm keinos/gofeed-cli url https://sample.com/news.rss
...(parsed contents in JSON here)...
```

### Parse Feed From A String

- Use `ParseString` (alias `string`) command to parse feeds from a string.

    ```bash
    # Using the own built binary.
    gofeed-cli ParseString [String]
    gofeed-cli string "[String]"
    ```

    ```bash
    # Using Docker. No need to build but Docker.
    docker run --rm keinos/gofeed-cli ParseString [String]
    docker run --rm keinos/gofeed-cli string "[String]"
    ```

```shellsession
$ ls
feed.xml

$ gofeed-cli ParseString "$(cat feed.xml)"
...(parsed contents in JSON here)...

$ gofeed-cli string "$(cat feed.xml)"
...(parsed contents in JSON here)...
```

```shellsession
$ ls
feed.xml

$ docker run --rm keinos/gofeed-cli ParseString "$(cat feed.xml)"
...(parsed contents in JSON here)...

$ docker run --rm keinos/gofeed-cli string "$(cat feed.xml)"
...(parsed contents in JSON here)...
```

## Contribute/Collaborate

- Note: **This app is placed on `gofeed-cli` orphan branch** and not in `master`. Since `master` branch is an up-to-date code of the original `gofeed`, any PR (Pull Request) to this CLI app must be to `gofeed-cli` branch.
- So far, this app fulfills my need. But any contribution/collaboration such as new feature, bug fixing, refactoring, etc. are more than well come. I mean ... pleeease, I'm new to Golang.

## License

This project is licensed under the [MIT License](https://KEINOS.github.io/gofeed-cli/master/LICENSE).

## Credits

* [mmcdole](https://github.com/mmcdole) for his work on [gofeed](https://github.com/mmcdole/gofeed), the core package of this app.
  * [View other credits of gofeed](https://github.com/mmcdole/gofeed#credits)
* [syui](https://github.com/syui) for his work on [xq](https://github.com/syui/xq) which gave me an ispiration of this app.
* [urfave](https://github.com/urfave) for his/her work on [package for building command line apps in Go](https://github.com/urfave/cli).
