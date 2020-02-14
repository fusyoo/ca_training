-- The time after messages disappear.
msgTimeOut = 60

-- The time after spawned units despawn.
cleanupTime = 1800

-- The time after air units will disappear
airCleanup = 1200 

-- The time after tankers and awacs' will be respawned
utilityRespawnTimer = 7200

--        ZONES
-- easy: no air defense, ROE = HOLD

EasyLightZones =  { ZONE:New("E-SOFT-1"), ZONE:New("E-SOFT-2"), ZONE:New("E-SOFT-3"), ZONE:New("E-SOFT-4") }
EasyMediumZones = { ZONE:New("E-MEDIUM-1"), ZONE:New("E-MEDIUM-2"), ZONE:New("E-MEDIUM-3") }
EasyHeavyZones = { ZONE:New("E-HARD-1"), ZONE:New("E-HARD-2"), ZONE:New("E-HARD-3"), ZONE:New("E-HARD-4") }

-- medium: AAA defense, ROE = FAW

MediumZones = { ZONE:New("M-1"), ZONE:New("M-2"), ZONE:New("M-3"), ZONE:New("M-4") }

-- hard: IR SAM, AAA defenses, ROE: FAW

HardZones = { ZONE:New("H-1"), ZONE:New("H-2"), ZONE:New("H-3"), ZONE:New("H-4") }

-- ship zones

EasyShipZone = { ZONE:New("E-SHIP-1"), ZONE:New("E-SHIP-2") }

HardShipZone = { ZONE:New("H-SHIP-1"), ZONE:New("H-SHIP-2") } 

-- SAM zones

SAMZones = { ZONE:New("SAM-1"), ZONE:New("SAM-2") }

--        Warning zones

warningZone = ZONE:New("No Fly Zone")

--        GROUND TEMPLATES

-- Template containing 6xTruck
easyLightTemplate = SPAWN:New("Easy Light Template"):InitRandomizeZones(EasyLightZones):InitCleanUp(cleanupTime):InitRandomizePosition(true,250,50)
-- Template containing 6xIFV
easyMediumTemplate = SPAWN:New("Easy Medium Template"):InitRandomizeZones(EasyMediumZones):InitCleanUp(cleanupTime):InitRandomizePosition(true,250,50)
-- Template containing 6xT-72
easyHeavyTemplate = SPAWN:New("Easy Heavy Template"):InitRandomizeZones(EasyHeavyZones):InitCleanUp(cleanupTime):InitRandomizePosition(true,250,50)

-- Template containing 1xOutpost, 2xIFV, 1xT-72, 3xAAA
mediumTemplate = SPAWN:New("Medium Template"):InitRandomizeZones(MediumZones):InitCleanUp(cleanupTime):InitRandomizePosition(true,250,50)

-- Template containing 1xOutpost, 3xIFV, 1xT-72, 2xAAA, 2xIGLA
hardTemplate = SPAWN:New("Hard Template"):InitRandomizeZones(HardZones):InitCleanUp(cleanupTime):InitRandomizePosition(true,250,50)

--        AIR TEMPLATES

f86f = SPAWN:New("F-86F"):InitCleanUp(airCleanup)
f5e3 = SPAWN:New("F-5E-3"):InitCleanUp(airCleanup)
mig21bis = SPAWN:New("MiG-21Bis"):InitCleanUp(airCleanup)
f16c = SPAWN:New("F-16C"):InitCleanUp(airCleanup)
mig29s = SPAWN:New("MiG-29S"):InitCleanUp(airCleanup)
fa18c = SPAWN:New("F/A-18C"):InitCleanUp(airCleanup)
su33 = SPAWN:New("Su-33"):InitCleanUp(airCleanup)
tu95 = SPAWN:New("Tu-95"):InitCleanUp(airCleanup)
mig19p = SPAWN:New("MiG-19P"):InitCleanUp(airCleanup)

--        AIR UTILITY

redAwacs = SPAWN:New("Red AWACS"):InitCleanUp(utilityRespawnTimer)
blueAwacs = SPAWN:New("Blue AWACS"):InitCleanUp(utilityRespawnTimer)
blueTanker = SPAWN:New("Blue KC135"):InitCleanUp(utilityRespawnTimer)
blueTankerMPRS = SPAWN:New("Blue KC135 MPRS"):InitCleanUp(utilityRespawnTimer)

--        Ship Templates

easyShipTemplate = SPAWN:New("Easy Ship Template"):InitRandomizeZones(EasyShipZone):InitCleanUp(cleanupTime):InitRandomizePosition(true,500,200)

hardShipTemplate = SPAWN:New("Hard Ship Template"):InitRandomizeZones(HardShipZone):InitCleanUp(cleanupTime):InitRandomizePosition(true,500,200)

--        SAM Templates

samTemplate = SPAWN:New("SAM Template"):InitRandomizeZones(SAMZones):InitCleanUp(cleanupTime):InitRandomizePosition(true,300,100)

--        Convoy Templates

convoyTemplate = SPAWN:New("Convoy Template"):InitCleanUp(cleanupTime*2)

