param (
    [string]$LogFilePath = "D:\MultiMC\instances\GWMS\.minecraft\logs\latest.log",
    [string]$DestinationDirectory = ""
)

if (-not (Test-Path $LogFilePath)) {
    Write-Host "Specified file does not exist." -ForegroundColor Red
    Write-Host "  $LogFilePath" -ForegroundColor Red
}
if ("" -eq $DestinationDirectory) {
    $DestinationDirectory = "$PSScriptRoot\splitlogs"
}
if (Test-Path "$DestinationDirectory\*.log") {
    Remove-Item "$DestinationDirectory\*.log" -Force
}

#Populate known mod name/id mappings
$modIdMapping = @{
    "AE2:C" = "appliedenergistics2";
    "ambientsounds" = "ambientsounds";
    "Apotheosis : Enchantment" = "apotheosis";
    "Astral Sorcery" = "astralsorcery";
    "attained_drops" = "attained_drops";
    "bettercaves" = "bettercaves";
    "BonsaiTrees2" = "bonsaitrees";
    "Bookshelf" = "bookshelf";
    "Botany Pots" = "botanypots";
    "charm" = "charm";
    "com.black_dog20.servertabinfo.ServerTabInfo" = "servertabinfo";
    "com.darkere.serverconfigupdater.ServerConfigUpdater" = "serverconfigupdater";
    "com.jaquadro.minecraft.storagedrawers.StorageDrawers" = "storagedrawers";
    "com.maciej916.maessentials.common.util.LogUtils" = "maessentials";
    "com.mojang.text2speech.NarratorWindows" = "minecraft";
    "com.oitsjustjose.vtweaks.VTweaks" = "vtweaks";
    "com.performant.coremod.Performant" = "performant";
    "com.polyvalord.extlights.Extlights" = "extlights";
    "com.refinedmods.refinedstorage.apiimpl.API" = "refinedstorage";
    "com.teamabnormals.abnormals_core.core.AbnormalsCore" = "abnormalscore";
    "covalent" = "covalent";
    "cpw.mods.modlauncher.Launcher" = "misc";
    "cpw.mods.modlauncher.LaunchServiceHandler" = "misc";
    "Cucumber Library" = "cucumber";
    "Dark Paintings" = "darkpaintings";
    "Dark Utilities" = "darkutils";
    "doubleslabs" = "doubleslabs";
    "druidcraft" = "druidcraft";
    "Equipment Tooltips" = "equipmenttooltips";
    "FluxNetworks" = "fluxnetworks";
    "immersiveengineering" = "immersiveengineering";
    "incontrol" = "incontrol";
    "inspirations" = "inspirations";
    "inventoryhud" = "inventoryhud";
    "JarSignVerifier" = "misc";
    "jeresources" = "jeresources";
    "Kiwi" = "kiwi";
    "KubeJS" = "kubejs";
    "KubeJS Startup" = "kubejs";
    "lostcities" = "lostcities";
    "mcjtylib" = "mcjtylib";
    "mcwbridges" = "mcwbridges";
    "mcwdoors" = "mcwdoors";
    "mcwfurnitures" = "mcwfurnitures";
    "mcwwindows" = "mcwwindows";
    "Mekanism" = "mekanism";
    "Meson" = "misc";
    "mezz.jei.ingredients.IngredientManager" = "jei";
    "mezz.jei.load.PluginCaller" = "jei";
    "mezz.jei.load.registration.AdvancedRegistration" = "jei";
    "mezz.jei.plugins.vanilla.ingredients.item.ItemStackListFactory" = "jei";
    "mezz.jei.recipes.RecipeManager" = "jei";
    "mezz.jei.util.LoggedTimer" = "jei";
    "minecolonies" = "minecolonies";
    "minecolonies.requestsystem" = "minecolonies";
    "mixin" = "mixinbootstrap";
    "Mystical Agriculture" = "mysticalagriculture";
    "net.blay09.mods.craftingtweaks.CraftingTweaks" = "craftingtweaks";
    "net.minecraft.advancements.AdvancementList" = "minecraft";
    "net.minecraft.client.audio.SoundEngine" = "minecraft";
    "net.minecraft.client.audio.SoundHandler" = "minecraft";
    "net.minecraft.client.audio.SoundSystem" = "minecraft";
    "net.minecraft.client.gui.NewChatGui" = "minecraft";
    "net.minecraft.client.gui.screen.ConnectingScreen" = "minecraft";
    "net.minecraft.client.Minecraft" = "minecraft";
    "net.minecraft.client.network.play.ClientPlayNetHandler" = "minecraft";
    "net.minecraft.client.renderer.model.ModelBakery" = "minecraft";
    "net.minecraft.client.renderer.texture.AtlasTexture" = "minecraft";
    "net.minecraft.command.arguments.ArgumentTypes" = "minecraft";
    "net.minecraft.entity.EntityType" = "minecraft";
    "net.minecraft.network.datasync.EntityDataManager" = "minecraft";
    "net.minecraft.resources.SimpleReloadableResourceManager" = "minecraft";
    "net.minecraft.world.biome.Biome" = "minecraft";
    "net.minecraft.world.storage.loot.LootTableManager" = "minecraft";
    "net.minecraftforge.common.BiomeDictionary" = "forge";
    "net.minecraftforge.common.DimensionManager" = "forge";
    "net.minecraftforge.common.ForgeConfigSpec" = "forge";
    "net.minecraftforge.common.ForgeMod" = "forge";
    "net.minecraftforge.common.MinecraftForge" = "forge";
    "net.minecraftforge.coremod.CoreMod.astralsorcery" = "forge";
    "net.minecraftforge.coremod.CoreMod.immersiveengineering" = "forge";
    "net.minecraftforge.coremod.CoreMod.observerlib" = "forge";
    "net.minecraftforge.eventbus.EventBus" = "forge";
    "net.minecraftforge.fml.DeferredWorkQueue" = "forge";
    "net.minecraftforge.fml.loading.FixSSL" = "forge";
    "net.minecraftforge.fml.network.FMLHandshakeHandler" = "forge";
    "net.minecraftforge.fml.network.NetworkHooks" = "forge";
    "net.minecraftforge.fml.VersionChecker" = "forge";
    "net.minecraftforge.registries.ForgeRegistry" = "forge";
    "net.minecraftforge.registries.GameData" = "forge";
    "net.silentchaos512.utils.config.ConfigSpecWrapper" = "silentlib";
    "Obfuscate" = "obfuscate";
    "occultism" = "occultism";
    "paintings" = "paintings";
    "patchouli" = "patchouli";
    "PluginManager" = "misc";
    "powah" = "powah";
    "projecte" = "projecte";
    "psi" = "psi";
    "quark" = "quark";
    "se.mickelus.tetra.client.model.ModularModelLoader" = "tetra";
    "se.mickelus.tetra.data.DataStore" = "tetra";
    "se.mickelus.tetra.data.MergingDataStore" = "tetra";
    "Silent Gear" = "silentgear";
    "Silent's Gems" = "silentgems";
    "strange" = "strange";
    "structurize" = "structurize";
    "tellme" = "tellme";
    "TerraForged" = "terraforged";
    "thelm.jaopca.data.DataCollector" = "jaopca";
    "thelm.jaopca.localization.LocalizationRepoHandler" = "jaopca";
    "thelm.jaopca.materials.MaterialHandler" = "jaopca";
    "thelm.jaopca.modules.ModuleHandler" = "jaopca";
    "tombstone" = "tombstone";
    "tv.mapper.embellishcraft.EmbellishCraft" = "embellishcraft";
    "tv.mapper.embellishcraftbop.EmbellishCraftBOP" = "embellishcraftbop";
    "tv.mapper.mapperbase.MapperBase" = "mapperbase";
    "tv.mapper.roadstuff.RoadStuff" = "roadstuff";
    "Waterworks" = "waterworks";
    "wile.engineersdecor.ModEngineersDecor" = "modengineersdecor";
    "yalter.mousetweaks.Logger:Log:6" = "mousetweaks"
}
function Get-ModId {
    param (
        [string]$ModName
    )
    if ($modIdMapping.ContainsKey($ModName)) {
        return $modIdMapping[$ModName]
    }
    # Special case mod names
    if ($ModName.StartsWith("com.endlesnights.torchslabsmod.")) {
        $modIdMapping.Add($ModName, "torchslabsmod");
        return "torchslabsmod"
    }
    if ($ModName.StartsWith("ejektaflex.bountiful.")) {
        $modIdMapping.Add($ModName, "bountiful");
        return "bountiful"
    }
    if ($ModName.StartsWith("org.antlr.v4.runtime.")) {
        $modIdMapping.Add($ModName, "misc");
        return "misc"
    }
    if ($ModName.StartsWith("se.mickelus.mgui.")) {
        $modIdMapping.Add($ModName, "mgui");
        return "mgui"
    }
    if ($ModName.StartsWith("xaero.")) {
        $modIdMapping.Add($ModName, "xaero");
        return "xaero"
    }
    # Didn't find a match
    $modIdMapping.Add($ModName, "unknown");
    return "unknown"
}

