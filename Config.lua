local _, Addon = ...;

Addon.CONFIG = CreateFrame( 'Frame' );
Addon.CONFIG:RegisterEvent( 'ADDON_LOADED' );
Addon.CONFIG:SetScript( 'OnEvent',function( self,Event,AddonName )
    if( AddonName == 'jFrames' ) then

        --
        --  Get module settings
        --
        --  @return table
        Addon.CONFIG.GetSettings = function( self )
            local GetHudSettings = function()
                local Order = 1;
                local Settings = {
                    BottomBars = {
                        type = 'header',
                        order = Order,
                        name = 'Bottom Screen Bars',
                    },
                };
                Order = Order+1;
                Settings.MultiBarBottomRightShown = {
                    order = Order,
                    type = 'toggle',
                    name = 'Top Bar Shown',
                    desc = 'If the hud should show your Action Bar 3',
                    arg = 'MultiBarBottomRightShown',
                };
                Order = Order+1;
                Settings.MultiBarBottomLeftShown = {
                    order = Order,
                    type = 'toggle',
                    name = 'Middle Bar Shown',
                    desc = 'If the hud should show your Action Bar 2',
                    arg = 'MultiBarBottomLeftShown',
                };
                Order = Order+1;
                Settings.MainMenuBarShown = {
                    order = Order,
                    type = 'toggle',
                    name = 'Bottom Bar Shown',
                    desc = 'If the hud should show your Main Menu Bar',
                    arg = 'MainMenuBarShown',
                };
                Order = Order+1;
                Settings.StanceBarShown = {
                    order = Order,
                    type = 'toggle',
                    name = 'Show StanceBar',
                    desc = 'If the hud should show your Stance Bar',
                    arg = 'StanceBarShown',
                };



                Order = Order+1;
                Settings.SideBars = {
                    type = 'header',
                    order = Order,
                    name = 'Right Screen Bars',
                };
                Order = Order+1;
                Settings.MultiBarLeftShown = {
                    order = Order,
                    type = 'toggle',
                    name = 'Left Bar Shown',
                    desc = 'If the hud should show your Action Bar 4',
                    arg = 'MultiBarLeftShown',
                };
                Order = Order+1;
                Settings.MultiBarRightShown = {
                    order = Order,
                    type = 'toggle',
                    name = 'Right Bar Shown',
                    desc = 'If the hud should show your Action Bar 5',
                    arg = 'MultiBarRightShown',
                };
                Order = Order+1;
                Settings.ObjectiveTrackerCollapsed = {
                    order = Order,
                    type = 'toggle',
                    name = 'Objective Tracker Collapsed',
                    desc = 'If the hud should automatically collapse the Objective Tracker',
                    arg = 'ObjectiveTrackerCollapsed',
                };



                Order = Order+1;
                Settings.Other = {
                    type = 'header',
                    order = Order,
                    name = '',
                };
                Order = Order+1;
                Settings.Debug = {
                    order = Order,
                    type = 'toggle',
                    name = 'Debug Shown',
                    desc = 'Show Debug messages in chat when the default blizzard UI tries to apply its own bar settings',
                    arg = 'Debug',
                };

                return Settings;
            end

            local Settings = {
                type = 'group',
                get = function( Info )
                    if( Addon.DB:GetPersistence()[ Info.arg ] ~= nil ) then
                        return Addon.DB:GetPersistence()[ Info.arg ];
                    end
                end,
                set = function( Info,Value )
                    if( Addon.DB:GetPersistence()[ Info.arg ] ~= nil ) then
                        Addon.DB:GetPersistence()[ Info.arg ] = Value;
                        if( Addon.APP.Refresh ) then
                            Addon.APP:Refresh();
                        end
                    end
                    Addon.APP:Refresh();
                end,
                name = AddonName .. ' Settings',
                childGroups = 'tab',
                args = {},
            };

            -- Main Map
            local Order = 0;
            Settings.args[ 'tab'..Order ] = {
                type = 'group',
                name = 'Hud',
                width = 'full',
                order = Order,
                args = GetHudSettings(),
            };

            Settings.args.profiles = LibStub( 'AceDBOptions-3.0' ):GetOptionsTable( Addon.DB.db );

            return Settings;
        end

        --
        --  Create module config frames
        --
        --  @return void
        Addon.CONFIG.Init = function( self )

            -- Initialize window
            local _, CategoryID = LibStub( 'AceConfigDialog-3.0' ):AddToBlizOptions( AddonName,AddonName );
            LibStub( 'AceConfigRegistry-3.0' ):RegisterOptionsTable( AddonName,self:GetSettings() );

            SLASH_JFRAMES1, SLASH_JFRAMES2 = '/jf', '/jframes';
            SlashCmdList[ string.upper( AddonName ) ] = function( Msg,EditBox )
                if( InCombatLockdown() ) then
                    Addon.FRAMES:Error( 'You are in combat' );
                end
                if( InterfaceOptionsFrame_OpenToCategory ) then
                    InterfaceOptionsFrame_OpenToCategory( AddonName );
                    InterfaceOptionsFrame_OpenToCategory( AddonName );
                else
                    Settings.OpenToCategory( CategoryID );
                end
            end
        end

        self:UnregisterEvent( 'ADDON_LOADED' );
    end
end );