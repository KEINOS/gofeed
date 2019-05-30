# Remote Development Settings for VSCode

## TL;DR

This repo supports VSCode's Remote Server access via Remote-Container for Golang development.

- **Requirements**
  - VSCode v1.42+
    - Extension Pack: [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) v0.19.0+
  - Docker v19.03.5+
  - Host machine architecture
    - Intel compatible (Intel, ARM64, x86_64)

## TS;DR

Are you a [Visual Studio Code](https://code.visualstudio.com/) and [Docker](https://www.docker.com/) user?

If so, **you don't need a local Golang environment to develop this repo**.

This directory contains a info of a Golang container for development.

The container includes:

- Debian 10 (buster)
- Go v1.13.8
  - GO111MODULE=on
- VSCode Server (PORT: 5963)
- VSCode settings to change some behaviours (See: [settings.vscode.json](./settings.vscode.json))
- Useful VSCode packages to develop (See: [devcontainer.json](./devcontainer.json))
- For more details see [Dockerfile](./Dockerfile)

VSCode will create and launch the container mounting your source code (`/src`). Then it will connect to the exposed port of the container, so you can develop remotely.

![Architecture of Remote Containers](https://code.visualstudio.com/assets/docs/remote/containers/architecture-containers.png
)

### How to start

1. You need to install VSCode Extension.
    - [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

2. Open the root directory of this repo with VSCode.

    ```shellsession
    $ cd /path/to/this/repo
    $ code .
    ```

3. Press the green `><` icon at the left bottom of the Status bar.

   ![Remote Development Status Bar Image](https://code.visualstudio.com/assets/docs/remote/common/remote-dev-status-bar.png)

4. Select `Remote-Containers: Reopen in Container` then the VSCode will build the image and launch the container.
    - NOTE: The first boot takes time since it creates the container image.

5. If the container launches successfully then you can edit the code.
    - NOTE: To run go command via remote use the terminal of VSCode.

More info and ref about remote-development:

- [Release announcement](https://twitter.com/code/status/1124016109076799488) @ twitter
- [Remote Development with VS Code](https://code.visualstudio.com/blogs/2019/05/02/remote-development) @ VisualStudio.com
- [Quick Start to try a dev container](https://code.visualstudio.com/docs/remote/containers#_quick-start-try-a-dev-container)
 @ VisualStudio.com
- [Dockerで立ち上げた開発環境をVS Codeで開く!](https://qiita.com/yoskeoka/items/01c52c069123e0298660) @ Qiita