function Test-LogEntry {
    param (
        [string]$ModId,
        [string]$LogMessage
    )

    switch ($ModId) {
        "abnormalscore" {
            return -not ($LogMessage -match "Endimation Data Manager has Loaded \d* Endimations")
        }
        "ambientsounds" {
            return -not ($LogMessage -match "Successfully loaded sound engine\. \d* dimension\(s\) and \d* region\(s\)")
        }
        "appliedenergistics2" {
            return -not ($LogMessage -match "Post Initialization\.*")
        }
        "astralsorcery" {
            return -not (
                $LogMessage -match "Built PerkTree with \d* perks!" `
                -or $LogMessage -match "Client cache cleared!" `
                -or $LogMessage -match "Patreon effect loading finished\." `
                -or $LogMessage -match "Skipped \d* patreon effects during loading due to malformed data!" `
                -or $LogMessage -match "\[AssetLibrary\] Refreshing and Invalidating Resources" `
                -or $LogMessage -match "\[AssetLibrary\] Successfully reloaded library\."
                )
        }
        "attained_drops" {
            return -not ($LogMessage -match "Loaded config file!")
        }
        "bettercaves" {
            return -not ($LogMessage -match "Replacing biome carvers with Better Caves carvers\.\.\.")
        }
        "bonsaitrees" {
            return -not (
                $LogMessage -match "Found \d* tree models\." `
                -or $LogMessage -match "Registering \d* saplings" `
                -or $LogMessage -match "Updated soil compatibility"
                )
        }
        "bookshelf" {
            return -not ($LogMessage -match "Registering \d*.*\.")
        }
        "botanypots" {
            return -not ($LogMessage -match "Registering \d*.*\.")
        }
        "bountiful" {
            return -not (
                $LogMessage -match "Loading Bountiful listeners\.\." `
                -or $LogMessage -match "Registering to: minecraft:(?:(?:block)|(?:item)), class net\.minecraft\.(?:(?:block)|(?:item))\.(?:(?:Block)|(?:Item))"
                )
        }
        "charm" {
            return -not ($LogMessage -match "(?:(?:Creating config for)|(?:Loading)) module .*")
        }
        "covalent" {
            return -not ($LogMessage -match "(?:(?:Creating config for)|(?:Loading)) module .*")
        }
        "craftingtweaks" {
            return -not ($LogMessage -match "\w* has registered [\w\.]* for CraftingTweaks")
        }
        "cucumber" {
            return -not ($LogMessage -match "Loaded cucumber-tags.json in \d* ms")
        }
        "darkpaintings" {
            return -not ($LogMessage -match "Registering \d* paintings.")
        }
        "darkutils" {
            return -not ($LogMessage -match "Registering \d* .*\.")
        }
        "doubleslabs" {
            return -not ($LogMessage -match "Loaded \d* [\w ]* support classes")
        }
        "druidcraft" {
            return -not (
                $LogMessage -match "\w* Config: [\w\:\\\.]*druidcraft-(?:(?:server)|(?:client)).toml" `
                -or $LogMessage -match "[\w ]* registered\." `
                -or $LogMessage -match "Textures stitched\."
                )
        }
        "embellishcraft" {
            return -not (
                $LogMessage -match "1\.\d- EmbellishCraft: (?:(?:block)|(?:TE)) (?:(?:registering)|(?:listing))\." `
                -or $LogMessage -match "EmbellishCraft: (?:(?:setup started)|(?:BoP addon detected))\." `
                -or $LogMessage -match "\w* blacklisted for biome minecraft:(?:(?:nether)|(?:the_end)) in the config\."
                )
        }
        "embellishcraftbop" {
            return -not ($LogMessage -match "(?:2\.\d- )*Embellish[Cc]raft-B[Oo]P: (?:(?:block registering)|(?:block listing)|(?:setup started))\.*")
        }
        "equipmenttooltips" {
            return -not ($LogMessage -match "Detected Silent Gear!")
        }
        "extlights" {
            return -not (
                $LogMessage -match ".*H(?:(?:ello)|(?:ELLO)).*" `
                -or $LogMessage -match "DIRT BLOCK >> minecraft:dirt" `
                -or $LogMessage -match "Got game settings net.minecraft.client.GameSettings@.*"
                )
        }
        "fluxnetworks" {
            return -not (
                $LogMessage -match "(?:(?:Started)|(?:Starting)|(?:Finished)|(?:Registering)|(?:LOADING)|(?:LOADED))[\w ]*" `
                -or $LogMessage -match "FLUX NETWORKS INIT"
                )
        }
        "forge" {
            return -not (
                $LogMessage -match "Add(?:(?:ing)|(?:ed)) '\w*' ASM patch(?:(?:\.\.\.)|(?:!))" `
                -or $LogMessage -match "Inserted arm angle callback" `
                -or $LogMessage -match "Forge mod loading, version 31.2.\d+, for MC 1.15.2 with MCP \d+\.\d+" `
                -or $LogMessage -match "MinecraftForge v31.2.\d+ Initialized" `
                -or $LogMessage -match "Synchronous work queue completed in [\d\.:]+" `
                -or $LogMessage -match "Dispatching synchronous work after (?:(?:COMMON_SETUP)|(?:SIDED_SETUP)|(?:COMPLETE)): \d+ jobs" `
                -or $LogMessage -match "Connected to a modded server." `
                -or $LogMessage -match "Inserted [\w -]+ callback" `
                -or $LogMessage -match "Added Lets Encrypt root certificates as additional trust" `
                -or $LogMessage -match "Registered dimension [\w:]+ of type [\w:]+ and id \d+"
            )
        }
        "immersiveengineering" {
            return -not (
                $LogMessage -match "Attempting to download [\w ]+ from GitHub" `
                -or $LogMessage -match "Stitching \w+ Textures!" `
                -or $LogMessage -match "Finished recipe profiler for [\w ]+, took \d+ milliseconds"`
                -or $LogMessage -match "Adding recipes to JEI!!"
                )
        }
        "incontrol" {
            return -not (
                $LogMessage -match "Enabling support for Lost Cities" `
                -or $LogMessage -match "Reading spawn rules from \w+\.json"
                )
        }
        "inspirations" {
            return -not (
                $LogMessage -match "Loading replacements config file\.\.\." `
                -or $LogMessage -match "Config loaded\."
                )
        }
        "inventoryhud" {
            return -not ($LogMessage -match "clientRegistries method registred")
        }
        "jaopca" {
            return -not (
                $LogMessage -match "Found \d+ unique defined (?:(?:tags)|(?:recipes)|(?:loot tables)|(?:advancements))" `
                -or $LogMessage -match "Module thelm\.jaopca\.compat\.(?:(?:wtbwmachines)|(?:uselessmod)|(?:usefulmachinery)|(?:thermalexpansion)|(?:omegacraft)|(?:indreb)|(?:flux)|(?:crossroads))\.\w+ has missing mod dependencies, skipping" `
                -or $LogMessage -match "Added \d+ materials" `
                -or $LogMessage -match "[\w ]+localization file for language en_us[\w :]*"
                )
        }
        "kiwi" {
            return -not (
                $LogMessage -match "Invoking Mixin Connector" `
                -or $LogMessage -match "Processing \d+ KiwiModule annotations" `
                -or $LogMessage -match "(?:(?:Module )|(?:    )).+"
                )
        }
        "kubejs" {
            return -not (
                $LogMessage -match "Loaded kubejs/client.properties" `
                -or $LogMessage -match "Hello, World! \(You will only see this line once in console, during startup\)" `
                -or $LogMessage -match "Loaded script startup:\w+.js" `
                -or $LogMessage -match "Loaded \d+/\d+ KubeJS startup scripts"
                )
        }
        "lostcities" {
            return -not ($LogMessage -match "(?:(?:Creating standard)|(?:Reading existing)) profiles (?:(?:into)|(?:from)) 'config/lostcity_profiles'")
        }
        "maessentials" {
            return -not ($LogMessage -match "maessentials Setup main")
        }
        "mapperbase" {
            return -not (
                $LogMessage -match "Mapper Base setup started!" `
                -or $LogMessage -match "Bitumen ore blacklisted for biome minecraft:(?:(?:nether)|(?:the_end)) in the config\."
                )
        }
        "mcjtylib" {
            return -not (
                $LogMessage -match "XNet Detected RFTools Control: enabling support" `
                -or $LogMessage -match "Enabled support for The One Probe"
                )
        }
        {@("mcwbridges","mcwdoors","mcwfurnitures","mcwwindows") -contains $_} {
            return -not (
                $LogMessage -match "[\w ]+ registered\.*" `
                -or $LogMessage -match "Mod client setup completed"
                )
        }
        "mekanism" {
            return -not (
                $LogMessage -match "Loaded '[\w :]+' module\." `
                -or $LogMessage -match "Version \d+.\d+.\d+ initializing..." `
                -or $LogMessage -match "Initialized HolidayManager." `
                -or $LogMessage -match "Fake player readout: UUID = [0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}, name = \[Mekanism\]" `
                -or $LogMessage -match "Loading complete." `
                -or $LogMessage -match "Mod loaded." `
                -or $LogMessage -match "Loaded 'Mekanism: Additions' module."
                )
        }
        "" {
            return -not ($LogMessage -match "")
        }
    }
    return $true
}

