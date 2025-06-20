# Classic Offensive (CS:CO) Linux Server Fix Pack

> **Purpose**  Restore a functional **MetaMod 1.12** + **SourceMod 1.13-dev** stack on *native* Linux servers after Valve’s 64-bit Source-engine update (19 Feb 2025) broke listen/dedicated servers for CS:GO-based mods such as **Classic Offensive**.

---

## What’s included

| Path | What it is | Why you need it |
|------|------------|-----------------|
| `bin/linux64/libtier0_srv.so` | **Symlink** → `libtier0.so` | Re-creates the server-variant filename Valve removed. |
| `bin/linux64/libvstdlib_srv.so` | **Symlink** → `libvstdlib.so` | Same deal. |
| `addons/metamod/` | **MetaMod:Source 1.12** (latest build) | 1.12 is confirmed stable on the new 64-bit engine when the two symlinks are present. |
| `addons/sourcemod/` | **SourceMod 1.13-dev** ( bleeding-edge ) | 1.13 contains the 64-bit gamedata & extension fixes; older 1.12 releases crash. |
| `scripts/startcsco` | Sample tmux-wrapped launcher | Starts `srcds_run` with `-insecure` and the correct env vars. |
| `scripts/attachcsco` | Convenience helper | Attaches to the running tmux session. |

All binaries are untouched upstream builds. The repo is just a drop-in overlay that fixes the file-layout mismatch.

---

## Quick start

1. **Install the base Classic Offensive server** by following the tutorial:  
   <https://lukestephens.co.za/writing/how-to-host-a-dedicated-classic-offensive-server/20bf90ec476b806c9e76ce2c156e128c>
2. **Overlay this fix-pack** into the server folder (replace `~/servers/csco_server` with your own path):
   ```bash
   cd ~/servers/csco_server
   git clone https://github.com/imprisonedmind/csco_linux_server .
   ```
3. **Run it**:
   ```bash
   ./start/sh   # launches server
   ```
4. In the server console (or via RCON) verify:
   ```
   meta version   # should show MetaMod:Source 1.12.x
   sm version     # should show SourceMod 1.13.x-dev
   ```

---

## Manual overlay (if you prefer not to clone)

1. **Symlink the missing libs**
   ```bash
   cd /path/to/csco/bin/linux64
   ln -sf libtier0.so   libtier0_srv.so
   ln -sf libvstdlib.so libvstdlib_srv.so
   ```
2. **Drop MetaMod 1.12**
   ```bash
   cd /path/to/csco/csgo
   wget https://mms.alliedmods.net/mmsdrop/1.12/mmsource-latest-linux.tar.gz -O mm.tar.gz
   tar xzf mm.tar.gz && rm mm.tar.gz
   ```
3. **Drop SourceMod 1.13-dev**
   ```bash
   wget https://www.sourcemod.net/smdrop/1.13/sourcemod-latest-linux.tar.gz -O sm.tar.gz
   tar xzf sm.tar.gz && rm sm.tar.gz
   ```
4. **Launch** using your own script ensuring `-insecure` is set (CSCO will not work correctly in a secure VAC server).

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Seg-fault on first player connect | Using SourceMod ≤ 1.12 or an outdated extension | Upgrade to 1.13-dev; remove stale `.so` files in `addons/sourcemod/extensions`. |
| `meta` works but `sm` is unknown | Missing `addons/metamod/sourcemod.vdf` | Re-extract SourceMod or copy the VDF from this repo. |
| `wrong ELF class: libmimalloc.so` warnings | Valve ships a 32-bit copy; harmless | Ignore or rename `libmimalloc.so` to silence. |

---

## Credits & references

* MetaMod:Source — <https://github.com/alliedmodders/metamod-source>
* SourceMod — <https://github.com/alliedmodders/sourcemod>
* Valve issue tracker (missing `_srv` libs) — <https://github.com/ValveSoftware/Source-1-Games/issues/6005>
* Original AlliedModders thread — *MetaMod:Source not loading (Linux listenserver only)*

Maintained by **@imprisonedmind**. Pull requests that keep the versions/links fresh are welcome.
