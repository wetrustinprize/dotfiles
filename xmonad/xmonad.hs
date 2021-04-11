---------------------------------------
-- IMPORTS
---------------------------------------

import XMonad
import Data.Monoid
import System.Exit

-- ACTIONS
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.WithAll (killAll, sinkAll)

-- UTILS
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeysP)

-- LAYOUT
import XMonad.Layout.Spacing

-- HOOKS
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, docksEventHook)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal :: String
myTerminal = "konsole" -- Sets default terminal

myBrowser :: String
myBrowser = "firefox" -- Sets default browser

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True -- Whether focus follows the mouse pointer.

myClickJustFocuses :: Bool
myClickJustFocuses = False -- Whether clicking on a window to focus also passes the click to the window

myBorderWidth :: Dimension
myBorderWidth = 1 -- Width of the window border in pixels.

myModMask :: KeyMask
myModMask = mod4Mask -- Sets modkey to super key

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myWorkspaces    = ["www", "dev", "doc", "soc", "mus", "sys", "vid", "gfx", "etc"]

myBorderColor  = "#dddddd" -- Normal border color
myFocusColor = "#ff0000" -- Focused border color

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: [(String, X ())]
myKeys =
    [ 
	-- Xmonad
		  ("M-S-q", io (exitWith ExitSuccess)) -- Quit xmonad
		, ("M-q", spawn "xmonad --recompile; xmonad --restart") -- Restart xmonad
	
	-- Workspaces
		, ("M-.", nextScreen) -- Switch focus to next monitor
		, ("M-,", prevScreen) -- Switch focus to prev monitor
	
	-- Run Prompt
		, ("M-p", spawn "dmenu_run") -- Run demenu

	-- Windows
		, ("M-S-c", kill) -- Kill focused window
		, ("M-S-a", killAll) -- Kill all windows on currento WS
		, ("M-j", windows W.focusDown) -- Focus next window
		, ("M-k", windows W.focusUp  ) -- Focus prev window
		, ("M-m", windows W.focusMaster  ) -- Focus master
		, ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
		, ("M-h", sendMessage Shrink) -- Shrink the master area
		, ("M-l", sendMessage Expand) -- Expand the master area
		, ("M-t", withFocused $ windows . W.sink) -- Push window back into tiling
		, ("M-S-t", sinkAll) -- Push all windows back into tiling
		, ("M-S-<Up>", sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area
		, ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Deincrement the number of windows in the master area

	-- Appliactions
		, ("M-<Return>", spawn $ myTerminal) -- Creates a new Terminal
		, ("M-b", spawn $ myBrowser)

	-- Layouts
		, ("M-<Space>", sendMessage NextLayout) -- Rotate through the available layout algorithms

	-- Multimedia Keys
		, ("<XF86AudioMute>", spawn "amixer -D pulse sset Master toggle")
		, ("<XF86AudioLowerVolume>", spawn "amixer -D pulse sset Master 5%- unmute")
		, ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse sset Master 5%+ unmute")

    ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayoutHook = avoidStruts (tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = spacing 3 $ Tall 1 (3/100) (1/2)

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ resource  =? "bitwarden" --> doFloat
	, resource  =? "gpick" --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop" --> doIgnore 
	, title     =? "Friends List" --> doFloat

	-- Will always spawn on Workspace www
	, title =? "Mozilla Firefox" --> doShift (myWorkspaces !! 0)

	-- Will aways spawn on Workspace soc
	, resource	=? "telegram-desktop" --> doShift (myWorkspaces !! 3)
	, resource	=? "kesty-whatsapp" --> doShift (myWorkspaces !! 3)
	, resource	=? "discord" --> doShift (myWorkspaces !! 3)

	-- Will always spawn on Workspace gfx
	, resource =? "krita" --> doShift (myWorkspaces !! 7)
	]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
	spawnOnce "nitrogen --restore &"
	spawnOnce "picom --xrender-sync-fence --backend glx --experimental-backend --config ~/.config/picom.conf &"
	spawnOnce "dunst &"

	-- Social apps
	spawnOnce "telegram-desktop"
	spawnOnce "discord"

main :: IO ()
main = do
	-- Launches xmobar
	xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"

	-- xmonad
	xmonad $ ewmh def { 
		terminal           = myTerminal,
		focusFollowsMouse  = myFocusFollowsMouse,
		clickJustFocuses   = myClickJustFocuses,
		borderWidth        = myBorderWidth,
		modMask            = myModMask,
		workspaces         = myWorkspaces,
		normalBorderColor  = myBorderColor,
		focusedBorderColor = myFocusColor,

		-- key bindings
		mouseBindings      = myMouseBindings,

		-- hooks, layouts
		layoutHook         = myLayoutHook,
		manageHook         = (isFullscreen --> doFullFloat) <+> myManageHook <+> manageDocks,
		handleEventHook    = myEventHook <+> docksEventHook,
		startupHook        = myStartupHook,
		logHook            = dynamicLogWithPP xmobarPP
			{ ppOutput = \x -> hPutStrLn xmproc x
			, ppCurrent = xmobarColor "#C8AED1" "" . wrap "[" "]"
			, ppVisible = xmobarColor "#9987AD" ""
			, ppHidden = xmobarColor "#74B99A" "" . wrap "*" ""
			, ppHiddenNoWindows = xmobarColor "#C792EA" ""
			, ppTitle = xmobarColor "#B3AFC2" "" . shorten 60
			, ppSep = " | "
			, ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"
			, ppExtras = [windowCount]
			, ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
		}
	} `additionalKeysP` myKeys
