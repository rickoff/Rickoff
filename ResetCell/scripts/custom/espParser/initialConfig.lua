local keyOrder = {
    "espPath",
    "cache",
    "preload",
    "useRequiredDataFiles",
    "requiredDataFiles",
    "files",
}

local values = {
    espPath = "custom/esps/",
    cache = false,
    preload = false,
    useRequiredDataFiles = true,
    requiredDataFiles = "requiredDataFiles.json",
    files = {},
}

return { keyOrder = keyOrder, values = values }