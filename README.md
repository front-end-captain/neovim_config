<img src="./assets/screen_shot.png" />

In WSL(eg. Ubuntu), should export this env in `~/.zshrc`:
```shell
# sudo apt install --no-install-recommends wslu
export WINDOWS_HOME=$(wslpath "$(wslvar USERPROFILE)")
```

create wezterm color schemes config file:

```shell
# on macos
touch ~/.config/wezterm/wezterm_color_schemes.lua

# on windows11 powershell
New-Item -ItemType File -Path ~\.config\wezterm\wezterm_color_schemes.lua
```

and write following content:
```lua
return {
  {
    name = "FishTank",
    background = "dark",
  },
  {
    name = "Gruvbox Material (Gogh)",
    background = "dark",
  },
  {
    name = "seoulbones_dark",
    background = "dark",
  },
  {
    name = "Everforest Dark (Gogh)",
    background = "dark",
  },
  {
    name = "Atelier Savanna Light (base16)",
    background = "light",
  },
  {
    name = "Vs Code Light+ (Gogh)",
    background = "light",
  },
  {
    name = "Atelier Forest Light (base16)",
    background = "light",
  },
}
```
