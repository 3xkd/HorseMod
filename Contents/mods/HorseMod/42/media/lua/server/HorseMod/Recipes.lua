function HorseGlueToWoodglue(craftRecipeData, character)
    -- your custom code here

    local createdItems = craftRecipeData:getAllCreatedItems()
    for i=0, createdItems:size()-1 do
      local output = createdItems:get(i)
      output:setName(getItemNameFromFullType("HorseMod.HorseGlue"))
    end
end
