# LSP Installation Guide

This config uses `vim.lsp.config` / `vim.lsp.enable` directly (no mason.nvim).
Install each server manually using the methods below.

---

## npm (via `vscode-langservers-extracted`)

Provides `html`, `jsonls` (json), and css language servers from a single package.

```sh
npm install -g vscode-langservers-extracted
```

| Server | Neovim name | Binary |
|---|---|---|
| HTML | `html` | `vscode-html-language-server` |
| JSON | `jsonls` | `vscode-json-language-server` |

---

## npm (individual packages)

```sh
npm install -g bash-language-server
npm install -g graphql-language-service-cli
npm install -g typescript-language-server typescript
npm install -g vim-language-server
npm install -g yaml-language-server
npm install -g @johnnymorganz/stylua
```

| Server | Neovim name | Binary |
|---|---|---|
| Bash/sh | `bashls` | `bash-language-server` |
| GraphQL | `graphql` | `graphql-lsp` |
| JS + TS | `ts_ls` | `typescript-language-server` |
| Vim script | `vimls` | `vim-language-server` |
| YAML | `yamlls` | `yaml-language-server` |

> **Note:** `bashls` also benefits from `shellcheck` being on `$PATH` for diagnostics.

---

## cargo (Rust)

```sh
cargo install taplo-cli --locked --features lsp  # taplo (TOML)
```

| Server | Neovim name | Binary |
|---|---|---|
| TOML | `taplo` | `taplo` |

---

## go install

```sh
go install github.com/nickel-lang/nickel/lsp/... 2>/dev/null || true  # not applicable
go install github.com/nametake/golangci-lint-langserver@latest        # (optional linter bridge)
```

> Most Go-based servers below have their own release binaries — prefer those over `go install` where possible.

---

## System package manager (Arch / pacman / AUR)

```sh
# clangd (C/C++)
pacman -S clang

# marksman (Markdown)
# Available as AUR: yay -S marksman-bin

# pyright (Python)
pacman -S pyright
# or: pip install pyright

# zls (Zig)
# Install alongside Zig: https://github.com/zigtools/zls
```

| Server | Neovim name | Binary | Language |
|---|---|---|---|
| clangd | `clangd` | `clangd` | C / C++ |
| marksman | `marksman` | `marksman` | Markdown |
| pyright | `pyright` | `pyright` | Python |
| zls | `zls` | `zls` | Zig |

---

## Language-specific toolchains / manual binaries

### C# — `csharp-ls`

```sh
dotnet tool install --global csharp-ls
```

Neovim name: `csharp_ls` | Binary: `csharp-ls`
Repo: <https://github.com/razzmatazz/csharp-language-server>

---

### D — `serve-d`

Download a release binary from <https://github.com/Pure-D/serve-d/releases> and place it on `$PATH`.

Neovim name: `serve_d` | Binary: `serve-d`

---

### Dockerfile — `docker-langserver`

```sh
npm install -g dockerfile-language-server-nodejs
```

Neovim name: `dockerls` | Binary: `docker-langserver`

---

### Helm — `helm_ls`

Download from <https://github.com/mrjosh/helm-ls/releases> and place on `$PATH`.

Neovim name: `helm_ls` | Binary: `helm_ls`

---

### Java — `jdtls`

Install via system package, AUR, or download from <https://download.eclipse.org/jdtls/>.

```sh
# Arch AUR
yay -S jdtls
```

Neovim name: `jdtls` | Binary: `jdtls`
Requires a data directory for workspace state (configured in `lsp.lua`).

---

### Jsonnet — `jsonnet-language-server`

```sh
go install github.com/grafana/jsonnet-language-server@latest
```

Neovim name: `jsonnet_ls` | Binary: `jsonnet-language-server`
Repo: <https://github.com/grafana/jsonnet-language-server>

---

### Rego (OPA) — `regal`

Download from <https://github.com/StyraInc/regal/releases> or:

```sh
brew install styra/tap/regal
```

Neovim name: `regal` | Binary: `regal`
Regal serves as both a linter and LSP for Rego (OPA policy language).

---

### SQL — `sqls`

```sh
go install github.com/sqls-server/sqls@latest
```

Neovim name: `sqls` | Binary: `sqls`
Repo: <https://github.com/sqls-server/sqls>

---

### XML — `lemminx`

Download from <https://github.com/eclipse/lemminx/releases> and place on `$PATH` as `lemminx`.

Neovim name: `lemminx` | Binary: `lemminx`

---

## Terraform / HCL (already configured)

`terraformls` handles both `terraform`/`tf` and `hcl` filetypes.

```sh
# Arch
pacman -S terraform-ls
# or download from https://github.com/hashicorp/terraform-ls/releases
```

`tflint` is configured as a separate linter server:

```sh
# https://github.com/terraform-linters/tflint/releases
```

---

## No LSP available

These parsers have treesitter highlighting but no known language server:

| Filetype | Treesitter parser |
|---|---|
| awk | `awk` |
| bpftrace | `bpftrace` |
| gitconfig | `git_config` |
| gitignore | `gitignore` |
| gnuplot | `gnuplot` |
| gosum | `gosum` |
| dosini (ini) | `ini` |
| jq | `jq` |
| mermaid | `mermaid` |
| sshconfig | `ssh_config` |
| strace | `strace` |
