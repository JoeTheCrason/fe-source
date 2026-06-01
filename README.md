# Roblox NPC Control Panel

A sleek, high-performance administrative and utility panel designed for advanced NPC manipulation, network ownership interaction, and camera targeting inside Roblox environments. Built with a modern, dark-themed UI design optimized for clean visual hierarchy and usability.

---

## Features

### Targeting & Selection (Left Column)
* **Click to Select NPC:** Toggle manual cursor selection to instantly bind an NPC in the game world to your active controls.
* **Auto-Select Nearest NPC:** Automates targeting logic by running a real-time distance scan to bind the closest owned NPC to your character frame.
* **Network Ownership Visualizer:** Highlights and tracks exactly which entities are running under your player network authority.
* **Live Status Display:** Dedicated dashboard readout indicating the name of your currently targeted entity.

### Command & Control Suite (Center Column)
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

### Passive Auras (Right Column)
* **Kill Aura (Any NPC):** Automated proximity radius loop that continuously neutralizes any active NPC entering your threat perimeter.
* **Jump Aura (Any NPC):** Proximity-based loop that forces continuous jump states on any surrounding NPCs.

---

## Interface Preview

| Main Controls View | State & Action View |
| :---: | :---: |
| ![Main Controls View](https://media.discordapp.net/attachments/1231302250194931812/1511153856275546173/F80FD33C-EC1A-4140-88FB-91D85E98E271.png?ex=6a1f6b33&is=6a1e19b3&hm=b795c769259f628492110aaabca283395340c9958ac7c911d344dee0f59dc75c&=&format=webp&quality=lossless&width=549&height=394) | ![State & Action View](https://media.discordapp.net/attachments/1231302250194931812/1511153917889740810/656C66D2-D2F0-404B-99B5-D5D366D6D8BA.png?ex=6a1f6b41&is=6a1e19c1&hm=59c64abe8d18d98d521a52f79cb24b3e3c85ab71d6ed8266d87235ef4a76c87b&=&format=webp&quality=lossless&width=537&height=389) |

---

## Installation & Usage

To execute this interface in your game engine or executor environment, paste the standard bootstrapper code into your execution tool:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/JoeTheCrason/fe-source/refs/heads/main/NPC/source/main.Luau"))()
