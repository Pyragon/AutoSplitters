state("EmuHawk") {
    byte stage : "octoshock.dll", 0x38BFA8;
    byte pipeCount : "octoshock.dll", 0x39247B;
    int beanCount : "octoshock.dll", 0x38B3E0;
    int onDeathMenu : "octoshock.dll", 0x38BF68;
    // int interId : 
    //5808192
}

init {
    vars.collectingPipes = false;
    vars.deathCount = 0;
    vars.fakeDeathCount = 0;
    vars.LoadSettings("Pipes Collected");
    vars.LoadSettings("Beans Collected");
}

startup {
    vars.SetTextComponent = (Action<string, string>)((id, text) => {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting != null)
            textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
    vars.SetTextComponentObject = (Action<string, object>)((id, value) => {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if(textSetting != null)
            textSetting.GetType().GetProperty("Text2").SetValue(textSetting, ""+value);
    });
    vars.LoadSettings = (Action<string>)((value) => {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == value);
        if(textSetting != null) {
            var textValue =  textSetting.GetType().GetProperty("Text2").GetValue(textSetting, null) as string;
            if(value == "Pipes Collected")
                vars.pipeCount = Int32.Parse(textValue);
            else if(value == "Beans Collected")
                vars.beanCount = Int32.Parse(textValue);
        }
    });
    
    vars.SplitStages = new List<int>() {
        4, //End of boxes. After climbing up roof
        5, //After climing out of atic?
        8, //End of De-Gnoming, Would love to find some memory where # of gnomes left is stored
        10, //End of Fred Duels
        12, //Wrong Warp
        18, //End of Herbology Race
        20, //End of Mandrakes
        23, //End of Quidditch
        26, //End of Puking
        30, //End of Death Abuse
        36, //Deathday Skip
        39, //End of Potions Class
        43, //End of second Quidditch book
        48, //End of Diagon Alley (Might be 47)
        53, //End of Snake Duel book
        55, //End of Fat Slip and slide
        62, //End of DADA #2 and Cupids
        63, //End of Sneaky Sneak,
        64, //End of forest and trolls
        65, //End of Aragog
        71 //End of Slip and Slide
    };

}

start {
    if(old.stage == 1 && current.stage == 2) {
        vars.deathCount = 0;
        return true;
    }
}

update {
    if(current.stage > 1 && (current.stage - vars.deathCount) != 29 && old.onDeathMenu != 17 && current.onDeathMenu == 17) {
        vars.deathCount++;
    }
    if(current.stage == 4 && current.pipeCount > 0) //check stage as well
        vars.collectingPipes = true;
    if(vars.collectingPipes && old.pipeCount == current.pipeCount + 1) {
        vars.pipeCount++;
        vars.SetTextComponentObject("Pipes Collected", vars.pipeCount);
    }
    if((current.beanCount - old.beanCount) == 4096) {
        vars.beanCount++;
        vars.SetTextComponentObject("Beans Collected", vars.beanCount);
    }
    vars.SetTextComponentObject("Deaths", vars.deathCount);
    vars.SetTextComponentObject("Beans Collected", vars.beanCount);
    vars.SetTextComponentObject("Actual Stage", current.stage);
    if(current.stage != 4 || current.pipeCount == 0) // check stage as well
        vars.collectingPipes = false;
}

split {
    return old.stage != current.stage && vars.SplitStages.Contains(current.stage - vars.deathCount);
}

reset {
    if(old.stage != 1 && current.stage == 1) {
        vars.deathCount = 0;
        return true;
    }
    return false;
}