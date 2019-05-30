# gofeed-cli

A simple CLI of [gofeed](https://github.com/mmcdole/gofeed).

This command parses the content of a given URL/string of XML/Atom feed into JSON.

## Usage

```shellsession
$ gofeed-cli ParseURL https://sample.com/news.rss
...
```

```shellsession
$ gofeed-cli ParseString [your feed string here]
...
```

### Via Docker

```bash
docker pull keinos/gofeed-cli
```

```shellsession
$ # Run gofeed-cli from the Host OS
$ docker run --rm keinos/gofeed-cli ParseURL https://sample.com/news.atom
...
```

```shellsession
$ # Run gofeed-cli inside the Docker container(GuesOS)
$ docker run --rm -it --entrypoint /bin/sh keinos/gofeed-cli
/ # gofeed-cli ParseURL https://sample.com/news.rss
...
/ # exit
$
```

## Commands Available

-[x] `ParseURL [URL]`
-[x] `ParseString [String]`
-[] Comming soon ...

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
