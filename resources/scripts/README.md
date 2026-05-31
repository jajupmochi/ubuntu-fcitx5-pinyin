# Scripts

The copy-paste scripts from the blog post's appendix 12
(<https://jajupmochi.github.io/blog.html?post=ubuntu-fcitx5-pinyin&lang=en>),
as ready-to-run files. Run in this order:

| # | Script | Needs root? | What it does |
|---|---|---|---|
| 1 | `finish-install.sh` | **yes** (sudo / pkexec) | apt-install fcitx5 + addons + Lua + LXGW WenKai, switch IM, env vars, autostart (12.2) |
| 2 | `deploy-config.sh` | no | deploy the fcitx5 engine config; set `LAYOUT=<xkb>` for your keyboard (12.3) |
| 3 | `setup-kimpanel.sh` | no | install + theme the Kimpanel extension + dog frames + font (12.4) — relogin after |
| 4 | `install-dicts.sh` | no | install zhwiki + 肥猫 + a curated set of Sogou cell dictionaries (12.5) |
| 5 | `enable-wayland.sh` | **yes** | optional: re-enable Wayland in GDM, then reboot (12.6) |
| 6 | `verify.sh` | no | end-to-end check (12.7) |

Only steps **1** and **5** need administrator rights. On a machine without
passwordless sudo, run them with `pkexec bash <script>` (a GNOME password
dialog appears) — they detect root and skip the internal `sudo`.

Override defaults with env vars, e.g. `LAYOUT=ch deploy-config.sh`,
`U5=~/ubuntu-fcitx5-pinyin setup-kimpanel.sh`.

See the post's section 11 for the dictionary catalogue (what each is, whether
to install it) and the ECS/DCS Sogou-format pitfall.
