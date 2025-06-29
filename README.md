# 🐍 Snake Game in x86 Assembly

A classic Snake game fully developed in **8086 Assembly**, designed to run in **DOSBox**.  
This project showcases low-level graphics, keyboard input handling, random number generation, game loops, and file handling — all in raw Assembly.

> 🔧 Created entirely with `TASM`, `TLINK`, and executed in a 16-bit real-mode DOS environment.

---

## 📦 Features

- VGA graphics mode (320x200)
- Snake grows on apple collision
- Directional movement using keyboard arrows
- Score tracking
- Sound effects using PC speaker
- Game Over screen + return to start screen
- Full mouse-based menu navigation (start, color selection, leaderboard)
- Save/load leaderboard from file

---

## ▶️ How to Run

1. Install [DOSBox](https://www.dosbox.com/).
2. Clone or download this repository.
3. Make sure the following files are present in the game folder:
   - `TASM.EXE`
   - `TLINK.EXE`
   - `RTM.EXE`
   - `DPMI16BI.OVL`
4. In DOSBox, navigate to the project folder.
5. Run the game:
  **run snake**

   The game will launch and run smoothly!

## 🛠 Tech Stack
- Language: x86 Assembly (TASM)
- Graphics Mode: Mode 13h (320x200, 256 colors)
- Tools: Turbo Assembler (TASM), Turbo Linker (TLINK)
- Emulation: DOSBox


## 📁 File Structure
- `snake.asm`         - Main game code
- `start.asm`         - first screen
- `game.asm`          - the actual game 
- `losescr.asm`       - lose screen
- `dataseg.asm`       - all the vars (data segment)
- `procs.asm`         - all the procedures
- `macros.asm`        - all the macros
- `run.bat`           - running file
## ⚠️ Disclaimer
This game runs in 16-bit mode and is not compatible with modern operating systems directly.
Use DOSBox or a 16-bit DOS emulator to run it.

## ✍️ Author
created by **noairwin**
