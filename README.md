# homebrew-claudia

Homebrew tap for [Claudia](https://claudiacode.com/), a powerful GUI app and Toolkit for Claude Code.

## Installation

```bash
brew tap speto/claudia
brew install --cask speto/claudia/claudia
```

## About Claudia

Claudia is a powerful GUI application and toolkit for Claude Code that allows you to:
- Create custom agents
- Manage interactive Claude Code sessions
- Run secure background agents
- And much more

Built with Tauri 2, Claudia provides a modern interface for working with Claude Code on macOS.

## Updating

The cask will automatically check for updates. To manually update:

```bash
brew update
brew upgrade --cask claudia
```

## Uninstalling

```bash
brew uninstall --cask claudia
```

To completely remove all application data:

```bash
brew uninstall --zap --cask claudia
```

## License

This tap is maintained independently from the Claudia project. Claudia itself is available under its own license terms.