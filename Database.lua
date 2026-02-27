local _,Library = ...;
local jFrames = LibStub( 'AceAddon-3.0' ):GetAddon( 'jFrames' );

function jFrames:SetDBValue( Index,Value )
    if( self:GetPersistence()[ Index ] ~= nil ) then
        self:GetPersistence()[ Index ] = Value;
    end
end

function jFrames:GetDBValue( Index )
    if( self:GetPersistence()[ Index ] ~= nil ) then
        return self:GetPersistence()[ Index ];
    end
end

function jFrames:GetPersistence()
    return self.db.global;
end

function jFrames:Reset()
    -- Wipe Database
    wipe( self.db.global ); 

    -- Reset Profile
    self.db:ResetProfile();

    -- Refresh Settings
    if( C_UI and C_UI.Reload ) then
        C_UI.Reload();
    else
        ReloadUI();
    end
end

function jFrames:InitializeDB()
    local Defaults = {
        global = {
            MainMenuBarShown = false,
            MultiBarBottomLeftShown = false,
            MultiBarBottomRightShown = false,
            MultiBarRightShown = true,
            MultiBarLeftShown = true,
            
            StanceBarShown = false,

            ObjectiveTrackerCollapsed = true,

            Debug = false,
        },
    };

    self.db = LibStub( 'AceDB-3.0' ):New( self:GetName(),Defaults,'global' );

    self.db.RegisterCallback( self,'OnProfileChanged','Reset' );
    self.db.RegisterCallback( self,'OnProfileCopied','Reset' );
    self.db.RegisterCallback( self,'OnProfileReset','Reset' );
end