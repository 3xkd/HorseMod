AnimalPartsDefinitions = AnimalPartsDefinitions or {}
AnimalPartsDefinitions.animals = AnimalPartsDefinitions.animals or {}

-----------------------
----- ALL FILLIES -----
-----------------------
local fillyparts = {};
local fillybones = {};
local fillyxp = 10;

table.insert(fillyparts, {item = "Base.Steak", minNb = 10, maxNb = 18})
table.insert(fillyparts, {item = "Base.Beef", minNb = 10, maxNb = 18})
table.insert(fillyparts, {item = "Base.AnimalSinew", minNb = 3, maxNb = 7})

table.insert(fillybones, {item = "Base.AnimalBone", minNb = 10, maxNb = 18})

-----------------------
----- ALL HORSES ------
-----------------------
local horseparts = {};
local horsebones = {};
local horsexp = 15;

table.insert(horseparts, {item = "Base.Steak", minNb = 10, maxNb = 18})
table.insert(horseparts, {item = "Base.Beef", minNb = 10, maxNb = 18})
table.insert(horseparts, {item = "Base.AnimalSinew", minNb = 3, maxNb = 7})

table.insert(horsebones, {item = "Base.LargeAnimalBone", minNb = 10, maxNb = 18})


-----------------------------
----- AMERICAN QUARTER ------
-----------------------------

---- FILLY
local fillyamerican_quarter = AnimalPartsDefinitions.animals["fillyamerican_quarter"] or {};
fillyamerican_quarter.parts = fillyamerican_quarter.parts or horseparts;
fillyamerican_quarter.bones = fillyamerican_quarter.bones or fillybones;
fillyamerican_quarter.head = "HorseMod.Horse_Head";
fillyamerican_quarter.skull = "HorseMod.Horse_Skull";
fillyamerican_quarter.xpPerItem = fillyamerican_quarter.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyamerican_quarter"] = fillyamerican_quarter

---- MARE
local mareamerican_quarter = AnimalPartsDefinitions.animals["mareamerican_quarter"] or {};
mareamerican_quarter.parts = mareamerican_quarter.parts or horseparts;
mareamerican_quarter.bones = mareamerican_quarter.bones or horsebones;
mareamerican_quarter.head = "HorseMod.Horse_Head";
mareamerican_quarter.skull = "HorseMod.Horse_Skull";
mareamerican_quarter.xpPerItem = mareamerican_quarter.xpPerItem or horsexp
AnimalPartsDefinitions.animals["mareamerican_quarter"] = mareamerican_quarter

---- STALLION
local stallionamerican_quarter = AnimalPartsDefinitions.animals["stallionamerican_quarter"] or {};
stallionamerican_quarter.parts = stallionamerican_quarter.parts or horseparts;
stallionamerican_quarter.bones = stallionamerican_quarter.bones or horsebones;
stallionamerican_quarter.head = "HorseMod.Horse_Head";
stallionamerican_quarter.skull = "HorseMod.Horse_Skull";
stallionamerican_quarter.xpPerItem = stallionamerican_quarter.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionamerican_quarter"] = stallionamerican_quarter

-----------------------------
----- AMERICAN QUARTER ------
-----------------------------

---- FILLY
local fillyamerican_paint = AnimalPartsDefinitions.animals["fillyamerican_paint"] or {};
fillyamerican_paint.parts = fillyamerican_paint.parts or horseparts;
fillyamerican_paint.bones = fillyamerican_paint.bones or fillybones;
fillyamerican_paint.head = "HorseMod.Horse_Head";
fillyamerican_paint.skull = "HorseMod.Horse_Skull";
fillyamerican_paint.xpPerItem = fillyamerican_paint.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyamerican_paint"] = fillyamerican_paint

---- MARE
local mareamerican_paint = AnimalPartsDefinitions.animals["mareamerican_paint"] or {};
mareamerican_paint.parts = mareamerican_paint.parts or horseparts;
mareamerican_paint.bones = mareamerican_paint.bones or horsebones;
mareamerican_paint.head = "HorseMod.Horse_Head";
mareamerican_paint.skull = "HorseMod.Horse_Skull";
mareamerican_paint.xpPerItem = mareamerican_paint.xpPerItem or horsexp
AnimalPartsDefinitions.animals["mareamerican_paint"] = mareamerican_paint

---- STALLION
local stallionamerican_paint = AnimalPartsDefinitions.animals["stallionamerican_paint"] or {};
stallionamerican_paint.parts = stallionamerican_paint.parts or horseparts;
stallionamerican_paint.bones = stallionamerican_paint.bones or horsebones;
stallionamerican_paint.head = "HorseMod.Horse_Head";
stallionamerican_paint.skull = "HorseMod.Horse_Skull";
stallionamerican_paint.xpPerItem = stallionamerican_paint.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionamerican_paint"] = stallionamerican_paint

-----------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- FILLY
local fillyappaloosa = AnimalPartsDefinitions.animals["fillyappaloosa"] or {};
fillyappaloosa.parts = fillyappaloosa.parts or horseparts;
fillyappaloosa.bones = fillyappaloosa.bones or fillybones;
fillyappaloosa.head = "HorseMod.Horse_Head";
fillyappaloosa.skull = "HorseMod.Horse_Skull";
fillyappaloosa.xpPerItem = fillyappaloosa.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyappaloosa"] = fillyappaloosa


-- MARE
local mareappaloosa = AnimalPartsDefinitions.animals["mareappaloosa"] or {};
mareappaloosa.parts = mareappaloosa.parts or horseparts;
mareappaloosa.bones = mareappaloosa.bones or horsebones;
mareappaloosa.head = "HorseMod.Horse_Head";
mareappaloosa.skull = "HorseMod.Horse_Skull";
mareappaloosa.xpPerItem = mareappaloosa.xpPerItem or horsexp
AnimalPartsDefinitions.animals["mareappaloosa"] = mareappaloosa

-- STALLION
local stallionappaloosa = AnimalPartsDefinitions.animals["stallionappaloosa"] or {};
stallionappaloosa.parts = stallionappaloosa.parts or horseparts;
stallionappaloosa.bones = stallionappaloosa.bones or horsebones;
stallionappaloosa.head = "HorseMod.Horse_Head";
stallionappaloosa.skull = "HorseMod.Horse_Skull";
stallionappaloosa.xpPerItem = stallionappaloosa.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionappaloosa"] = stallionappaloosa

-----------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- FILLY
local fillysteve_the_horse = AnimalPartsDefinitions.animals["fillysteve_the_horse"] or {};
fillysteve_the_horse.parts = fillysteve_the_horse.parts or horseparts;
fillysteve_the_horse.bones = fillysteve_the_horse.bones or fillybones;
fillysteve_the_horse.head = "HorseMod.Horse_Head";
fillysteve_the_horse.skull = "HorseMod.Horse_Skull";
fillysteve_the_horse.xpPerItem = fillysteve_the_horse.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillysteve_the_horse"] = fillysteve_the_horse

-- MARE
local maresteve_the_horse = AnimalPartsDefinitions.animals["maresteve_the_horse"] or {};
maresteve_the_horse.parts = maresteve_the_horse.parts or horseparts;
maresteve_the_horse.bones = maresteve_the_horse.bones or horsebones;
maresteve_the_horse.head = "HorseMod.Horse_Head";
maresteve_the_horse.skull = "HorseMod.Horse_Skull";
maresteve_the_horse.xpPerItem = maresteve_the_horse.xpPerItem or horsexp
AnimalPartsDefinitions.animals["maresteve_the_horse"] = maresteve_the_horse
-- STALLION
local stallionsteve_the_horse = AnimalPartsDefinitions.animals["stallionsteve_the_horse"] or {};
stallionsteve_the_horse.parts = stallionsteve_the_horse.parts or horseparts;
stallionsteve_the_horse.bones = stallionsteve_the_horse.bones or horsebones;
stallionsteve_the_horse.head = "HorseMod.Horse_Head";
stallionsteve_the_horse.skull = "HorseMod.Horse_Skull";
stallionsteve_the_horse.xpPerItem = stallionsteve_the_horse.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionsteve_the_horse"] = stallionsteve_the_horse

-----------------------------
----- BLUE ROAN -------------
-----------------------------

-- FILLY
local fillyblue_roan = AnimalPartsDefinitions.animals["fillyblue_roan"] or {};
fillyblue_roan.parts = fillyblue_roan.parts or horseparts;
fillyblue_roan.bones = fillyblue_roan.bones or fillybones;
fillyblue_roan.head = "HorseMod.Horse_Head";
fillyblue_roan.skull = "HorseMod.Horse_Skull";
fillyblue_roan.xpPerItem = fillyblue_roan.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyblue_roan"] = fillyblue_roan

-- MARE
local mareblue_roan = AnimalPartsDefinitions.animals["mareblue_roan"] or {};
mareblue_roan.parts = mareblue_roan.parts or horseparts;
mareblue_roan.bones = mareblue_roan.bones or horsebones;
mareblue_roan.head = "HorseMod.Horse_Head";
mareblue_roan.skull = "HorseMod.Horse_Skull";
mareblue_roan.xpPerItem = mareblue_roan.xpPerItem or horsexp
AnimalPartsDefinitions.animals["mareblue_roan"] = mareblue_roan

-- STALLION
local stallionblue_roan = AnimalPartsDefinitions.animals["stallionblue_roan"] or {};
stallionblue_roan.parts = stallionblue_roan.parts or horseparts;
stallionblue_roan.bones = stallionblue_roan.bones or horsebones;
stallionblue_roan.head = "HorseMod.Horse_Head";
stallionblue_roan.skull = "HorseMod.Horse_Skull";
stallionblue_roan.xpPerItem = stallionblue_roan.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionblue_roan"] = stallionblue_roan

-----------------------------
----- SPOTTED APPALOOSA -----
-----------------------------

-- FILLY
local fillyspotted_appaloosa = AnimalPartsDefinitions.animals["fillyspotted_appaloosa"] or {};
fillyspotted_appaloosa.parts = fillyspotted_appaloosa.parts or horseparts;
fillyspotted_appaloosa.bones = fillyspotted_appaloosa.bones or fillybones;
fillyspotted_appaloosa.head = "HorseMod.Horse_Head";
fillyspotted_appaloosa.skull = "HorseMod.Horse_Skull";
fillyspotted_appaloosa.xpPerItem = fillyspotted_appaloosa.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyspotted_appaloosa"] = fillyspotted_appaloosa

-- MARE
local marespotted_appaloosa = AnimalPartsDefinitions.animals["marespotted_appaloosa"] or {};
marespotted_appaloosa.parts = marespotted_appaloosa.parts or horseparts;
marespotted_appaloosa.bones = marespotted_appaloosa.bones or horsebones;
marespotted_appaloosa.head = "HorseMod.Horse_Head";
marespotted_appaloosa.skull = "HorseMod.Horse_Skull";
marespotted_appaloosa.xpPerItem = marespotted_appaloosa.xpPerItem or horsexp
AnimalPartsDefinitions.animals["marespotted_appaloosa"] = marespotted_appaloosa

-- STALLION
local stallionspotted_appaloosa = AnimalPartsDefinitions.animals["stallionspotted_appaloosa"] or {};
stallionspotted_appaloosa.parts = stallionspotted_appaloosa.parts or horseparts;
stallionspotted_appaloosa.bones = stallionspotted_appaloosa.bones or horsebones;
stallionspotted_appaloosa.head = "HorseMod.Horse_Head";
stallionspotted_appaloosa.skull = "HorseMod.Horse_Skull";
stallionspotted_appaloosa.xpPerItem = stallionspotted_appaloosa.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionspotted_appaloosa"] = stallionspotted_appaloosa

-------------------------------------
----- AMERICAN PAINT (OVERO) --------
-------------------------------------

-- FILLY
local fillyamerican_paint_overo = AnimalPartsDefinitions.animals["fillyamerican_paint_overo"] or {};
fillyamerican_paint_overo.parts = fillyamerican_paint_overo.parts or horseparts;
fillyamerican_paint_overo.bones = fillyamerican_paint_overo.bones or fillybones;
fillyamerican_paint_overo.head = "HorseMod.Horse_Head";
fillyamerican_paint_overo.skull = "HorseMod.Horse_Skull";
fillyamerican_paint_overo.xpPerItem = fillyamerican_paint_overo.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyamerican_paint_overo"] = fillyamerican_paint_overo

-- MARE
local mareamerican_paint_overo = AnimalPartsDefinitions.animals["mareamerican_paint_overo"] or {};
mareamerican_paint_overo.parts = mareamerican_paint_overo.parts or horseparts;
mareamerican_paint_overo.bones = mareamerican_paint_overo.bones or horsebones;
mareamerican_paint_overo.head = "HorseMod.Horse_Head";
mareamerican_paint_overo.skull = "HorseMod.Horse_Skull";
mareamerican_paint_overo.xpPerItem = mareamerican_paint_overo.xpPerItem or horsexp
AnimalPartsDefinitions.animals["mareamerican_paint_overo"] = mareamerican_paint_overo

-- STALLION
local stallionamerican_paint_overo = AnimalPartsDefinitions.animals["stallionamerican_paint_overo"] or {};
stallionamerican_paint_overo.parts = stallionamerican_paint_overo.parts or horseparts;
stallionamerican_paint_overo.bones = stallionamerican_paint_overo.bones or horsebones;
stallionamerican_paint_overo.head = "HorseMod.Horse_Head";
stallionamerican_paint_overo.skull = "HorseMod.Horse_Skull";
stallionamerican_paint_overo.xpPerItem = stallionamerican_paint_overo.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionamerican_paint_overo"] = stallionamerican_paint_overo

-----------------------------
----- FLEA-BITTEN GREY ------
-----------------------------

-- FILLY
local fillyflea_bitten_grey = AnimalPartsDefinitions.animals["fillyflea_bitten_grey"] or {};
fillyflea_bitten_grey.parts = fillyflea_bitten_grey.parts or horseparts;
fillyflea_bitten_grey.bones = fillyflea_bitten_grey.bones or fillybones;
fillyflea_bitten_grey.head = "HorseMod.Horse_Head";
fillyflea_bitten_grey.skull = "HorseMod.Horse_Skull";
fillyflea_bitten_grey.xpPerItem = fillyflea_bitten_grey.xpPerItem or fillyxp
AnimalPartsDefinitions.animals["fillyflea_bitten_grey"] = fillyflea_bitten_grey

-- MARE
local mareflea_bitten_grey = AnimalPartsDefinitions.animals["mareflea_bitten_grey"] or {};
mareflea_bitten_grey.parts = mareflea_bitten_grey.parts or horseparts;
mareflea_bitten_grey.bones = mareflea_bitten_grey.bones or horsebones;
mareflea_bitten_grey.head = "HorseMod.Horse_Head";
mareflea_bitten_grey.skull = "HorseMod.Horse_Skull";
mareflea_bitten_grey.xpPerItem = mareflea_bitten_grey.xpPerItem or horsexp
AnimalPartsDefinitions.animals["mareflea_bitten_grey"] = mareflea_bitten_grey

-- STALLION
local stallionflea_bitten_grey = AnimalPartsDefinitions.animals["stallionflea_bitten_grey"] or {};
stallionflea_bitten_grey.parts = stallionflea_bitten_grey.parts or horseparts;
stallionflea_bitten_grey.bones = stallionflea_bitten_grey.bones or horsebones;
stallionflea_bitten_grey.head = "HorseMod.Horse_Head";
stallionflea_bitten_grey.skull = "HorseMod.Horse_Skull";
stallionflea_bitten_grey.xpPerItem = stallionflea_bitten_grey.xpPerItem or horsexp
AnimalPartsDefinitions.animals["stallionflea_bitten_grey"] = stallionflea_bitten_grey

-----------------------------
----- HEAD RECIPE STUFF -----
-----------------------------
-- Events.OnGameStart.Add(function()
--     local recipe = ScriptManager.instance:getCraftRecipe("SliceHead")
--     if recipe then
--         local outputs = recipe:getOutputs()
--         for i=0, outputs:size()-1 do
--             local out = outputs:get(i)
--             local mapper = out:getOutputMapper()
--             if mapper then
--                 local list = ArrayList.new()
--                 list:add("HorseMod.Horse_Head")
--                 mapper:addOutputEntree("HorseMod.Horse_Skull", list)
--                 mapper:OnPostWorldDictionaryInit(recipe:getName())
--             end
--         end
--     end
-- end)