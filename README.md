# ASA Lost Colony City NPC Fixer

Utility to repair the **Lost Colony city NPC spawn issue** in **ARK: Survival Ascended** savegames.

This tool automatically installs the required parser, verifies the savegame structure and runs the fix script.

---

## Quickstart

#### 1. Place your savegame in:

```text
YOUR_SAVEGAME_HERE/LostColony_WP.ark
```
Only the `.ark` file - nothing more needed.

#### 2. Run Fixer:

```powershell
start_savegame_fixer.ps1
```

Right-Click "Execute with Powershell"

#### 3. Go to YOUR_SAVEGAME_HERE:
```text
YOUR_SAVEGAME_HERE/LostColony_WP_fixed.ark
```

Use the `LostColony_WP_fixed.ark` on your `SavedArks/LostColony_WP` directoy. Rename the file before and replace it with yours.

**Do not forget to make a backup before!**

---

## What this tool does

This tool:

- checks if **Python** is installed
- ensures **pip** is available
- installs the required **ark-save-parser** package
- verifies the savegame structure
- runs the fix script to repair broken **Lost Colony city NPC spawns**

---

## Requirements

- Windows
- PowerShell 5.1+
- Python **3.10+**

If Python is not installed yet, download and install it from:

https://www.python.org/ftp/python/3.14.3/python-3.14.3-amd64.exe

During installation, make sure Python is added to **PATH** and installing also **PIP**.

---

## Setup

1. Download or clone this repository.
2. Place your savegame in the following folder:

```text
YOUR_SAVEGAME_HERE
```

3. Make sure the required file exists here:

```text
YOUR_SAVEGAME_HERE/LostColony_WP.ark
```

4. Run the script:

```powershell
start_savegame_fixer.ps1
```

---

## Important

Always **create a backup of your savegame before replacing**.

While the tool is designed to be safe, modifying savegames always carries some risk.

---

## Credits

This project relies on the excellent **ark-save-parser** created by **Vincent Henau**.

Repository: https://github.com/VincentHenauGithub/ark-save-parser

_Without this library, this tool would not be possible. Thanks again mate for assistance._

---

## Donations

This tool is **completely free to use** and there is **no need to donate**.

However, if this project helped you and you would like to support the work behind it, both the developer of **ark-save-parser** and the creator of this tool are always happy about a donation.

### Support VincentHenauGithub

If this tool helped you, please also consider supporting **Vincent Henau**, the creator of **ark-save-parser**.

Vincent created and maintains the ark-save-parser framework, which helps cluster owners manage ARK communities more effectively.  
His work enables powerful tools, automation and unique community features — and as shown here, it can even help solve deeper issues that Wildcard has ignored for weeks.

Vincent is also very active in supporting the community and helping users with his project whenever he can.

If you’d like to say thanks, consider buying him a coffee ☕

[Donate for Vincent](https://www.paypal.com/donate/?hosted_button_id=BV63CTDUW7PKQ) or go to his [Repository](https://github.com/VincentHenauGithub/ark-save-parser).

### Support me

If you found this tool helpful, you can also support my work.  
I spent several days debugging the issue, starting the discussion in the Wildcard forums, informing other cluster owners and developers, and organizing everything from communication to this small fix tool.

Forum discussion: [Link to Wildcard Forum](https://survivetheark.com/index.php?/forums/topic/773726-asa-thrallscity-npcs-no-longer-spawningpatrol-on-lostcolony-nomodsvanilla/#comment-3707416)

[Donate for me / pleinx](https://www.paypal.com/paypalme/pleinx)

---
## Contact
If you need support with this, you can join my [discord](https://discord.com/invite/fkcCsD8e2x) and create a ticket or DM me.

---

## License

This project is licensed under the **MIT License**.
You are free to use, modify and distribute it.

---

## Disclaimer

This project is **not affiliated with Studio Wildcard** or **ARK: Survival Ascended**.
Use at your own risk.
