function Get-SplitLogsDirectory {
    return "$PSScriptRoot\splitlogs"
}

function Get-CrafterDumperOutputPath {
    param ([Parameter(Mandatory=$true)][ValidateSet('LCMS','WFMS','GWMS')][string]$InstanceShortName)

    return "..\..\MultiMC\instances\$InstanceShortName\.minecraft\craftdumper"
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
    "com.mushroom.midnight.Midnight" = "midnight";
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
    "forgeendertech" = "forgeendertech";
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
    "mcwtrpdoors" = "mcwtrpdoors";
    "mcwwindows" = "mcwwindows";
    "Mekanism" = "mekanism";
    "Mekanism ChunkManager" = "mekanism";
    "Meson" = "strange";
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
    "Mystical Customization" = "mysticalcustomization";
    "net.blay09.mods.craftingtweaks.CraftingTweaks" = "craftingtweaks";
    "net.minecraft.advancements.AdvancementList" = "minecraft";
    "net.minecraft.advancements.AdvancementManager" = "minecraft";
    "net.minecraft.advancements.PlayerAdvancements" = "minecraft";
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
    "net.minecraft.server.integrated.IntegratedServer" = "minecraft";
    "net.minecraft.server.management.PlayerList" = "minecraft";
    "net.minecraft.server.MinecraftServer" = "minecraft";
    "net.minecraft.tags.TagCollection" = "minecraft";
    "net.minecraft.util.concurrent.ThreadTaskExecutor" = "minecraft"
    "net.minecraft.world.biome.Biome" = "minecraft";
    "net.minecraft.world.chunk.Chunk" = "minecraft";
    "net.minecraft.world.gen.feature.structure.Structures" = "minecraft";
    "net.minecraft.world.chunk.listener.LoggingChunkStatusListener" = "minecraft"
    "net.minecraft.world.storage.loot.LootTableManager" = "minecraft";
    "net.minecraft.world.storage.SaveFormat" = "minecraft";
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
    "net.minecraftforge.fml.FMLWorldPersistenceHook" = "forge";
    "net.minecraftforge.fml.loading.FixSSL" = "forge";
    "net.minecraftforge.fml.loading.FMLConfig" = "forge";
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
function Get-ModName {
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
function Convert-StringToLogEntry {
    param (
        [Parameter(Mandatory=$True)][string]$LogString
    )

    $regEx = "\[(\d{2}\w{3}\d{4} \d{2}:\d{2}:\d{2}\.\d{3})\] \[([^/]*)\/([^\]]*)\] (?:\[STDERR\/\]: )?(?:\[STDOUT\/\]: )?\[([^/]*)\/?([^\]]*)?\]: (.*)"

    if ($LogString -match $regEx) {
        return [PSCustomObject]@{
            TimeStamp = $Matches[1]
            ThreadName = $Matches[2]
            Severity = $Matches[3]
            ModName = Get-ModName $Matches[4]
            LogName = $Matches[5]
            Message = $Matches[6]
        }
    }
    else {
        #Write-Console "Log string could not be parsed." -ForegroundColor Red
        #Write-Console $LogString -ForegroundColor Red
        return $null
    }
}

function Get-ModIdMapping {
    return $modIdMapping
}