--        Checkpoint templates

cpNorth = SPAWN:New("CP North"):InitCleanUp(cleanupTime)
cpWest = SPAWN:New("CP West"):InitCleanUp(cleanupTime)

--        Airport defenses

gudautaDef = SPAWN:New("Gudauta Units"):InitCleanUp(cleanupTime)

sukhumiDef = SPAWN:New("Sukhumi Units"):InitCleanUp(cleanupTime)

---- spawner method
-- @param Core.Spawn#SPAWN template
-- @param Utilites.Utils#SMOKECOLOR smokeColor
-- 
function spawnTargets(template, smokeColor)
  local g = template:Spawn()
  if g ~= nil then
    local coords = g:GetCoordinate()
    
    if smokeColor ~= nil then 
      coords:Smoke(smokeColor)
    end
    
    g:MessageToAll("spawned at [".. coords:ToStringLLDMS():gsub("LL DMS,", "") .." ]", msgTimeOut, "")
  end
end

---- spawner method
-- @param Core.Spawn#SPAWN template
--
function spawnAirTargets(template)
  local g = template:Spawn()
  if g ~= nil then
    local coords = g:GetCoordinate()
    
    g:MessageToAll("spawned at ["..coords:ToStringLLDMS():gsub("LL DMS,", "").." ] " .. coords:GetAltitudeText(),msgTimeOut, "")
  end
end

---- awacs &  tanker scheduler
--
--

SCHEDULER:New(
  nil,
  function()
    blueT = blueTanker:ReSpawn()
    blueT2 = blueTankerMPRS:ReSpawn()
    rAw = redAwacs:ReSpawn()
    bAw = blueAwacs:ReSpawn()
  end, {}, 1, utilityRespawnTimer
):Start()

-- Ground target menus

spawnMenu = MENU_COALITION:New(coalition.side.BLUE,"Spawn")

groundSpawnMenu = MENU_COALITION:New(coalition.side.BLUE, "Ground Targets", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Easy: Light Targets",groundSpawnMenu,spawnTargets,easyLightTemplate, SMOKECOLOR.Green)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Easy: Medium Targets",groundSpawnMenu,spawnTargets,easyMediumTemplate, SMOKECOLOR.Green)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Easy: Heavy Targets",groundSpawnMenu,spawnTargets,easyHeavyTemplate, SMOKECOLOR.Green)

MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Medium: Mixed Targets",groundSpawnMenu,spawnTargets,mediumTemplate, SMOKECOLOR.Orange)

MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Hard: Mixed Targets",groundSpawnMenu,spawnTargets,hardTemplate, SMOKECOLOR.Red)

-- Air target menus

airSpawnMenu = MENU_COALITION:New(coalition.side.BLUE, "Air Targets", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"F-86F",airSpawnMenu,spawnAirTargets,f86f)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"F-5E-3",airSpawnMenu,spawnAirTargets,f5e3)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"MiG-19P",airSpawnMenu,spawnAirTargets,mig19p)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"MiG-21Bis",airSpawnMenu,spawnAirTargets,mig21bis)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"F-16C",airSpawnMenu,spawnAirTargets,f16c)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"MiG-29S",airSpawnMenu,spawnAirTargets,mig29s)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"F/A-18C",airSpawnMenu,spawnAirTargets,fa18c)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Su-33",airSpawnMenu,spawnAirTargets,su33)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Tu-95",airSpawnMenu,spawnAirTargets,tu95)

-- Ship target menus

shipSpawnMenu = MENU_COALITION:New(coalition.side.BLUE,"Ships", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Easy Target (cargo ships)",shipSpawnMenu,spawnTargets,easyShipTemplate,nil)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Hard Target (Neutrashimy)",shipSpawnMenu,spawnTargets,hardShipTemplate,nil)

-- SAM Target menus

samSpawnMenu = MENU_COALITION:New(coalition.side.BLUE,"SAM", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"S-300 (NATO: SA-10) Site",samSpawnMenu,spawnTargets,samTemplate,SMOKECOLOR.White)

-- Convoy Target Menus

convoySpawnMenu = MENU_COALITION:New(coalition.side.BLUE,"Convoy", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Mixed Convoy (w/ AAA)",convoySpawnMenu,spawnTargets,convoyTemplate,nil)

-- Checkpoint target menus

checkpointSpawnMenu = MENU_COALITION:New(coalition.side.BLUE,"Checkpoint", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"West Checkpoint",checkpointSpawnMenu,spawnTargets,cpWest,SMOKECOLOR.Blue)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"North Checkpoint",checkpointSpawnMenu,spawnTargets,cpNorth,SMOKECOLOR.Blue)

-- Airport defense menus
airportDefenseMenu = MENU_COALITION:New(coalition.side.BLUE,"Airbase Defenses", spawnMenu)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Gudauta Defenses",airportDefenseMenu,spawnTargets,gudautaDef,nil)
MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Sukhumi Defenses",airportDefenseMenu,spawnTargets,sukhumiDef,nil)








