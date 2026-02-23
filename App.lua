local _, Addon = ...;

Addon.APP = CreateFrame( 'Frame' );
Addon.APP:RegisterEvent( 'ADDON_LOADED' );
Addon.APP:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jFrames' ) then

        --
        --  Set value
        --
        --  @param  string  Index
        --  @param  mixed   Value
        --  @return bool
        Addon.APP.SetValue = function( self,Index,Value )
            return Addon.DB:SetValue( Index,Value );
        end

        --
        --  Get value
        --
        --  @return mixed
        Addon.APP.GetValue = function( self,Index )
            return Addon.DB:GetValue( Index );
        end

        Addon.APP.Refresh = function( self )
            -- Actionbar 1
            local MainActionBarParent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );
            if( MainActionBar ) then
                MainActionBar:SetParent( MainActionBarParent);
                if( self:GetValue( 'MainMenuBarShown' ) ) then
                    RegisterStateDriver( MainActionBarParent,'visibility','show' );
                else
                    RegisterStateDriver( MainActionBarParent,'visibility','hide' );
                end
            end

            -- Stancebar
            local StanceBarParent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );
            if( StanceBar ) then
                StanceBar:SetParent( StanceBarParent);
                if( self:GetValue( 'StanceBarShown' ) ) then
                    RegisterStateDriver( StanceBarParent,'visibility','show' );
                else
                    RegisterStateDriver( StanceBarParent,'visibility','hide' );
                end
            end

            -- Objective Tracker
            if( ObjectiveTrackerFrame ) then
                if( not self:GetValue( 'ObjectiveTrackerCollapsed' ) ) then
                    ObjectiveTrackerFrame:SetCollapsed( false );
                else
                    ObjectiveTrackerFrame:SetCollapsed( true );
                end
            end
        end

        Addon.DB:Init();
        Addon.CONFIG:Init();
        Addon.APP:Refresh();

        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );