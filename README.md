
# **Eye-Tracked HUD**

Keeps the view of Night City completely clean and cinematic, seamlessly fading those sticky HUD elements into view only when you look directly at them. *(Note: A Tobii Eye Tracker is required to use this mod)*

![Preview demo](https://i.imgur.com/vM9hn2Q.gif)

---

### **Features**

1. The main HUD elements are divided across six distinct trigger zones to keep unneeded elements hidden:

* **Top Left:** Health Bar, Stamina Bar, and active Buff List*
* **Top Right:** Minimap and Wanted Bar.
* **Upper Middle Right:** Active Quest and objectives.
* **Lower Middle Right:** Contextual Input Hints.
* **Bottom Left:** Quick actions/items, Autodrive UI and Vehicle Speedometer.
* **Bottom Right:** Equipped Weapon and Crouch Indicator.

 \* - *Your gaze intentionally won't show health bar and buff list if health is full and no buffs are applied. The stamina bar also does not show on gaze if it's full.*

**The zone areas upon which your gaze shows the elements are configurable in the `EyeTrackedHUDConfig.reds` file via text editor.**

2. Miscellaneous

* **3D Marker transparency** - Enabling this heavily reduces the opacity of all 3D markers in order for them to not stick out like sore thumbs in a clean HUD. Disabled by default, but highly recommended (enable at the bottom of the `EyeTrackedHUDConfig.reds` file).

---

### **Installation**

* Download and install the specified requirements: [redscript](https://github.com/jac3km4/redscript), [RED4ext](https://github.com/wopss/RED4ext) and [Codeware](https://github.com/psiberx/cp2077-codeware).
* Download the the latest release archive and extract it into the game's root directory.

#### **Troubleshooting**

In case the HUD elements do not show on gaze, you can check the mod's `tobii_debug.log` file to see if the game engine is detecting your Tobii Eye Tracker.

---

### **Credits**

* This mod utilizes the **Tobii Game Integration (TGI) SDK** to communicate with eye-tracking hardware. All rights to the Tobii SDK, its binaries, and associated trademarks belong to **Tobii AB**.