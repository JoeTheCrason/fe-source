# Roblox NPC Control Panel 🎮

A sleek, high-performance administrative and utility panel designed for advanced NPC manipulation, network ownership interaction, and camera targeting inside Roblox environments. Built with a modern, dark-themed UI design optimized for clean visual hierarchy and usability.

---

## ✨ Features

### 🎯 Targeting & Selection (Left Column)
* **Click to Select NPC:** Toggle manual cursor selection to instantly bind an NPC in the game world to your active controls.
* **Auto-Select Nearest NPC:** Automates targeting logic by running a real-time distance scan to bind the closest owned NPC to your character frame.
* **Network Ownership Visualizer:** Highlights and tracks exactly which entities are running under your player network authority.
* **Live Status Display:** Dedicated dashboard readout indicating the name of your currently targeted entity.

### ⚙️ Command & Control Suite (Center Column)
The panel features structural control cards for discrete target interactions:
* **Perspective Controls:**
  * `spectate npc` – Smoothly binds and tracks the player camera view directly to the selected target.
  * `control npc` – Take active driver/dummy control over the target entity until network ownership changes or drops.
* **Positional Mechanics:**
  * `bring npc` – Instantly teleports the target entity to your player coordinates.
  * `goto npc` – Teleports your character position directly to the target.
  * `following npc` – Forces the targeted NPC to establish pathfinding and actively follow you.
* **State & Physics Manipulation:**
  * `npc sit state` / `npc jump state` – Forces immediate character physics updates on the target.
* **Execution & Removal:**
  * `kill npc` – Triggers instant health depletion on the target.
  * `punish npc` – Sends the target entity disappearing into the void/outer space.

### 🌀 Passive Auras (Right Column)
* **Kill Aura (Any NPC):** Automated proximity radius loop that continuously neutralizes any active NPC entering your threat perimeter.
* **Jump Aura (Any NPC):** Proximity-based loop that forces continuous jump states on any surrounding NPCs.

---

## 🖼️ Interface Preview

| Main Controls View | State & Action View |
| :---: | :---: |
| ![Main Controls View](https://media.discordapp.net/attachments/1231302250194931812/1510850327988146387/7b89f44a-65e0-41e7-91e5-d7ea5ee5c302.png?ex=6a1e5084&is=6a1cff04&hm=a9480109369ea76541fa933593bfeb9fe3acc4dd907a50ea473804bf291dcd4e&=&format=webp&quality=lossless&width=621&height=445) | ![State & Action View](https://cdn.discordapp.com/attachments/1231302250194931812/1510850449790734546/d3fb84bb-810c-4db6-9218-0e429b9a7e14.png?ex=6a1e50a1&is=6a1cff21&hm=b386bcd0d2a3212f00c96d348921b88a7ca86e4bc039dc79729ceda24c77991a) |

---

## 🚀 Installation & Usage

To execute this interface in your game engine or executor environment, paste the standard bootstrapper code into your execution tool:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JoeTheCrason/fe-source/refs/heads/main/NPC/source/main.Luau"))()
