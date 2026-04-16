# Smart Maintainer

<!--toc:start-->
- [Smart Maintainer](#smart-maintainer)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Config](#config)
    - [Items](#items)
    - [Fluids](#fluids)
<!--toc:end-->

Keeps stock of items up to a threshold or indefinitely. Uses randomization to prevent crafts, on average, from
repeatedly taking high priority crafting CPUs and blocking others.

## Requirements

In addition to an functional OpenComputers computer,

- A full block ME interface connected to an OpenComputers adapter;
- Crafting Monitors on **all** CPUs attached to the interface's network;
- An internet card.

## Installation

Download and install in the computer:

```bash
wget raw.githubusercontent.com/rajsugavanam/Smart-Maintainer/master/installer.lua && installer
```

This requires an internet card.

Run the program using

```bash
Maintainer
```

## Config

Change maintained items in `config.lua`.

Items are specified within **recipe groups**:
```lua
cfg["items"] = {
    {
        priority = 2,
        ["drop of Molten Polybenzimidazole"] = {512000, 16000, "molten.polybenzimidazole"},
    },
    {
        -- Priority mode: every cycle, recipe groups with higher priority
        -- will be attempted first, default 0 if unspecified
        -- (priorityMode = false: recipe groups are randomized in order).

        -- randomizeFrequency = k: every k cycles, the order in which
        -- these items are attempted to craft is shuffled
        -- (k=0: disable this behavior)
        priority = 3,
        ["Aluminium Ingot"] = {nil, 16},
        ["Stainless Steel Ingot"] = {512, 8},
    }
}
```

### Items

`["item_name"] = {threshold, batch_size}`.

### Fluids

`["item_name"] = {threshold, batch_size, registry_name}`.

> [!TIP]
> Find the registry name of a fluid by hovering over the fluid in NEI.

> [!NOTE]
> If you do not require a limit for an item to be stocked up to, set `threshold` to `nil`.

> [!NOTE]
> Reboot the computer and rerun `Maintainer` after changing the config values.
