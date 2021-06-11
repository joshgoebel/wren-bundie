
[![forthebadge](https://forthebadge.com/images/badges/open-source.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)

# <img src="https://wren.io/wren.svg" valign="middle" width="100"> wren-bundie

![MIT licensed](https://badgen.net/badge/license/MIT/cyan?scale=1.2)
![wren 0.4](https://badgen.net/badge/wren/0.4/blue?scale=1.2)
![wren-console](https://badgen.net/badge/wren-console/yes/green?scale=1.2)
![wren-cli](https://badgen.net/badge/wren-cli/see%20below/orange?scale=1.2)

Bundler for larger [Wren](https://wren.io) projects.  Takes a complex module
dependency tree and spits out a single self-contained `.wren` module/file.



### How it Works

To bundle an app:

- `wrenc ./bin/bundie.wren ./path/to/app.wren > /dist/app.wren`


### FAQ

**What about Wren CLI?**

Bundles produced by this tool should run on Wren CLI (and other Wren runtimes) just fine.  The bundler itself currently requires [Wren Console](https://github.com/joshgoebel/wren-console).

**What prevents this from working with Wren CLI?**

- `repl#Lexer` is not easily exposed for usage by tools
- Uses the internal `Path` functionality of Wren Console

### Contributions

Licensed MIT and open to contributions!

Please open an issue to discuss or find me on [Wren Discord](https://discord.gg/VTzuWmBavH) or [Wren Console Discord](https://discord.gg/6YjUdym5Ap).
