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
| ![Main Controls View](blob:https://gemini.google.com/7b89f44a-65e0-41e7-91e5-d7ea5ee5c302) | ![State & Action View](blob:https://gemini.google.com/d3fb84bb-810c-4db6-9218-0e429b9a7e14) |

---

## 🚀 Installation & Usage

To execute this interface in your game engine or executor environment, paste the standard bootstrapper code into your execution tool:

```lua
-- Ensure your execution environment supports standard Luau Instance API manipulation
local NPC_Panel = loadstring(game:HttpGet("[https://raw.githubusercontent.com/YourUsername/RepoName/main/src/main.lua](https://raw.githubusercontent.com/YourUsername/RepoName/main/src/main.lua)"))()
NPC_Panel:Initialize()
