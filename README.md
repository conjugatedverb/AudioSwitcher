# 🔊 AudioSwitcher

**AudioSwitcher** is a lightweight macOS app that lets you instantly switch between audio output devices — without opening System Settings (accept on first launch, sometimes).

If you are like me you go between headphones and your speakers often, but hate having to click a drop down menu and then click
on the audio source and wait for it to negotiate the handshake and 10 seconds later you wish you wouldn't have done that. This 
is often how I feel too. So I decided to see if I could make it faster with apple scripts and then put it in a package for you 
guys to play with. It is OSA and Swift all done without running Xcode, it will need permissions on first launch to run command 
line code, but in my opinion I find it to be worth it and it is only handling local interactions. Please take a look at the files.

This is my first project of my own that I am sharing here. I would like to hear what you have to say and if you found this to be 
helpful for your own future projects. Let creativity reign free!



 
- ⚡️ Rapid-Audio Output switching
  
## 📸 Screenshot

<img width="378" alt="Screenshot 2025-05-19 at 10 16 33 PM" src="https://github.com/user-attachments/assets/c6a0477e-7c1b-43eb-b3b6-219779023cdd" />

---

## 💻 Requirements

- macOS 11.0+
- Swift 5.5+
- Terminal with developer tools (`xcode-select --install` if needed)

---

## 🔧 Build & Run

Clone the repo and run these commands:

```bash
git clone https://github.com/yourname/AudioSwitcher.git
unzip AudioSwitcher.zip
cd AudioSwitcher
swift build
cp .build/debug/AudioSwitcher build/AudioSwitcher.app/Contents/MacOS/AudioSwitcher
open build/AudioSwitcher.app

run.sh creates the .app

There is a pre-built .app file in the zipped file as well if you don't want to run it in terminal and just want to play with it.

AudioSwitcher/
├── Sources/
│   └── AudioSwitcher/
│       ├── AudioSwitcherApp.swift
│       ├── AppDelegate.swift
│       ├── AudioManager.swift
├── Package.swift
└── run.sh  ← optional helper script




