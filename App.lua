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
            if( InCombatLockdown() ) then
                return;
            end
            if( Addon.APP:GetValue( 'Debug' ) ) then
                Addon.FRAMES:Debug( 'Refreshing...' );
            end

            -- Actionbar 1
            if( MainActionBar ) then
                local MainActionBarParent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );
                MainActionBar:SetParent( MainActionBarParent);
                if( self:GetValue( 'MainMenuBarShown' ) ) then
                    RegisterStateDriver( MainActionBarParent,'visibility','show' );
                else
                    RegisterStateDriver( MainActionBarParent,'visibility','hide' );
                end
            end

            -- Stancebar
            if( StanceBar ) then
                local StanceBarParent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );
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

            -- Actionbar 2
            if( MultiBarBottomLeft ) then
                if( self:GetValue( 'MultiBarBottomLeftShown' ) ) then
                    MultiBarBottomLeft:Show();
                else
                    MultiBarBottomLeft:Hide();
                end
            end

            -- Actionbar 3
            if( MultiBarBottomRight ) then
                if( self:GetValue( 'MultiBarBottomRightShown' ) ) then
                    MultiBarBottomRight:Show();
                else
                    MultiBarBottomRight:Hide();
                end
            end

            -- Multibar 4
            if( MultiBarLeft ) then
                if( self:GetValue( 'MultiBarLeftShown' ) ) then
                    MultiBarLeft:Show();
                else
                    MultiBarLeft:Hide();
                end
            end

            -- Multibar 5
            if( MultiBarRight ) then
                if( self:GetValue( 'MultiBarRightShown' ) ) then
                    MultiBarRight:Show();
                else
                    MultiBarRight:Hide();
                end
            end
        end

        Addon.DB:Init();
        Addon.CONFIG:Init();
        Addon.APP:Refresh();

        -- Forcefully override Interface > Options changes
        hooksecurefunc( 'MultiActionBar_Update',function()
            Addon.APP:Refresh();
        end );

        -- Remove Vehicle from MainMenuBar
        if( MainMenuBarVehicleLeaveButton ) then
            MainMenuBarVehicleLeaveButton:SetParent( PlayerFrame );
        end

        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );