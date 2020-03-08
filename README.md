[![](https://images.microbadger.com/badges/image/keinos/gofeed-cli.svg)](https://microbadger.com/images/keinos/gofeed-cli "View image info on microbadger.com") [![](https://img.shields.io/docker/cloud/automated/keinos/gofeed-cli.svg)](https://hub.docker.com/r/keinos/gofeed-cli "View on Docker Hub") [![](https://img.shields.io/docker/cloud/build/keinos/gofeed-cli.svg)](https://hub.docker.com/r/keinos/gofeed-cli/builds "View builds on Docker Hub")

# gofeed-cli

**`gofeed-cli`** is an implementation of [GoFeed](https://github.com/mmcdole/gofeed) as a command line.

The `gofeed-cli` command parses RSS/Atom feed (XML) into JSON from a given URL/string.

```bash
gofeed-cli [ global options ] command [command options] [arguments...]
```

```shellsession
$ # Parse from URL
$ ./gofeed-cli url https://qiita.com/KEINOS/feed.atom
...
```

- Available OS and architecture:
  - **Linux:** Intel Compatible†, ARMv5, ARMv6, ARMv7 and ARM64
  - **macOS:** Intel Compatible†
  - **Windows10:** Intel Compatible†

<sup>† Intel Compatible: x86_64 and AMD64 architecture.

## Basic Usage

```shellsession
$ ./gofeed-cli --help
NAME:
   CLI for GoFeed - Parses Feeds such as XML and Atom to JSON.

USAGE:
   gofeed-cli [global options] command [command options] [arguments...]

VERSION:
   vX.X.X-XXXXX

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

```shellsession
$ # Parse from URL
$ ./gofeed-cli url https://qiita.com/KEINOS/feed.atom
...
```

```bash
#!/bin/bash

str_feed=$(cat <<'FEED'
<rss version="2.0">
<channel>
<managingEditor>Name of Managing Editor Here</managingEditor>
<itunes:author>Author Name of iTunes Here</itunes:author>
</channel>
</rss>
FEED
)

# Parse from string
echo $(./gofeed-cli string "$str_feed")
```

```shellsession
$ # Pull image
$ docker pull keinos/gofeed-cli
...
$ # Parse from URL via Docker
$ docker run --rm keinos/gofeed-cli url https://qiita.com/KEINOS/feed.atom
...
```

## Basic Info

- Docker Image: `keinos/gofeed-cli:latest` [[See available versions](https://hub.docker.com/r/keinos/gofeed-cli/tags)]
- Repositories:
  - **Source:** https://github.com/KEINOS/gofeed-cli @ GitHub
    - Main branch: `gofeed-cli`
  - **Container Image:** https://hub.docker.com/r/keinos/gofeed-cli @ Docker Hub
- Feed Types: Supported feed types [see `gofeed`'s spec](https://github.com/mmcdole/gofeed#features).
- Issues: https://github.com/KEINOS/gofeed-cli/issues @ GitHub
  - I'm not a Gopher but feel free to issue and contribute.
  - Issues in Japanese and Spanish are also welcome.

## Install

Download the binary of your architecture from the [releases page](https://github.com/KEINOS/gofeed-cli/releases/latest) then rename it to `gofeed-cli`. If it suits you, place it anywhere in your path.

- Linux users
  - ARMv5 -> `gofeed-cli-linux-arm5`
  - ARMv6 -> `gofeed-cli-linux-arm6`
  - ARMv7 -> `gofeed-cli-linux-arm7`
  - ARM64 -> `gofeed-cli-linux-arm64`
  - Intel/x86_64/AMD64 -> `gofeed-cli-linux-amd64`
- macOS users
  - Intel/x86_64/AMD64 -> `gofeed-cli-darwin-amd64`
- Windows10 users
  - Intel/x86_64/AMD64 -> `gofeed-cli-windows-amd64`

## Build

If you have Docker installed, then you don't need Golang environment to build the binary.
Just run `build-bin.sh` script under `/build` directory.

```shellsession
$ ./build/build-bin.sh
...
$ ls -l ./bin
...
```

- Tested Docker Version: v19.03.5

## Development

This repository contains `/.devcontainer` for [Visual Studio Code Remote-Container](https://code.visualstudio.com/docs/remote/remote-overview) users.

It allows your VS Code to use a Docker container as a Golang-featured development environment.

## Contribute/Collaborate

Note: **This app is placed on `gofeed-cli` orphan branch** and NOT in `master`.

- Since `master` branch is an up-to-date code of the original `gofeed`, any PR (Pull Request) to this CLI app must be to `gofeed-cli` branch.
- So far, this app fulfills my need. But any contribution/collaboration such as new feature, bug fixing, refactoring, etc. are more than well come! I mean ... pleeease, I'm new to Golang.

## License

This project is licensed under the [MIT License](https://KEINOS.github.io/gofeed-cli/master/LICENSE).

## Credits

- [mmcdole](https://github.com/mmcdole) for his work on [gofeed](https://github.com/mmcdole/gofeed), the core package of this app.
  - [View other credits of gofeed](https://github.com/mmcdole/gofeed#credits)
- [syui](https://github.com/syui) for his work on [xq](https://github.com/syui/xq) which gave me an ispiration of this app.
- [urfave](https://github.com/urfave) for his/her work on [package for building command line apps in Go](https://github.com/urfave/cli).
