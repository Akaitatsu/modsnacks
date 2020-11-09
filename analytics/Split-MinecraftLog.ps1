param (
    [Parameter(Mandatory=$True)][string]$LogFilePath,
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
    "AE2:S" = "appliedenergistics2";
    "ambientsounds" = "ambientsounds";
    "Apotheosis : Enchantment" = "apotheosis";
    "Apotheosis : Deadly" = "apotheosis";
    "Astral Sorcery" = "astralsorcery";
    "attained_drops" = "attained_drops";
    "bettercaves" = "bettercaves";
    "biomesoplenty" = "biomesoplenty";
    "BonsaiTrees2" = "bonsaitrees";
    "Bookshelf" = "bookshelf";
    "Botany Pots" = "botanypots";
    "charm" = "charm";
    "codechicken.lib.config.ConfigSyncManager" = "codechickenlib";
    "com.black_dog20.servertabinfo.ServerTabInfo" = "servertabinfo";
    "com.darkere.serverconfigupdater.ServerConfigUpdater" = "serverconfigupdater";
    "com.jaquadro.minecraft.storagedrawers.StorageDrawers" = "storagedrawers";
    "com.maciej916.maessentials.common.util.LogUtils" = "maessentials";
    "com.mojang.text2speech.NarratorWindows" = "minecraft";
    "com.oitsjustjose.vtweaks.VTweaks" = "vtweaks";
    "com.performant.coremod.Performant" = "performant";
    "com.polyvalord.extlights.Extlights" = "extlights";
    "com.refinedmods.refinedstorage.apiimpl.API" = "refinedstorage";
    "com.stal111.forbidden_arcanus.gui.forbiddenmicon.ForbiddenmiconPageLoadListener" = "forbidden_arcanus";
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
    "FTB Utilities Backups" = "ftbbackups";
    "immersiveengineering" = "immersiveengineering";
    "incontrol" = "incontrol";
    "inspirations" = "inspirations";
    "inventoryhud" = "inventoryhud";
    "JarSignVerifier" = "misc";
    "jeresources" = "jeresources";
    "Kiwi" = "kiwi";
    "KubeJS" = "kubejs";
    "KubeJS Server" = "kubejs";
    "KubeJS Startup" = "kubejs";
    "lostcities" = "lostcities";
    "mcjtylib" = "mcjtylib";
    "mcjty.theoneprobe.TheOneProbe" = "theoneprobe";
    "mcwbridges" = "mcwbridges";
    "mcwdoors" = "mcwdoors";
    "mcwfurnitures" = "mcwfurnitures";
    "mcwwindows" = "mcwwindows";
    "Mekanism" = "mekanism";
    "Mekanism ChunkManager" = "mekanism";
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
    "net.minecraft.advancements.AdvancementManager" = "minecraft";
    "net.minecraft.client.audio.SoundEngine" = "minecraft";
    "net.minecraft.client.audio.SoundHandler" = "minecraft";
    "net.minecraft.client.audio.SoundSystem" = "minecraft";
    "net.minecraft.client.gui.NewChatGui" = "minecraft";
    "net.minecraft.client.gui.screen.ConnectingScreen" = "minecraft";
    "net.minecraft.client.Minecraft" = "minecraft";
    "net.minecraft.client.network.play.ClientPlayNetHandler" = "minecraft";
    "net.minecraft.client.renderer.model.ModelBakery" = "minecraft";
    "net.minecraft.client.renderer.texture.AtlasTexture" = "minecraft";
    "net.minecraft.client.resources.JsonReloadListener" = "minecraft";
    "net.minecraft.command.arguments.ArgumentTypes" = "minecraft";
    "net.minecraft.command.Commands" = "minecraft";
    "net.minecraft.entity.EntityType" = "minecraft";
    "net.minecraft.network.datasync.EntityDataManager" = "minecraft";
    "net.minecraft.network.login.ServerLoginNetHandler" = "minecraft";
    "net.minecraft.network.NetworkSystem" = "minecraft";
    "net.minecraft.network.play.ServerPlayNetHandler" = "minecraft";
    "net.minecraft.resources.ResourcePackInfo" = "minecraft"
    "net.minecraft.resources.SimpleReloadableResourceManager" = "minecraft";
    "net.minecraft.world.server.ChunkManager" = "minecraft";
    "net.minecraft.server.dedicated.DedicatedServer" = "minecraft";
    "net.minecraft.server.management.PlayerList" = "minecraft";
    "net.minecraft.server.MinecraftServer" = "minecraft";
    "net.minecraft.tags.TagCollection" = "minecraft";
    "net.minecraft.util.concurrent.ThreadTaskExecutor" = "minecraft"
    "net.minecraft.world.biome.Biome" = "minecraft";
    "net.minecraft.world.chunk.Chunk" = "minecraft";
    "net.minecraft.world.gen.feature.structure.Structures" = "minecraft";
    "net.minecraft.world.chunk.listener.LoggingChunkStatusListener" = "minecraft"
    "net.minecraft.world.storage.loot.LootTableManager" = "minecraft";
    "net.minecraftforge.common.AdvancementLoadFix" = "forge";
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
    "net.minecraftforge.fml.loading.RuntimeDistCleaner" = "forge";
    "net.minecraftforge.fml.network.FMLHandshakeHandler" = "forge";
    "net.minecraftforge.fml.network.NetworkHooks" = "forge";
    "net.minecraftforge.fml.server.ServerLifecycleHooks" = "forge";
    "net.minecraftforge.fml.VersionChecker" = "forge";
    "net.minecraftforge.registries.ForgeRegistry" = "forge";
    "net.minecraftforge.registries.GameData" = "forge";
    "net.silentchaos512.utils.config.ConfigSpecWrapper" = "silentlib";
    "Obfuscate" = "obfuscate";
    "occultism" = "occultism";
    "Open Loader" = "openloader";
    "paintings" = "paintings";
    "pam.pamhc2crops.Pamhc2crops" = "harvestcraft";
    "patchouli" = "patchouli";
    "placebo" = "placebo";
    "PluginManager" = "misc";
    "powah" = "powah";
    "projecte" = "projecte";
    "psi" = "psi";
    "quark" = "quark";
    "ReAuth" = "reath";
    "se.mickelus.tetra.client.model.ModularModelLoader" = "tetra";
    "se.mickelus.tetra.data.DataStore" = "tetra";
    "se.mickelus.tetra.data.DataManager" = "tetra";
    "se.mickelus.tetra.data.MergingDataStore" = "tetra";
    "Silent Gear" = "silentgear";
    "Silent's Gems" = "silentgems";
    "strange" = "strange";
    "structurize" = "structurize";
    "tellme" = "tellme";
    "TerraForged" = "terraforged";
    "thelm.jaopca.compat.create.recipes.PressingRecipeSupplier" = "jaopca";
    "thelm.jaopca.data.DataCollector" = "jaopca";
    "thelm.jaopca.data.DataInjector" = "jaopca";
    "thelm.jaopca.localization.LocalizationRepoHandler" = "jaopca";
    "thelm.jaopca.materials.MaterialHandler" = "jaopca";
    "thelm.jaopca.modules.ModuleHandler" = "jaopca";
    "tombstone" = "tombstone";
    "toastcontrol" = "toastcontrol";
    "tv.mapper.embellishcraft.EmbellishCraft" = "embellishcraft";
    "tv.mapper.embellishcraftbop.EmbellishCraftBOP" = "embellishcraftbop";
    "tv.mapper.mapperbase.MapperBase" = "mapperbase";
    "tv.mapper.roadstuff.RoadStuff" = "roadstuff";
    "Waterworks" = "waterworks";
    "wile.engineersdecor.ModEngineersDecor" = "engineersdecor";
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
    if ($ModName.StartsWith("org.antlr.v4.runtime.") `
        -or $ModName.StartsWith("java.lang.ThreadGroup:uncaughtException")
        ) {
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
            return -not ($LogMessage -match "Endimation Data Manager has Loaded \d+ Endimations")
        }
        "ambientsounds" {
            return -not ($LogMessage -match "Successfully loaded sound engine\. \d+ dimension\(s\) and \d+ region\(s\)")
        }
        "apotheosis" {
            return -not (
                $LogMessage -match "Loaded \d+ affix loot entries from resources\." `
                -or $LogMessage -match "Registered \d+ (?:(boss gear sets)|(?:blocks with enchanting stats))\."
                )
        }
        "appliedenergistics2" {
            return -not ($LogMessage -match "Post Initialization\.*")
        }
        "astralsorcery" {
            return -not (
                $LogMessage -match "Built PerkTree with \d+ perks!" `
                -or $LogMessage -match "Client cache cleared!" `
                -or $LogMessage -match "Patreon effect loading finished\." `
                -or $LogMessage -match "Skipped \d+ patreon effects during loading due to malformed data!" `
                -or $LogMessage -match "\[AssetLibrary\] Refreshing and Invalidating Resources" `
                -or $LogMessage -match "\[AssetLibrary\] Successfully reloaded library\." `
                -or $LogMessage -match "Loaded PerkTree!"
                )
        }
        "attained_drops" {
            return -not ($LogMessage -match "Loaded config file!")
        }
        "bettercaves" {
            return -not ($LogMessage -match "Replacing biome carvers with Better Caves carvers\.\.\.")
        }
        "biomesoplenty" {
            return -not ($LogMessage -match "Registering BoP commands\.\.\.")
        }
        "bonsaitrees" {
            return -not (
                $LogMessage -match "Found \d+ tree models\." `
                -or $LogMessage -match "Registering \d+ saplings" `
                -or $LogMessage -match "Updated soil compatibility" `
                -or $LogMessage -match "Loaded \d+ bonsai types and \d+ soil types"
                )
        }
        "bookshelf" {
            return -not ($LogMessage -match "Registering \d+.+\.")
        }
        "botanypots" {
            return -not ($LogMessage -match "Registering \d+.+\.")
        }
        "bountiful" {
            return -not (
                $LogMessage -match "Loading Bountiful listeners\.\." `
                -or $LogMessage -match "Registering to: minecraft:(?:(?:block)|(?:item)), class net\.minecraft\.(?:(?:block)|(?:item))\.(?:(?:Block)|(?:Item))" `
                -or $LogMessage -match "Bountiful (?:(?:listening for resource reloads\.\.)|(?:reloading resources! :D))" `
                -or $LogMessage -match "Loading BR\{bountiful\/(?:(?:decrees\/bountiful)|(?:pools\/[\w]+))\}"
                )
        }
        "charm" {
            return -not ($LogMessage -match "(?:(?:Creating config for)|(?:Loading)) module.+")
        }
        "codechickenlib" {
            return -not ($LogMessage -match "Skipping config sync, No mods have registered a syncable config\.")
        }
        "covalent" {
            return -not ($LogMessage -match "(?:(?:Creating config for)|(?:Loading)) module.+")
        }
        "craftingtweaks" {
            return -not ($LogMessage -match "\w+ has registered [\w\.]+ for CraftingTweaks")
        }
        "cucumber" {
            return -not ($LogMessage -match "Loaded cucumber-tags.json in \d+ ms")
        }
        "darkpaintings" {
            return -not ($LogMessage -match "Registering \d+ paintings.")
        }
        "darkutils" {
            return -not ($LogMessage -match "Registering \d+.+\.")
        }
        "doubleslabs" {
            return -not ($LogMessage -match "Loaded \d+ [\w ]+ support classes")
        }
        "druidcraft" {
            return -not (
                $LogMessage -match "\w+ Config: [\w\:\\\.]+druidcraft-(?:(?:server)|(?:client)).toml" `
                -or $LogMessage -match "[\w ]+ registered\." `
                -or $LogMessage -match "Textures stitched\." `
                -or $LogMessage -match "HELLO from server starting"
                )
        }
        "embellishcraft" {
            return -not (
                $LogMessage -match "1\.\d- EmbellishCraft: (?:(?:block)|(?:TE)) (?:(?:registering)|(?:listing))\." `
                -or $LogMessage -match "EmbellishCraft: (?:(?:setup started)|(?:BoP addon detected))\." `
                -or $LogMessage -match "\w+ blacklisted for biome minecraft:(?:(?:nether)|(?:the_end)) in the config\." `
                -or $LogMessage -match "EmbellishCraft: if this line crashes please report to.+"
                )
        }
        "embellishcraftbop" {
            return -not ($LogMessage -match "(?:2\.\d- )*Embellish[Cc]raft-B[Oo]P: (?:(?:block registering)|(?:block listing)|(?:setup started))\.*")
        }
        "engineersdecor" {
            return -not (
                $LogMessage -match "Engineer's Decor GIT id #[0-9a-f]+." `
                -or $LogMessage -match "[\w ]+ also installed \.\.\." `
                -or $LogMessage -match "Registered \d+ .+" `
                -or $LogMessage -match "Config .+" `
                -or $LogMessage -match "Opt-outs:\w+" `
                -or $LogMessage -match "Registering recipe condition processor \.\.\." `
                -or $LogMessage -match "Applying loaded config file\."
                )
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
        "forbidden_arcanus" {
            return -not ($LogMessage -match "Loaded \d+ recipes")
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
        "ftbbackups" {
            return -not (
                $LogMessage -match "Backups folder - [\w:\\\.]+backups" `
                -or $LogMessage -match "[\w ]+ also installed \.\.\." `
                -or $LogMessage -match "ftbbackups.lang.start" `
                -or $LogMessage -match "(?:(?:Backing up)|(?:Compressing)) \d+ files\.\.\." `
                -or $LogMessage -match "Done compressing in \d{2}:\d{2} seconds \(\d+.\dMB\)!" `
                -or $LogMessage -match "Created [\w:\\\.\d\-]+zip from [\w:\\\.]+"
                )
        }
        "immersiveengineering" {
            return -not (
                $LogMessage -match "Attempting to download [\w ]+ from GitHub" `
                -or $LogMessage -match "Stitching \w+ Textures!" `
                -or $LogMessage -match "Finished recipe profiler for [\w ]+, took \d+ milliseconds" `
                -or $LogMessage -match "Adding recipes to JEI!!" `
                -or $LogMessage -match "Recipes for potions:(?: \w+:\w+,?)+"
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
                -or $LogMessage -match "[\w ]+localization file for language en_us[\w :]*" `
                -or $LogMessage -match "Injected \d+ recipes, \d+ recipes total"
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
                $LogMessage -match "Loaded kubejs/client.properties"
                )
        }
        "lostcities" {
            return -not ($LogMessage -match "(?:(?:Creating standard)|(?:Reading existing)) profiles (?:(?:into)|(?:from)) 'config/lostcity_profiles'")
        }
        "maessentials" {
            return -not (
                $LogMessage -match "maessentials Setup (?:(?:main)|(?:world))" `
                -or $LogMessage -match "maessentials (?:(?:Mod is running on server)|(?:Loading data)|(?:Data loaded))"
                )
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
                -or $LogMessage -match "Version \d+.\d+.\d+ initializing\.\.\." `
                -or $LogMessage -match "Initialized HolidayManager\." `
                -or $LogMessage -match "Fake player readout: UUID = [0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}, name = \[Mekanism\]" `
                -or $LogMessage -match "Loading complete\." `
                -or $LogMessage -match "Mod loaded\." `
                -or $LogMessage -match "Loaded 'Mekanism: Additions' module\." `
                -or $LogMessage -match "Loading \d+ chunks for dimension \w+:\w+"
                )
        }
        "mgui" {
            return -not ($LogMessage -match "(?:(?:constructing mod)|(?:setup event))")
        }
        "minecolonies" {
            return -not (
                $LogMessage -match "FMLLoadCompleteEvent" `
                -or $LogMessage -match "Updated logging config. RS Debug logging enabled: false" `
                -or $LogMessage -match "Register mappings" `
                -or $LogMessage -match "Finished discovering [\w ]+" `
                -or $LogMessage -match "Removed all colony views" `
                -or $LogMessage -match "Finished initiating sifter config" `
                -or $LogMessage -match "Server UUID [0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}"
                )
        }
        "minecraft" {
            return -not (
                $LogMessage -match "Setting user: \w+" `
                -or $LogMessage -match "Backend library: LWJGL version [\d.]+ build \d+" `
                -or $LogMessage -match "No data fixer registered for entity[\w :]+" `
                -or $LogMessage -match "Narrator library for x64 successfully loaded" `
                -or $LogMessage -match "Reloading ResourceManager: Default, Mod Resources, KubeJS Resource Pack" `
                -or $LogMessage -match "Performant loaded, lag begone!" `
                -or $LogMessage -match "OpenAL initialized\." `
                -or $LogMessage -match "Sound engine started" `
                -or $LogMessage -match "Created: (?:(?:256x128x0)|(?:4096x4096x3)|(?:256x256x3)|(?:512x512x3)|(?:1024x1024x3)|(?:512x256x3)|(?:512x512x0)) \w+:textures/atlas/\w+.png-atlas" `
                -or $LogMessage -match "Connecting to \d+.\d+.\d+.\d+, \d+" `
                -or $LogMessage -match "Reloading ResourceManager:.+" `
                -or $LogMessage -match "Loaded \d+ advancements" `
                -or $LogMessage -match "\[CHAT\].*" `
                -or $LogMessage -match "Stopping!" `
                -or $LogMessage -match "Starting minecraft server version 1\.\d{2}\.\d" `
                -or $LogMessage -match "Loading properties" `
                -or $LogMessage -match "Default game type: SURVIVAL" `
                -or $LogMessage -match "Generating keypair" `
                -or $LogMessage -match "Starting Minecraft server on \d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:\d{1,5}" `
                -or $LogMessage -match "Using default channel type" `
                -or $LogMessage -match "Preparing level ""[\w ]+""" `
                -or $LogMessage -match "Preparing start region for dimension minecraft:\w+" `
                -or $LogMessage -match "Preparing spawn area: \d{1,3}%" `
                -or $LogMessage -match "Time elapsed: \d+ ms" `
                -or $LogMessage -match "Done (\d+\.\d+s)! For help, type ""help""" `
                -or $LogMessage -match "ThreadedAnvilChunkStorage \([\w\d\-]+\): All chunks are saved" `
                -or $LogMessage -match "UUID of player [\w\d]+ is [0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}" `
                -or $LogMessage -match "[\w\d]+\[\/\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:\d{1,5}\] logged in with entity id \d+ at \(\d+.\d+, \d+.\d+, \-?\d+.\d+\)" `
                -or $LogMessage -match "[\w\d]+ (?:(?:joined)|(?:left)) the game" `
                -or $LogMessage -match "[\w\d]+ lost connection: Disconnected" `
                -or $LogMessage -match "Stopping (?:the )?server" `
                -or $LogMessage -match "Saving (?:(?:players)|(?:worlds)|(?:chunks for level '[\w ]+'/minecraft:\w+))" `
                -or $LogMessage -match "ftbbackups.lang.end_2"
                )
        }
        "misc" {
            return -not (
                $LogMessage -match "ModLauncher running:.+" `
                -or $LogMessage -match "ModLauncher [\d.\+]+master.[0-9a-f]+ starting:.+" `
                -or $LogMessage -match "Launching target '(?:(?:fmlclient)|(?:fmlserver))' with arguments.+" `
                -or $LogMessage -match "Scanning classes for \w+" `
                -or $LogMessage -match "Found FeaturePluginInstance for class \w+ for plugin resources" `
                -or $LogMessage -match "Mod \w+ is signed with a valid certificate\." `
                -or $LogMessage -match "Added \w+ to Meson" `
                -or $LogMessage -match "Queueing \w+:\w+" `
                -or $LogMessage -match "Constructed class \w+ for plugin resources for mod \w+" `
                -or $LogMessage -match "Executing phase CONSTRUCTION for plugin class \w+" `
                -or $LogMessage -match "Registering to minecraft:\w+ - \w+:\w+"
                )
        }
        "mixinbootstrap" {
            return -not (
                $LogMessage -match "SpongePowered MIXIN Subsystem Version=\d+\.\d+\.\d+" `
                -or $LogMessage -match "Successfully loaded Mixin Connector \[[\w\.]+\]"
                )
        }
        "mousetweaks" {
            return -not (
                $LogMessage -match "\[Mouse Tweaks\] Main.initialize\(\)" `
                -or $LogMessage -match "\[Mouse Tweaks\] Reflecting GuiContainer\.\.\." `
                -or $LogMessage -match "\[Mouse Tweaks\] Detected obfuscation: FORGE\." `
                -or $LogMessage -match "\[Mouse Tweaks\] Success\." `
                -or $LogMessage -match "\[Mouse Tweaks\] Initialized\."`
                -or $LogMessage -match "\[Mouse Tweaks\] Disabled because not running on the client\."
                )
        }
        "mysticalagriculture" {
            return -not (
                $LogMessage -match "Registered plugin: [\w\.]+" `
                -or $LogMessage -match "Model replacement took \d+ ms"
                )
        }
        "obfuscate" {
            return -not (
                $LogMessage -match "Starting to patch player models\.\.\." `
                -or $LogMessage -match "Patched (?:(?:default)|(?:slim)) model successfully"
                )
        }
        "occultism" {
            return -not (
                $LogMessage -match "Registered [\w ]+" `
                -or $LogMessage -match "(?:(?:Block)|(?:Item)) color registration complete\." `
                -or $LogMessage -match "(?:(?:Common)|(?:Client)|(?:Dedicated server)) setup complete."
                )
        }
        "paintings" {
            return -not (
                $LogMessage -match "loading json file and contents for paintings\." `
                -or $LogMessage -match "Loaded json painting \w+ , \d+ x \d+" `
                -or $LogMessage -match "registered painting net.minecraft.entity.item.PaintingType@[0-9a-f]+" `
                -or $LogMessage -match "Registering Resource Reloading"
                )
        }
        "performant" {
            return -not (
                $LogMessage -match "Performant configs loaded" `
                -or $LogMessage -match "Not enabling mixin [\w\.]+ as config disables it\."
                )
        }
        "placebo" {
            return -not (
                $LogMessage -match "Registered \d+ additional (?:(?:recipes)|(?:loot tables))\." `
                -or $LogMessage -match "Beginning replacement of all shapeless recipes\.\.\." `
                -or $LogMessage -match "Successfully replaced \d+ recipes with fast recipes\."
                )
        }
        "powah" {
            return -not (
                $LogMessage -match "Added coolant fluid: \w+:\w+, with coldness of: \d+ per mb" `
                -or $LogMessage -match "Added block: \w+:\w+, with heat of: \d+" `
                -or $LogMessage -match "Added fluid: \w+:\w+, with heat of: \d+ per \d+ mb"
                )
        }
        "projecte" {
            return -not (
                $LogMessage -match "Found and loaded (?:(?:EMC mapper)|(?:RecipeType Mapper)|(?:NBT Processor)): \w+, with priority [\d\-]+" `
                -or $LogMessage -match "Receiving EMC data from server\." `
                -or $LogMessage -match "Considering file projecte:pe_custom_conversions\/(?:(?:defaults)|(?:metals))\.json, ID projecte:(?:(?:defaults)|(?:metals))" `
                -or $LogMessage -match "Registered \d+ EMC values\. \(took \d+ ms\)"
                )
        }
        "psi" {
            return -not ($LogMessage -match "Initializing Psi shaders!")
        }
        "quark" {
            return -not ($LogMessage -match "Loading Module [\w ]+")
        }
        "refinedstorage" {
            return -not (
                $LogMessage -match "Found \d+ RS API injection point" `
                -or $LogMessage -match "Injected RS API in com.refinedmods.refinedstorageaddons.RSAddons RSAPI"
                )
        }
        "roadstuff" {
            return -not ($LogMessage -match "RoadStuff setup started!")
        }
        "serverconfigupdater" {
            return -not ($LogMessage -match "Attempting to delete \d+ files/folders defined in config")
        }
        "servertabinfo" {
            return -not ($LogMessage -match "Pre Initialization Complete!")
        }
        "silentgear" {
            return -not (
                $LogMessage -match "Registered (?:condition )?serializer '\w+:\w+'" `
                -or $LogMessage -match "IAOETool: Rebuilt ore block set, contains \d+ items" `
                -or $LogMessage -match "Add [\w ]+ to \w+:\w+" `
                -or $LogMessage -match "Read \d+ (?:(?:traits)|(?:parts)|(?:materials)) from server"
                )
        }
        "silentgems" {
            return -not (
                $LogMessage -match "Detected Silent Gear!" `
                -or $LogMessage -match "Register part type PartType{name='\w+:\w+'}" `
                -or $LogMessage -match "ColorHandlers#on(?:(?:Block)|(?:Item))Colors: net.minecraft.client.renderer.color.(?:(?:Block)|(?:Item))Colors@[0-9a-f]+" `
                -or $LogMessage -match "Your base biome seed is [\d\-]+" `
                -or $LogMessage -match "(?:(?:RUBY)|(?:GARNET)|(?:TOPAZ)|(?:AMBER)|(?:HELIODOR)|(?:PERIDOT)|(?:GREEN_SAPPHIRE)|(?:PHOSPHOPHYLLITE)|(?:AQUAMARINE)|(?:SAPPHIRE)|(?:TANZANITE)|(?:AMETHYST)|(?:AGATE)|(?:MORGANITE)|(?:ONYX)|(?:OPAL)):(?: \w+:\w+,?)+" `
                -or $LogMessage -match "Received \d+ (?:(?:soul info objects)|(?:chaos buffs)) from server" `
                -or $LogMessage -match "Add (?:(?:gems)|(?:'rare' items)) to loot table minecraft:chests\/\w+(?: \(\d+ rolls\))?"
                )
        }
        "silentlib" {
            return -not ($LogMessage -match "Loading config file [\w:\\.]+(?:(?:silentgems-common)|(?:equipment-tooltips-client))\.toml")
        }
        "storagedrawers" {
            return -not ($LogMessage -match "New compacting rule \d+ \w+ = \d+ \w+")
        }
        "strange" {
            return -not (
                $LogMessage -match "Creating config for module \w+" `
                -or $LogMessage -match "Loading module \w+"
                )
        }
        "structurize" {
            return -not (
                $LogMessage -match "Optifine not found\. Disabling compat\." `
                -or $LogMessage -match "(?:file:)?[\w:\/\.]+mods\/(?:(?:minecolonies)|(?:structurize))-\d+\.\d+\.\d+\-RELEASE(?:-universal)?.jar" `
                -or $LogMessage -match "\/assets\/(?:(?:minecolonies)|(?:structurize))" `
                -or $LogMessage -match "Load huts or decorations from jar" `
                -or $LogMessage -match "Load (?:(?:additional huts or decorations)|(?:cached schematic)) from [\w:\\\.]+(?:(?:structurize)|(?:minecolonies))\\[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\/(?:(?:schematics)|(?:cache))"
                )
        }
        "tellme" {
            return -not ($LogMessage -match "Reloading the configs from file '[\w\\\.:]+config\\tellme.toml'")
        }
        "terraforged" {
            return -not (
                $LogMessage -match "Register(?:(?:ing)|(?:ed)) (?:(?:decorators)|(?:features)|(?:world type))" `
                -or $LogMessage -match "Common setup" `
                -or $LogMessage -match "Loading config: performance.conf" `
                -or $LogMessage -match "Performance Settings \[default=false\]" `
                -or $LogMessage -match " - [\w ]+: (?:(?:\d+)|(?:false))"`
                -or $LogMessage -match "Tags Reloaded"
                )
        }
        "tetra" {
            return -not (
                $LogMessage -match "Loaded[ ]{1,3}\d+ (?:(?:tweaks)|(?:improvements)|(?:modules)|(?:enchantments)|(?:synergies)|(?:replacements)|(?:schemas)|(?:repairs)|(?:predicatus)|(?:actions)|(?:destabilization)|(?:structures))" `
                -or $LogMessage -match "Clearing item model cache, let's get bakin'" `
                -or $LogMessage -match "Loaded 259 schemas"
                )
        }
        "tombstone" {
            return -not ($LogMessage -match "Integration TOP")
        }
        "torchslabsmod" {
            return -not ($LogMessage -match "[\w ]+ Mod DETECTED AND LOADED TORCHSLAB COMPAT")
        }
        "vtweaks" {
            return -not ($LogMessage -match "V-Tweaks capability attached for minecraft:overworld")
        }
        "waterworks" {
            return -not (
                $LogMessage -match "Waterworks (?:Client )?Setup (?:(?:starting)|(?:complete))" `
                -or $LogMessage -match "Waterworks IMC to other mods (?:(?:starting)|(?:complete))" `
                -or $LogMessage -match "Enabled support for The One Probe"
                )
        }
        "xaero" {
            return -not (
                $LogMessage -match "Loading Xaero's (?:(?:World Map)|(?:Minimap)) - Stage [12]/2" `
                -or $LogMessage -match "Waterworks IMC to other mods (?:(?:starting)|(?:complete))" `
                -or $LogMessage -match "Xaero's (?:(?:WorldMap Mod)|(?:Minimap)): (?:(?:World Map)|(?:Xaero's minimap)) found!" `
                -or $LogMessage -match "No Optifine!" `
                -or $LogMessage -match "New (?:(?:world map)|(?:minimap)) session initialized!" `
                -or $LogMessage -match "Minimap updated server level id: [\d\-]+ for world \d+" `
                -or $LogMessage -match "(?:(?:World map)|(?:Minimap)) session finalized\." `
                -or $LogMessage -match "World map cleaned normally!"
                )
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