function split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

function createPlayer(entry)
    -- Example creates Jerzy Dudek in Free Agents team
    local playerid = entry["playerid"]

    -- Make sure we won't create duplicate
    if PlayerExists(playerid) then
        Log(string.format("Player with ID: playerid %d already exists", playerid))
        return
    end
    assert(PlayerExists(playerid) == false, string.format("Can't create. Player with ID: playerid %d already exists", playerid))

    -- That will be inserted into players table
    -- Missing fields will be replaced with lowest possible value by default (except playerid)
    local player_data = {
        skintypecode = entry["skintypecode"],
        trait2 = entry["trait2"],
        haircolorcode = entry["haircolorcode"],
        facialhairtypecode = entry["facialhairtypecode"],
        curve = entry["curve"],
        jerseystylecode = entry["jerseystylecode"],
        agility = entry["agility"],
        tattooback = entry["tattooback"],
        accessorycode4 = entry["accessorycode4"],
        gksavetype = entry["gksavetype"],
        positioning = entry["positioning"],
        tattooleftarm = entry["tattooleftarm"],
        hairtypecode = entry["hairtypecode"],
        standingtackle = entry["standingtackle"],
        preferredposition3 = entry["preferredposition3"],
        longpassing = entry["longpassing"],
        penalties = entry["penalties"],
        animfreekickstartposcode = entry["animfreekickstartposcode"],
        isretiring = entry["isretiring"],
        longshots = entry["longshots"],
        gkdiving = entry["gkdiving"],
        interceptions = entry["interceptions"],
        shoecolorcode2 = entry["shoecolorcode2"],
        crossing = entry["crossing"],
        potential = entry["potential"],
        gkreflexes = entry["gkreflexes"],
        finishingcode1 = entry["finishingcode1"],
        reactions = entry["reactions"],
        composure = entry["composure"],
        vision = entry["vision"],
        contractvaliduntil = entry["contractvaliduntil"],
        finishing = entry["finishing"],
        dribbling = entry["dribbling"],
        slidingtackle = entry["slidingtackle"],
        accessorycode3 = entry["accessorycode3"],
        accessorycolourcode1 = entry["accessorycolourcode1"],
        headtypecode = entry["headtypecode"],
        driref = entry["driref"],
        sprintspeed = entry["sprintspeed"],
        height = entry["height"],
        hasseasonaljersey = entry["hasseasonaljersey"],
        tattoohead = entry["tattoohead"],
        preferredposition2 = entry["preferredposition2"],
        strength = entry["strength"],
        shoetypecode = entry["shoetypecode"],
        birthdate = "153928",
        preferredposition1 = entry["preferredposition1"],
        tattooleftleg = entry["tattooleftleg"],
        ballcontrol = entry["ballcontrol"],
        phypos = entry["phypos"],
        shotpower = entry["shotpower"],
        trait1 = entry["trait1"],
        socklengthcode = entry["socklengthcode"],
        weight = entry["weight"],
        hashighqualityhead = entry["hashighqualityhead"],
        gkglovetypecode = entry["gkglovetypecode"],
        tattoorightarm = entry["tattoorightarm"],
        balance = entry["balance"],
        gender = entry["gender"],
        headassetid = entry["headassetid"],
        gkkicking = entry["gkkicking"],
        defspe = entry["defspe"],
        internationalrep = entry["internationalrep"],
        shortpassing = entry["shortpassing"],
        freekickaccuracy = entry["freekickaccuracy"],
        skillmoves = entry["skillmoves"],
        faceposerpreset = entry["faceposerpreset"],
        usercaneditname = entry["usercaneditname"],
        avatarpomid = entry["avatarpomid"],
        attackingworkrate = entry["attackingworkrate"],
        finishingcode2 = entry["finishingcode2"],
        aggression = entry["aggression"],
        acceleration = entry["acceleration"],
        paskic = entry["paskic"],
        headingaccuracy = entry["headingaccuracy"],
        iscustomized = entry["iscustomized"],
        eyebrowcode = entry["eyebrowcode"],
        runningcode2 = entry["runningcode2"],
        modifier = entry["modifier"],
        gkhandling = entry["gkhandling"],
        eyecolorcode = entry["eyecolorcode"],
        jerseysleevelengthcode = entry["jerseysleevelengthcode"],
        accessorycolourcode3 = entry["accessorycolourcode3"],
        accessorycode1 = entry["accessorycode1"],
        playerjointeamdate = entry["playerjointeamdate"],
        headclasscode = entry["headclasscode"],
        defensiveworkrate = entry["defensiveworkrate"],
        defensiveawareness = entry["defensiveawareness"],
        tattoofront = entry["tattoofront"],
        nationality = entry["nationality"],
        preferredfoot = entry["preferredfoot"],
        sideburnscode = entry["sideburnscode"],
        weakfootabilitytypecode = entry["weakfootabilitytypecode"],
        jumping = entry["jumping"],
        personality = entry["personality"],
        gkkickstyle = entry["gkkickstyle"],
        stamina = entry["stamina"],
        marking = entry["marking"],
        accessorycolourcode4 = entry["accessorycolourcode4"],
        gkpositioning = entry["gkpositioning"],
        headvariation = entry["headvariation"],
        skillmoveslikelihood = entry["skillmoveslikelihood"],
        shohan = entry["shohan"],
        skintonecode = entry["skintonecode"],
        shortstyle = entry["shortstyle"],
        overallrating = entry["overallrating"],
        smallsidedshoetypecode = entry["smallsidedshoetypecode"],
        emotion = entry["emotion"],
        runstylecode = entry["runstylecode"],
        jerseyfit = entry["jerseyfit"],
        accessorycode2 = entry["accessorycode2"],
        shoedesigncode = entry["shoedesigncode"],
        shoecolorcode1 = entry["shoecolorcode1"],
        hairstylecode = entry["hairstylecode"],
        bodytypecode = entry["bodytypecode"],
        animpenaltiesstartposcode = entry["animpenaltiesstartposcode"],
        pacdiv = entry["pacdiv"],
        runningcode1 = entry["runningcode1"],
        preferredposition4 = entry["preferredposition4"],
        volleys = entry["volleys"],
        accessorycolourcode2 = entry["accessorycolourcode2"],
        tattoorightleg = entry["tattoorightleg"],
        facialhaircolorcode = entry["facialhaircolorcode"]
    }

    local created_playerid = CreatePlayer(playerid, player_data)

    -- Create the name
    local editedplayernames_row_data = {
        playerid = string.format("%d", created_playerid),
        firstname = entry["firstname"],
        lastname = entry["lastname"],
        surname = entry["lastname"],
        commonname = entry["commonname"],
        playerjerseyname = entry["playerjerseyname"]
    }

    local row = InsertDBTableRow("editedplayernames", editedplayernames_row_data)

    Log(string.format("Created Player - %s %s (ID: %s). Check Free Agents.", editedplayernames_row_data.firstname, editedplayernames_row_data.surname, editedplayernames_row_data.playerid))
end

function readCSV(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Failed to open file: " .. filename)
    end

    local header = file:read()
    local headerArr = split(header, ",")
    print("length of headerArr: " .. #headerArr)

    local data = {}

    for line in file:lines() do
        line = line:gsub("\n", ""):gsub("\r", "")
        print("line: " .. line)
        local valuesArr = split(line, ",")
        print("length of valuesArr: " .. #valuesArr)

        local entry = {}

        for i = 1, #valuesArr do
            -- print("headerArr[" .. i .. "]:" .. headerArr[i])
            -- print("valuesArr[" .. i .. "]:" .. valuesArr[i])
            -- print("headerArr[" .. i .. "] key = '" .. headerArr[i] .. "' , value = " .. valuesArr[i])
            -- print(string.format("headerArr[%d] key = '%s' , value = '%s'", i, headerArr[i], valuesArr[i]))
            entry[headerArr[i]] = valuesArr[i]
        end

        print(">>> createPlayer")
        createPlayer(entry)
    end

    file:close()

    return data
end

-- Usage example
local filename = "C:/Users/Veeja.Liu/Downloads/FC_24_LE_ICONS.csv"
local data = readCSV(filename)
