---------------------------------------
-- IMPORTS
---------------------------------------
import qualified Data.Map as M
import Data.Maybe
import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.WithAll
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Grid
import XMonad.Layout.MultiColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

--------------------------------------------------
-- CONFIGURATION
-- Configuration variables
--------------------------------------------------

-- PROGRAMS
myTerminal :: String
myTerminal = "alacritty" -- Sets default terminal

myBrowser :: String
myBrowser = "firefox" -- Sets default browser

myIDE :: String
myIDE = "alacritty -e nvim" -- Sets default IDE

myExplorer :: String
myExplorer = "nautilus" -- Sets default file explorer

-- XMONAD SPECIFIC
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True -- Whether focus follows the mouse pointer.

-- BORDERS
myBorderWidth :: Dimension
myBorderWidth = 2 -- Width of the window border in pixels.

myBorderColor :: String
myBorderColor = "#2e3440" -- Normal border color

myFocusColor :: String
myFocusColor = "#74B99A" -- Focused border color

-- WORKSPACES
myModMask :: KeyMask
myModMask = mod4Mask -- Sets the modkey

myWorkspaces = ["www", "dev", "doc", "soc", "mus", "sys", "vid", "gfx", "etc"] -- Sets the named workspaces

-- SPACING
-- TODO: NOT CHANGING
mySpacing :: Int
mySpacing = 3 -- Sets the spacing

--------------------------------------------------
-- WORKSPACES
--------------------------------------------------

windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Icon for each workspace
myWorkspacesIcons = ["\xf484", "\xe795", "\xf718", "\xf415", "\xf001", "\xe712", "\xf03d", "\xf040", "\xfa35"]

-- Indices
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

myWorkspaceIconIndices = M.fromList $ zipWith (,) myWorkspaces myWorkspacesIcons

-- Show icon and name
clickableIconName ws = "<action=xdotool key super+" ++ show i ++ ">" ++ iconName ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

iconName ws = icon ws ++ " " ++ ws

-- Show only icon
clickableIcon ws = "<action=xdotool key super+" ++ show i ++ ">" ++ icon ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

icon ws = i
  where
    i = fromJust $ M.lookup ws myWorkspaceIconIndices

--------------------------------------------------
-- KEYBINDS
-- All my key binds
--------------------------------------------------
myKeys :: [(String, X ())]
myKeys =
  [ -- Xmonad
    ("M-S-q", io (exitWith ExitSuccess)), -- Quit xmonad
    ("M-q", spawn "xmonad --recompile; xmonad --restart"), -- Restart xmonad

    -- Workspaces
    ("M-.", nextScreen), -- Switch focus to next monitor
    ("M-,", prevScreen), -- Switch focus to prev monitor

    -- Screen
    ("M-S-l", spawn "light-locker-command --lock"),
    -- Run Prompt
    --, ("M-p", spawn "dmenu_run") -- Run demenu
    ("M-S-p", spawn "rofi -show run"), -- Run rofi
    ("M-p", spawn "rofi -show drun"), -- Run rofi desktop
    ("M-e", spawn "rofimoji"), -- Run rofi emoji

    -- Windows
    ("M-S-c", kill), -- Kill focused window
    ("M-S-a", killAll), -- Kill all windows on currento WS
    ("M-j", windows W.focusDown), -- Focus next window
    ("M-k", windows W.focusUp), -- Focus prev window
    ("M-m", windows W.focusMaster), -- Focus master
    ("M-S-m", windows W.swapMaster), -- Swap the focused window and the master window
    ("M-h", sendMessage Shrink), -- Shrink the master area
    ("M-l", sendMessage Expand), -- Expand the master area
    ("M-t", withFocused $ windows . W.sink), -- Push window back into tiling
    ("M-S-t", sinkAll), -- Push all windows back into tiling
    ("M-S-<Up>", sendMessage (IncMasterN 1)), -- Increment the number of windows in the master area
    ("M-S-<Down>", sendMessage (IncMasterN (-1))), -- Deincrement the number of windows in the master area
    ("M-S-<Tab>", spawn "rofi -show window"),
    -- Appliactions
    ("M-<Return>", spawnHere myTerminal), -- Creates a new Terminal
    ("M-b", spawnHere myBrowser),
    ("M-c", spawnHere myIDE),
    ("M-f", spawnHere myExplorer),
    -- Layouts
    ("M-<Space>", sendMessage NextLayout), -- Rotate through the available layout algorithms
    ("M-x", sendMessage $ Toggle REFLECTX),
    ("M-y", sendMessage $ Toggle MIRROR),
    -- Print
    ("<Print>", spawn "sleep 0.2; scrot -e 'xclip -selection clipboard -t image/png $f' -s"), -- Selection screenshot
    ("S-<Print>", spawn "sleep 0.2; scrot -e 'xclip -selection clipboard -t image/png $f'"), -- Fullscreen screenshot

    -- Multimedia Keys
    ("<XF86AudioMute>", spawn "/bin/sh ~/.confg/xmonad/scripts/changevolume.sh toggle"),
    ("<XF86AudioLowerVolume>", spawn "/bin/sh ~/.config/xmonad/scripts/changevolume.sh down"),
    ("<XF86AudioRaiseVolume>", spawn "/bin/sh ~/.config/xmonad/scripts/changevolume.sh up"),
    -- Spotify only
    ("<XF86AudioPlay>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"),
    ("<XF86AudioNext>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"),
    ("<XF86AudioPrev>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
  ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
------------------------------------------------------------------------
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

--------------------------------------------------
-- LAYOUTS
-- [ tiled: Default tiled layout
-- [ full: Shows only one window
-- [ monocle: Shows only one window with no struts
--------------------------------------------------

myLayoutHook =
  onWorkspace "soc" socLayouts $
    onWorkspace "doc" docLayouts $
      (tiled ||| full ||| monocle ||| multiCols)
  where
    socLayouts = (grid ||| full ||| monocle)
    docLayouts = (multiCols ||| full ||| monocle)
    tiled =
      avoidStruts $
        mkToggle (single REFLECTX) $
          mkToggle (single MIRROR) $
            spacing mySpacing $
              Tall 1 (3 / 100) (1 / 2)
    full =
      avoidStruts $
        spacing mySpacing $
          Full
    multiCols =
      avoidStruts $
        mkToggle (single REFLECTX) $
          mkToggle (single MIRROR) $
            spacing mySpacing $
              multiCol [1] 1 0.01 (-0.5)
    monocle =
      noBorders $
        spacing 0 $
          Full
    grid =
      avoidStruts $
        mkToggle (single REFLECTX) $
          mkToggle (single MIRROR) $
            spacing mySpacing $
              Grid

-- default tiling algorithm partitions the screen into two panes

--------------------------------------------------
-- MANAGE HOOK
-- Sets how specific applications should startup as
-- [ doFloat: Starts floating
-- [ doShift: Shifts to a specific workspace
--------------------------------------------------
myManageHook =
  composeAll
    [ resource =? "bitwarden" --> doFloat,
      resource =? "gpick" --> doFloat,
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore,
      -- Will always spawn on Workspace soc
      resource =? "telegram-desktop" --> doShift (myWorkspaces !! 3),
      resource =? "whatsapp-nativefier-d40211" --> doShift (myWorkspaces !! 3),
      resource =? "discord" --> doShift (myWorkspaces !! 3),
      resource =? "steam" --> doShift (myWorkspaces !! 3),
      -- Make fullscreen windows float
      isFullscreen --> doFullFloat
    ]

--------------------------------------------------
-- STARTUP HOOK
-- Spawns specific applications when xmonad opens
--------------------------------------------------
myStartupHook = do
  -- System stuff
  spawnOnce "light-locker &"
  spawnOnce "picom --xrender-sync-fence --backend glx --experimental-backend --config ~/.config/picom.conf &"
  spawnOnce "nitrogen --restore &"
  spawnOnce "dunst &"

  -- Social apps
  spawnOnce "telegram-desktop &"
  spawnOnce "discord &"
  spawnOnce "whatsapp-nativefier &"
  spawnOnce "spotify &"

--------------------------------------------------
-- MAIN
--------------------------------------------------
main :: IO ()
main = do
  -- Launches polybar
  polybarMain <- spawnPipe "polybar main"
  polybarSecondary <- spawnPipe "polybar secondary"

  -- Launches xmobar
  xmobarMain <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
  xmobarSecondary <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc"

  -- xmonad
  xmonad $
    docks $
      ewmhFullscreen $
        ewmh
          def
            { terminal = myTerminal,
              focusFollowsMouse = myFocusFollowsMouse,
              borderWidth = myBorderWidth,
              modMask = myModMask,
              workspaces = myWorkspaces,
              normalBorderColor = myBorderColor,
              focusedBorderColor = myFocusColor,
              -- key bindings
              mouseBindings = myMouseBindings,
              -- hooks, layouts
              layoutHook = myLayoutHook,
              manageHook = myManageHook <+> manageDocks <+> manageSpawn <+> manageHook def,
              handleEventHook = handleEventHook def,
              startupHook = myStartupHook,
              logHook =
                dynamicLogWithPP
                  xmobarPP
                    { ppOutput = \x ->
                        hPutStrLn xmobarMain x
                          >> hPutStrLn xmobarSecondary x,
                      -- Current selected workspace
                      ppCurrent =
                        xmobarColor "#eceff4" ""
                          . wrap
                            "<box type=Bottom width=3 color=#8FBCBB>  "
                            "  </box>"
                          . clickableIconName,
                      ppVisible =
                        xmobarColor "#8FBCBB" ""
                          . wrap
                            "<box type=Bottom width=3 color=#8FBCBB>  "
                            "  </box>"
                          . clickableIcon,
                      ppHidden =
                        xmobarColor "#ECEFF4" ""
                          . wrap
                            "<box type=Bottom width=3 color=#4C566A> "
                            " </box>"
                          . clickableIcon,
                      ppHiddenNoWindows =
                        xmobarColor "#4C566A" ""
                          . wrap
                            " "
                            " "
                          . clickableIcon,
                      ppSep = " | ",
                      ppUrgent = xmobarColor "#BF616A" "" . wrap "!" "!",
                      ppExtras = [windowCount],
                      ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex
                    }
            }
          `additionalKeysP` myKeys
