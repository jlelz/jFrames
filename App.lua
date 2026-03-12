local _,Library = ...;
local jFrames = LibStub( 'AceAddon-3.0' ):NewAddon( 'jFrames','AceEvent-3.0','AceHook-3.0','AceConsole-3.0' );

function jFrames:SetValue( Index,Value )
    return self:SetDBValue( Index,Value );
end

function jFrames:GetValue( Index )
    return self:GetDBValue( Index );
end

function jFrames:Refresh()
    if( self:GetValue( 'Debug' ) ) then
        Library.FRAMES:Debug( 'Refreshing...' );
    end

    -- Actionbar 1
    if( self:GetValue( 'MainMenuBarShown' ) ) then
        MainActionBar:GetParent():Show();
        --RegisterStateDriver( MainActionBar:GetParent(),'visibility','show' );
    else
        --RegisterStateDriver( MainActionBar:GetParent(),'visibility','hide' );
        MainActionBar:GetParent():Hide();
    end

    -- Stancebar
    if( StanceBar ) then
        if( self:GetValue( 'StanceBarShown' ) ) then
            StanceBar:GetParent():Show();
            --RegisterStateDriver( StanceBar:GetParent(),'visibility','show' );
        else
            --RegisterStateDriver( StanceBar:GetParent(),'visibility','hide' );
            StanceBar:GetParent():Hide();
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

    if( self:GetValue( 'Debug' ) ) then
        Library.FRAMES:Debug( 'Done' );
    end
end

function jFrames:OnEnable()
    -- Actionbar 1
    if( MainActionBar ) then
        local MainActionBarParent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );
        MainActionBar:SetParent( MainActionBarParent);
    end
    -- Stancebar
    if( StanceBar ) then
        local StanceBarParent = CreateFrame( 'Frame',nil,UIParent,'SecureHandlerStateTemplate' );
        StanceBar:SetParent( StanceBarParent);
    end

    -- Forcefully override Interface > Options changes
    hooksecurefunc( 'MultiActionBar_Update',function()
        self:Refresh();
    end );

    if( EditModeManager ) then
        hooksecurefunc( EditModeManager,'OnLayoutApplied',function()
            self:Refresh();
        end)
    end

    -- Remove Vehicle from MainMenuBar
    if( MainMenuBarVehicleLeaveButton ) then
        MainMenuBarVehicleLeaveButton:SetParent( PlayerFrame );
    end
end

function jFrames:ConfigOpen( Input )
    if( not Input or Input:trim() == "" ) then

        if( InterfaceOptionsFrame_OpenToCategory ) then
            InterfaceOptionsFrame_OpenToCategory( self.CategoryID );
        else
            Settings.OpenToCategory( self.CategoryID );
        end
    else
        self:Print( 'Command:',Input );
    end
end

function jFrames:OnInitialize()
    self:InitializeDB();
    self:InitializeConfig();
    self:RegisterChatCommand( 'jf','ConfigOpen' );
end