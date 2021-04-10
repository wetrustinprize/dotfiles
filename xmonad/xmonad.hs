---------------------------------------
-- IMPORTS
---------------------------------------

import XMonad
import Data.Monoid
import System.Exit

-- UTILS
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

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

myWorkspaces    = ["0","2","3","4","5","6","7","8","9"]

myBorderColor  = "#dddddd" -- Normal border color
myFocusColor = "#ff0000" -- Focused border color

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p	 ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


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
    [ resource  =? "bitwarden"      --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
	, title     =? "Friends List"   --> doFloat ]

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
	spawnOnce "compton &"
	spawnOnce "dunst &"

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
		keys               = myKeys,
		mouseBindings      = myMouseBindings,

		-- hooks, layouts
		layoutHook         = myLayoutHook,
		manageHook         = (isFullscreen --> doFullFloat) <+> myManageHook <+> manageDocks,
		handleEventHook    = myEventHook <+> docksEventHook,
		startupHook        = myStartupHook,
		logHook            = dynamicLogWithPP xmobarPP
			{ ppOutput = \x -> hPutStrLn xmproc x
			, ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"
			, ppVisible = xmobarColor "#98be65" ""
			, ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""
			, ppHiddenNoWindows = xmobarColor "#C792EA" ""
			, ppTitle = xmobarColor "#B3AFC2" "" . shorten 60
			, ppSep = " | "
			, ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"
			, ppExtras = [windowCount]
			, ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
		}
	}
