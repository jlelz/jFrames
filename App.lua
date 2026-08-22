local _,Library = ...;
local jFrames = LibStub( 'AceAddon-3.0' ):NewAddon( 'jFrames','AceEvent-3.0','AceHook-3.0','AceConsole-3.0' );

function jFrames:SetValue( Index,Value )
    return self:SetDBValue( Index,Value );
end

function jFrames:GetValue( Index )
    return self:GetDBValue( Index );
end

function jFrames:Refresh()
    -- Safety check: State drivers cannot be dynamically re-registered while in combat lockdown
    if( InCombatLockdown() ) then
        return;
    end
    
    if( self:GetValue( 'Debug' ) ) then
        Library.FRAMES:Debug( 'Refreshing...' );
    end

    -- Actionbar 1 (Main Menu Bar Parent)
    if ( self.MainActionBarParent ) then
        if ( self:GetValue( 'MainMenuBarShown' ) ) then
            RegisterStateDriver( self.MainActionBarParent, 'visibility', 'show' );
        else
            RegisterStateDriver( self.MainActionBarParent, 'visibility', 'hide' );
        end
    end

    -- Stancebar
    if ( self.StanceBarParent ) then
        if ( self:GetValue( 'StanceBarShown' ) ) then
            RegisterStateDriver( self.StanceBarParent, 'visibility', 'show' );
        else
            RegisterStateDriver( self.StanceBarParent, 'visibility', 'hide' );
        end
    end

    -- Objective Tracker (Protected wrap to avoid spreading taint to GetAuraDataByIndex)
    if( ObjectiveTrackerFrame ) then
        local targetState = self:GetValue( 'ObjectiveTrackerCollapsed' ) == true
        if( ObjectiveTrackerFrame.SetCollapsedState ) then
            ObjectiveTrackerFrame:SetCollapsedState( targetState );
        else
            securecall( function()
                ObjectiveTrackerFrame:SetCollapsed( targetState );
            end );
        end
    end

    -- Actionbar 2
    if( MultiBarBottomLeft ) then
        if( self:GetValue( 'MultiBarBottomLeftShown' ) ) then
            RegisterStateDriver( MultiBarBottomLeft, 'visibility', 'show' );
        else
            RegisterStateDriver( MultiBarBottomLeft, 'visibility', 'hide' );
        end
    end

    -- Actionbar 3
    if( MultiBarBottomRight ) then
        if( self:GetValue( 'MultiBarBottomRightShown' ) ) then
            RegisterStateDriver( MultiBarBottomRight, 'visibility', 'show' );
        else
            RegisterStateDriver( MultiBarBottomRight, 'visibility', 'hide' );
        end
    end

    -- Multibar 4
    if( MultiBarLeft ) then
        if( self:GetValue( 'MultiBarLeftShown' ) ) then
            RegisterStateDriver( MultiBarLeft, 'visibility', 'show' );
        else
            RegisterStateDriver( MultiBarLeft, 'visibility', 'hide' );
        end
    end

    -- Multibar 5
    if( MultiBarRight ) then
        if( self:GetValue( 'MultiBarRightShown' ) ) then
            RegisterStateDriver( MultiBarRight, 'visibility', 'show' );
        else
            RegisterStateDriver( MultiBarRight, 'visibility', 'hide' );
        end
    end

    -- PlayerFrame
    if( RegisterAttributeDriver and PlayerFrame ) then
        if( not self:GetValue( 'PlayerFrameAlwaysShown' ) ) then
            RegisterAttributeDriver( PlayerFrame, "state-visibility", "[combat] show; hide" );
        else
            UnregisterAttributeDriver( PlayerFrame, "state-visibility" );
        end
    end

    if( self:GetValue( 'Debug' ) ) then
        Library.FRAMES:Debug( 'Done' );
    end
end

function jFrames:OnEnable()
    -- Actionbar 1 Parent Setup
    if( MainActionBar ) then
        -- We assign the parents to self variables so they can be securely toggled via RegisterStateDriver
        self.MainActionBarParent = CreateFrame( 'Frame', nil, UIParent, 'SecureHandlerStateTemplate' );
        MainActionBar:SetParent( self.MainActionBarParent );
    end
    
    -- Stancebar Parent Setup
    if( StanceBar ) then
        self.StanceBarParent = CreateFrame( 'Frame', nil, UIParent, 'SecureHandlerStateTemplate' );
        StanceBar:SetParent( self.StanceBarParent );
    end

    -- Forcefully override Interface > Options changes
    hooksecurefunc( 'MultiActionBar_Update', function()
        self:Refresh();
    end );

    if( EditModeManager ) then
        hooksecurefunc( EditModeManager, 'OnLayoutApplied', function()
            self:Refresh();
        end)
    end

    -- Remove Vehicle from MainMenuBar
    if( MainMenuBarVehicleLeaveButton ) then
        MainMenuBarVehicleLeaveButton:SetParent( PlayerFrame );
    end
end

function jFrames:ConfigOpen( Input )
    if( InCombatLockdown() ) then
        Library.FRAMES:Error( 'You are in combat' );
        return;
    end
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