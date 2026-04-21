export-env {
  $env.config = (
    $env.config?
    | default {}
    | upsert hooks { default {} }
    | upsert hooks.env_change { default {} }
    | upsert hooks.env_change.PWD { default [] }
  )
  let __zoxide_hooked = (
    $env.config.hooks.env_change.PWD | any { try { get __zoxide_hook } catch { false } }
  )
  if not $__zoxide_hooked {
    $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append {
      __zoxide_hook: true,
      code: {|_, dir| ^zoxide add -- $dir}
    })
  }
}
def --env --wrapped __zoxide_z [...rest: string] {
  let path = match $rest {
    [] => {'~'},
    [ '-' ] => {'-'},
    [ $arg ] if ($arg | path expand | path type) == 'dir' => {$arg}
    _ => {
      ^zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n"
    }
  }
  cd $path
}
def --env --wrapped __zoxide_zi [...rest:string] {
  cd $'(^zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
}

$env.config = {
    color_config: {
    }
    show_banner: false
    ls: {
        use_ls_colors: true
    }
    rm: {
        always_trash: false
    }
    table: {
        mode: default
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
        }
        header_on_separator: false
    }
    error_style: "fancy"
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
        }
        use_ls_colors: true
    }
}

# Alias

# zoxide
alias z = __zoxide_z
alias zi = __zoxide_zi

alias cd = __zoxide_z
alias cdi = __zoxide_zi

# profile
alias ep = config nu

# neovim
alias nv = nvim
alias nvconf = nvim ~/AppData/Local/nvim

# ls
alias ll = ls -l
alias cpr = cp -r
alias rmr = rm -r
alias rmrf = rm -rf

# git
alias g = git
alias ga = git add
alias gb = git branch
alias gc = git commit
alias gco = git checkout
alias gf = git fetch
alias gm = git merge
alias gpl = git pull
alias gpu = git push
alias gst = git status

# python
alias gg = uv run python

# explorer
alias e = explorer.exe

# cat
alias cat = bat

# god
alias shutdown = shutdown /s /t 0
alias reboot = shutdown /r /t 0
alias logout = shutdown /l /t 0

def lsd [] { ls | where type == dir }
def lsf [] { ls | where type == file }
def lsg [] { ls | sort-by type name -i | grid -c }
def --env cx [arg] { cd $arg; ls -l }

source everforest.nu
