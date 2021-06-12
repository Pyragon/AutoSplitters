state("EmuHawk") {
    byte isProceedMenu : "octoshock.dll", 0x38E1A0;
    byte stage : "octoshock.dll", 0x38BFA8
}

start {
    if(old.stage == 1 && current.stage == 2) {
        return true;
    }
}

reset {
    return old.isProceedMenu == 0 && current.isProceedMenu == 1;
}