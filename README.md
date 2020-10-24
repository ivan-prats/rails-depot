# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## Personal settings

Following [this article](https://dev.to/vvo/the-three-extensions-you-need-for-rails-in-vs-code-5h7j), I added the following to personalize my Ruby on Rails development.

- [endwise](https://marketplace.visualstudio.com/items?itemName=kaiwood.endwise) VS Code extension
- [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph) VS Code extension AND gem (`gem install solargraph`) for autocompletion
- [Rubo Cop](https://rubocop.org/) VS Code extension AND gem (`gem install rubocop`) for automatic linting. Configure it to run on "autosave" if possible.

In order to share the workspace properly and suggest the extensions: we can add the following file `.vscode/extensions.json`:

```json
{
  "recommendations": ["kaiwood.endwise", "castwide.solargraph"]
}
```

Also it's a good idea to copy and paste this standart `.vscode/settings.json` file.
Take into consideration that some things are not that useful, but in order to share the config across several types of projects (javascript...) I just keep them.

```json
{
  "files.eol": "\n",
  "files.associations": {
    "*.html.erb": "html"
  },

  "[html]": {
    "editor.defaultFormatter": "vscode.html-language-features"
  },
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.fixAll.prettier": true
  },

  "solargraph.autoformat": true,
  "solargraph.diagnostics": true,
  "solargraph.formatting": true
}
```