$regEx = "\[(\d{2}\w{3}\d{4} \d{2}:\d{2}:\d{2}\.\d{3})\] \[([^/]*)\/([^\]]*)\] (?:\[STDERR\/\]: )?(?:\[STDOUT\/\]: )?\[([^/]*)\/?([^\]]*)?\]: (.*)"
# Capture Group Positions (Some may not be used but are available if needed and for additional documentation)
$cgTimestamp = 1
$cgThreadName = 2
$cgSeverity = 3
$cgModName = 4
$cgLogName = 5
$cgMessage = 6

$textStream = New-Object System.IO.StreamReader -Arg $LogFilePath
$currentModId = "forge"
$processedLineCount = 0
$writtenLineCount = 0
$startTime = Get-Date
while (-not ($textStream.EndOfStream)) {
    $line = $textStream.ReadLine()
    $processedLineCount++
    # Check for new section
    if ($line -match $regEx) {
        # New section - get mod name
        $currentModId = Get-ModId $Matches[$cgModName]
    }
    # Capture message before $Matches gets overwritten in Test-LogEntry
    $message = $Matches[$cgMessage]
    if (Test-LogEntry $currentModId $message) {
        $line | Out-File "$DestinationDirectory\$currentModId.log" -Encoding ascii -Append
        $writtenLineCount++
    }
}
$textStream.Close()
$endTime = Get-Date
$modIdMapping.GetEnumerator() | Select-Object -Property Key,Value | Export-Csv -Path "$DestinationDirectory\!modlist.log" -NoTypeInformation -Encoding ascii
$duration = New-TimeSpan -Start $startTime -End $endTime
"Processed {0:n0} lines and wrote {1:n0} lines in {2:g}" -f $processedLineCount, $writtenLineCount, $duration