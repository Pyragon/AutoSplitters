state("EmuHawk") {
    byte isProceedMenu : "octoshock.dll", 0x38E1A0;
    byte stage : "octoshock.dll", 0x38BFA8;
    byte pipeCount : "octoshock.dll", 0x39247B;
}

init {
    vars.collectingPipes = false;
    vars.LoadSettings("Pipes Collected");
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
            vars.pipeCount = Int32.Parse(textValue);
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
    };

}

start {
    if(old.stage == 1 && current.stage == 2) {
        return true;
    }
}

update {
    if(current.pipeCount > 0)
        vars.collectingPipes = true;
    if(vars.collectingPipes && old.pipeCount == current.pipeCount + 1) {
        vars.pipeCount++;
        vars.SetTextComponentObject("Pipes Collected", vars.pipeCount);
    }
    if(current.pipeCount == 0)
        vars.collectingPipes = false;
}

split {
    return old.stage != current.stage && vars.SplitStages.Contains(current.stage);
}

reset {
    return old.stage != 1 && current.stage == 1;
}