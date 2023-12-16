# Nushell Environment Config File

def create_left_prompt [] {
    let path_segment = if (is-admin) {
        $"(ansi red_bold)($env.PWD)"
    } else {
        $"(ansi green_bold)($env.PWD)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | format date '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = { "〉" }
$env.PROMPT_INDICATOR_VI_INSERT = { ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { "〉" }
$env.PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

$env.EDITOR = nvim
$env.HOMEBREW_PREFIX = "/opt/homebrew";
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
$env.HOMEBREW_REPOSITORY = "/opt/homebrew";
# $env.MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
# $env.INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
$env.PATH = (
  $env.PATH 
	| split row (char esep) 
	| prepend '~/.cargo/bin'
	| prepend '/opt/homebrew/bin'
	| prepend '/opt/homebrew/sbin'
)

zoxide init nushell | save -f ~/.zoxide.nu

let $java_path = ("~/.asdf/installs/java/temurin-11.0.15+10/bin/java" | path expand)
if (not ($java_path | is-empty))  {
    let $full_path = (realpath $java_path | lines | first | str trim)
    let $java_home = ($full_path | path dirname | path dirname)
    $env.JAVA_HOME = $java_home
    $env.JDK_HOME = $java_home
}
