local cfg = {}

cfg["items"] = {
    {
        priority = 2,
        ["drop of Molten Polybenzimidazole"] = {512000, 16000, "molten.polybenzimidazole"},
    },
    {
        -- Priority mode: every cycle, recipe groups with higher priority
        -- will be attempted first, default 0 if unspecified (priorityMode = false: recipe groups are randomized in order).
        -- randomizeFrequency = k: every k cycles, the order in which these items are attempted to craft is shuffled (k=0: disable this behavior)
        priority = 3,
        ["Aluminium Ingot"] = {nil, 16},
        ["Stainless Steel Ingot"] = {512, 8},
    }
}

-- Higher values reduce lag, but decrease throughput.
cfg["sleep"] = 10

-- Randomizes the order recipes are scheduled within their group
-- Higher values reduce lag, but lower values increase fairness.
-- 0 to disable.
-- If priorityMode is false, recipe groups are additionally scheduled in random order.
cfg["randomizeFrequency"] = 2

-- false: disable randomization of the order recipe groups are attemped
-- to be scheduled.
-- true: higher priority recipe groups are scheduled first.
cfg["priorityMode"] = false

return cfg
