$env.PROMPT_COMMAND = { ||
    let dir = ($env.PWD | str replace $env.USERPROFILE "~")
    let reset = (ansi reset)

    $"[($dir)]\n➜ "
}
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
