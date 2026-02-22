local _, Addon = ...;

Addon.FRAMES = CreateFrame( 'Frame' );
Addon.FRAMES:RegisterEvent( 'ADDON_LOADED' );
Addon.FRAMES:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jFrames' ) then
        local Parent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );

        -- Hide Actionbar 1
        if( MainActionBar ) then
            MainActionBar:SetParent( Parent);
        end

        -- Hide Stancebar
        if( StanceBar ) then
            StanceBar:SetParent( Parent);
        end

        -- Collapse the Objective Tracker
        if( ObjectiveTrackerFrame and not ObjectiveTrackerFrame.isCollapsed ) then
            ObjectiveTrackerFrame:SetCollapsed(true);
        end

        RegisterStateDriver( Parent,'visibility','hide' );

        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );