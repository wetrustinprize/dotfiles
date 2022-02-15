---------------------------------------
-- IMPORTS
---------------------------------------
import qualified Data.Map as M
import Data.Maybe (fromJust)
import System.Exit (ExitCode (ExitSuccess), exitWith)
import XMonad
import XMonad.Actions.CycleWS (WSType (..), moveTo, nextScreen, prevScreen, shiftTo)
import XMonad.Actions.SpawnOn (manageSpawn, spawnHere)
import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks)
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.Spacing (spacing)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (hPutStrLn, spawnPipe)
import XMonad.Util.SpawnOnce (spawnOnce)

myTerminal :: String
myTerminal = "alacritty" -- Sets default terminal

myBrowser :: String
myBrowser = "vivaldi-stable" -- Sets default browser

myIDE :: String
myIDE = "code" -- Sets default IDE

myExplorer :: String
myExplorer = "nautilus" -- Sets default file explorer

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True -- Whether focus follows the mouse pointer.

myBorderWidth :: Dimension
myBorderWidth = 2 -- Width of the window border in pixels.

myModMask :: KeyMask
myModMask = mod4Mask -- Sets modkey to super key

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

--------------------------------------------------
-- WORKSPACES
-- MY workspaces
--------------------------------------------------
myWorkspaces = ["www", "dev", "doc", "soc", "mus", "sys", "vid", "gfx", "etc"]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

--------------------------------------------------
-- COLORS
-- Colors used
--------------------------------------------------
myBorderColor = "#2e3440" -- Normal border color

myFocusColor = "#74B99A" -- Focused border color

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
    ("M-p", spawn "rofi -show run"), -- Run rofi
    ("M-S-p", spawn "rofi -show drun"), -- Run rofi desktop

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
    ("M-e", spawnHere myExplorer),
    -- Layouts
    ("M-<Space>", sendMessage NextLayout), -- Rotate through the available layout algorithms

    -- Print
    ("<Print>", spawn "sleep 0.2; scrot -e 'xclip -selection clipboard -t image/png $f' -s"), -- Selection screenshot
    ("S-<Print>", spawn "sleep 0.2; scrot -e 'xclip -selection clipboard -t image/png $f'"), -- Fullscreen screenshot

    -- Multimedia Keys
    ("<XF86AudioMute>", spawn "amixer -D pulse sset Master toggle"),
    ("<XF86AudioLowerVolume>", spawn "/bin/sh ~/.xmonad/scripts/changevolume.sh -d"),
    ("<XF86AudioRaiseVolume>", spawn "/bin/sh ~/.xmonad/scripts/changevolume.sh"),
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
        ( \w ->
            focus w >> mouseMoveWindow w
              >> windows W.shiftMaster
        )
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        ( \w ->
            focus w >> mouseResizeWindow w
              >> windows W.shiftMaster
        )
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

--------------------------------------------------
-- LAYOUTS
-- [ tiled: Default tiled layout
-- [ full: Shows only one window
-- [ monocle: Shows only one window with no struts
--------------------------------------------------

tiled =
  avoidStruts $
    spacing 3 $
      Tall 1 (3 / 100) (1 / 2)

full =
  avoidStruts $
    spacing 3 $
      Full

monocle =
  noBorders $
    spacing 0 $
      Full

myLayoutHook = renamed [Replace "Tiled"] tiled ||| renamed [Replace "Full"] full ||| renamed [Replace "Monocle"] monocle

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
      -- Will always spawn on Workspace mus
      resource =? "spotify" --> doShift (myWorkspaces !! 4)
    ]

--------------------------------------------------
-- EVENT HANDLING
--------------------------------------------------
myEventHook = mempty

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
  -- Launches xmobar
  polybarMain <- spawnPipe "polybar main"
  polybarSecondary <- spawnPipe "polybar secondary"

  -- xmonad
  xmonad $
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
          manageHook = (isFullscreen --> doFullFloat) <+> myManageHook <+> manageDocks <+> manageSpawn <+> manageHook def,
          handleEventHook = myEventHook <+> docksEventHook <+> ewmhDesktopsEventHook,
          startupHook = myStartupHook,
          logHook = ewmhDesktopsLogHook
        }
      `additionalKeysP` myKeys