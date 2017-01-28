--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import           XMonad
import           Data.Monoid
import           System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import           XMonad.Actions.CycleWS(toggleWS, moveTo, shiftTo, Direction1D(Next,Prev), WSType(NonEmptyWS, EmptyWS))
import           XMonad.Actions.SpawnOn(manageSpawn)
import           XMonad.Layout.NoBorders(smartBorders, noBorders)
import           XMonad.Layout.Fullscreen(fullscreenEventHook)
import qualified XMonad.Layout.Tabbed as T
import           XMonad.Layout.Renamed(renamed, Rename(Replace))
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageHelpers(isFullscreen, doFullFloat)
import           XMonad.Hooks.ManageDocks(manageDocks)
import           XMonad.Hooks.FadeInactive(fadeInactiveLogHook)

font     :: String
black    :: String
gray     :: String
normal   :: String
darkgray :: String
white    :: String

font     = "Terminus (TTF):pixelsize=24:antialias=true"
black    = "#0e0e0e"
darkgray = "#1a1a1a"
gray     = "#404040"
normal   = "#909090"
white    = "#a8a8a8"

backlightPath :: String
backlightPath = "radeon_bl0" -- radeon
-- backlightPath = "acpi_video0" -- catalyst

audioDevice :: String
audioDevice = "Master"

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "urxvtc -e tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [String]
myWorkspaces = ["一","二","三","四","五","六","七","八","九","十"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: String
myNormalBorderColor  = "#000000"

myFocusedBorderColor :: String
myFocusedBorderColor = "#000000"

myExec :: String
myExec = "dmenu_run -h 24 -i "
         ++ "-sb '" ++ darkgray ++ "' "
         ++ "-sf '" ++ normal ++ "' "
         ++ "-nb '" ++ black ++ "' "
         ++ "-nf '" ++ normal ++ "' "
         ++ "-fn '" ++ font ++ "' "

notify :: String -> String
notify what = " && notify-send.sh -r 1255 -u low " ++ what

backlight :: String
backlight = "backlight:$(echo \"`cat /sys/class/backlight/"
            ++ backlightPath ++ "/brightness`*100/255\" | bc)"

alsaInfo :: String
alsaInfo = audioDevice ++ ":$(amixer get " ++ audioDevice ++ " | grep -o -e \"[0-9]*[0-9]%\")"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf @ XConfig {XMonad.modMask = modm} = M.fromList $
    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
    -- launch dmenu
    , ((modm,               xK_x     ), spawn myExec)
    -- close focused window
    , ((modm ,              xK_q     ), kill)
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask, xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp  )
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster)
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
    , ((modm .|. shiftMask, xK_q      ), io exitSuccess)
    -- Recompile ++ Restart xmonad
    , ((modm, xK_BackSpace            ), spawn "xmonad --restart")
    -- Cycles WS block (move between workspace)
    , ((modm, xK_grave                ), toggleWS)
    , ((modm .|. controlMask, xK_l              ), moveTo Next NonEmptyWS)
    , ((modm .|. controlMask, xK_h              ), moveTo Prev NonEmptyWS)
    , ((modm .|. controlMask .|. shiftMask, xK_l), shiftTo Next NonEmptyWS >> moveTo Next NonEmptyWS)
    , ((modm .|. controlMask .|. shiftMask, xK_h), shiftTo Prev NonEmptyWS >> moveTo Prev NonEmptyWS)
    -- more useless stuff
    , ((modm .|. controlMask, xK_Right          ), moveTo Next EmptyWS)
    , ((modm .|. controlMask, xK_Left           ), moveTo Prev EmptyWS)
    , ((modm .|. controlMask .|. shiftMask, xK_Right), shiftTo Next EmptyWS >> moveTo Next NonEmptyWS)
    , ((modm .|. controlMask .|. shiftMask, xK_Left ), shiftTo Prev EmptyWS >> moveTo Prev NonEmptyWS)
    -- keys set to ...
    , ((modm,                 xK_equal), spawn $ "amixer set " ++ audioDevice ++ " 1+" ++ notify alsaInfo)
    , ((modm,                 xK_minus), spawn $ "amixer set " ++ audioDevice ++ " 1-" ++ notify alsaInfo)
    -- locking window
    , ((modm,                 xK_F12), spawn "slock")
    -- Special Xorg Keys (FN Keys) (see xev)
    -- (fn f3)  XF86Sleep
    , ((0, 0x1008ff2f), spawn "")
    -- (fn f4)  XF86Display
    , ((0, 0x1008ff59), spawn "touchpad.onoff") -- touchpad because it look like it.
    -- (fn f6)  XF86AudioLowerVolume
    , ((0, 0x1008ff11), spawn $ "amixer set " ++ audioDevice ++ " 1-" ++ notify alsaInfo)
    -- (fn f7)  XF86AudioRaiseVolume
    , ((0, 0x1008ff13), spawn $ "amixer set " ++ audioDevice ++ " 1+" ++ notify alsaInfo)
    -- (fn f8)  XF86Battery
    , ((0, 0x1008ff93), spawn "xset dpms force off")
    -- (fn f9)  XF86MonBrightnessDown
    , ((0, 0x1008ff03), spawn $ "backlight.radeon.down" ++ notify backlight )
    -- (fn f10) XF86MonBrightnessUp
    , ((0, 0x1008ff02), spawn $ "backlight.radeon.up" ++ notify backlight )
    -- (fn f11) NoSymbol
    -- (fn ins) XF86ScrollLock
    , ((0, 0xff14    ), spawn "")
    -- (fn imp) XF86Print
    , ((0, 0xff61    ), spawn "screenshot")
    -- (fn Pau) XF86Pause
    , ((0, 0xff13    ), spawn "")
    -- XF86MonCalculator
    , ((0, 0x1008ff1d), spawn "urxvtc -name bc -e bc")
    -- XF86HomePage
    , ((0, 0x1008ff18), spawn "vimb")
    -- XF86AudioMute
    , ((0, 0x1008ff12), spawn "alsa.mute")
    ] ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
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
myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
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
myLayout =     renamed [Replace "塚"] (smartBorders (T.tabbed T.shrinkText tTheme))
           ||| renamed [Replace "零"] (noBorders Full)
           ||| renamed [Replace "側"] (smartBorders tiled)
           ||| renamed [Replace "次"] (smartBorders (Mirror tiled))
  where
      -- names = [Replace "nF", Replace "nT", Replace "nt", Replace "it"]
      -- default tiling algorithm partitions the screen into two panes
      tiled   = Tall nmaster delta ratio
      -- The default number of windows in the master pane
      nmaster = 1
      -- Default proportion of screen occupied by master pane
      ratio   = 4/7
      -- Percent of screen to increment by when resizing panes
      delta   = 5/100
      -- tabbed colors
      tTheme = T.Theme { T.inactiveBorderColor = darkgray
                       , T.inactiveColor       = darkgray
                       , T.inactiveTextColor   = darkgray
                       , T.activeTextColor     = gray
                       , T.activeBorderColor   = gray
                       , T.activeColor         = gray
                       , T.urgentColor         = white
                       , T.urgentTextColor     = black
                       , T.urgentBorderColor   = white
                       , T.decoWidth           = 0
                       , T.decoHeight          = 4
                       , T.windowTitleAddons   = []
                       , T.windowTitleIcons    = []
                       , T.fontName            = font
                       }

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

myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ manageDocks
    , isFullscreen                  --> doFullFloat
    , className =? "Wine"           --> doFloat
    , className =? "Gmrun"          --> doFloat
    , title     =? "Print"          --> doFloat
    , className =? "bc"             --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , manageHook def
    , manageSpawn ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook :: Event -> X All
myEventHook = handleEventHook def <+> fullscreenEventHook -- seem not to work corectly

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: X()
myLogHook = fadeInactiveLogHook fadeAmount
       where fadeAmount = 0.85

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X()
myStartupHook = return ()

-- Command to launch the bar.
myBar :: String
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP :: PP
myPP = xmobarPP { ppCurrent = xmobarColor normal gray     . wrap "  " "  "
                , ppHidden  = xmobarColor normal ""       . wrap "  " "  "
                , ppUrgent  = xmobarColor black  white    . wrap "  " "  "
                , ppSep     = xmobarColor gray   ""         ""
                , ppWsSep   = ""
                , ppLayout  = xmobarColor normal darkgray . wrap "  " "  "
                , ppTitle   = xmobarColor normal "" . wrap "  " "" . take 42 }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig {XMonad.modMask = mymodMask} = (mymodMask, xK_b)

-- Main configuration, override the defaults to your liking.
-- myConfig :: XConfig (Layout...)
myConfig = def {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    clickJustFocuses   = myClickJustFocuses,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,
    -- hooks, layouts
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    handleEventHook    = myEventHook,
    logHook            = myLogHook,
    startupHook        = myStartupHook
}

-- The main function.
main :: IO()
main = statusBar myBar myPP toggleStrutsKey myConfig >>= xmonad
