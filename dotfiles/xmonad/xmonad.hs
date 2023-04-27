module Main (main) where

-----------------------------------------------------------------

import           Data.Default                 (def)
import qualified Data.Map.Strict              as M

import           System.Exit                  (ExitCode (..), exitWith)
import           System.IO

import           Data.Bool
import qualified Graphics.X11.ExtraTypes.XF86 as XF86
import           XMonad
import           XMonad.Actions.CycleWS       (nextWS, prevWS)
import           XMonad.Actions.FloatKeys     (keysMoveWindow, keysResizeWindow)
import           XMonad.Actions.Volume
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops    (ewmh)
import           XMonad.Hooks.FloatNext       (floatNextHook, toggleFloatAllNew, toggleFloatNext)
import           XMonad.Hooks.ManageDocks     (ToggleStruts (..), avoidStruts, docks, docksEventHook, manageDocks)
import           XMonad.Hooks.SetWMName       (setWMName)
import           XMonad.Layout.Maximize       (maximize)
import           XMonad.Layout.Maximize       (maximizeRestore)
import           XMonad.Layout.NoBorders      (smartBorders)
import           XMonad.Layout.ResizableTile  (MirrorResize (..), ResizableTall (..))
import           XMonad.Layout.Spacing        (Border (..), spacingRaw, toggleWindowSpacingEnabled)
import qualified XMonad.StackSet              as W
import           XMonad.Util.Dzen
import           XMonad.Util.EZConfig         (additionalKeys)
import           XMonad.Util.Run              (spawnPipe)
import           XMonad.Hooks.UrgencyHook

-----------------------------------------------------------------

myTerminal workspace = "konsole hide-menubar --workdir " <> workspace

myLauncher = "dmenu_run -fn 'Tamzen-10' -nf '#fff' -p ' Search '"

myStatusBar = "xmobar"

modm = mod4Mask -- Windows key

data Workspace = Main | Code | Browser | Chat | Mail | Tmp
  deriving Show

myWorkspaces :: [Workspace]
myWorkspaces =
  [ Main
  , Code
  , Browser
  , Chat
  , Mail
  , Tmp
  ]

myManageHook = composeAll . concat $
    [ [ check c --> doFloat          | c <- myFloats] -- doRectFloat (W.RationalRect 0.3 0.3 0.4 0.4)
    , [ check c --> doShift' Browser | c <- browsers]
    , [ check c --> doShift' Chat    | c <- chats   ]
    , [ check c --> doShift' Mail    | c <- mails   ]
    ]
  where
    -- className: `$ xprop | grep WM_CLASS`
    myFloats = ["Enpass", "Gimp", "zoom", "zoom-us", "vlc", "nomacs", "transgui", "Image Lounge"]
    browsers = ["Firefox", "Chromium-browser"]
    chats    = ["Discord", "Slack"]
    mails    = ["Mail", "thunderbird"]
    doShift' workspace =  doShift (show workspace)
    check x = className =? x <||> title =? x <||> resource =? x

gaps = spacingRaw
         True              -- smartBorder
         (Border 0 0 0 0)  -- screenBorder
         False             -- screenBorderEnabled
         (Border 4 4 4 4)  -- windowBorder (Border top bottom right left)
         True              -- windowBorderEnabled

myLayout = maximize (ResizableTall 1 (3 / 100) (1 / 2) [] ||| Full)

-- TODO doesn't work
alert :: String -> X ()
alert = dzenConfig centered
  where
    centered = onCurr (center 150 66)
                >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
                >=> addArgs ["-fg", "#80c0ff"]
                >=> addArgs ["-bg", "#000040"]

alertDouble :: Double -> X ()
alertDouble = alert . show . round

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig { XMonad.modMask = modMask }) =
  M.fromList $
       -- Start terminal & Start search
       [ ( (modm, xK_Return)                , spawn (myTerminal "/etc/nixos"))
       , ( (modm, xK_p)                     , spawn myLauncher)

       -- Focus
       , ( (modm, xK_Tab)              , nextWS             )
       , ( (modm .|. shiftMask, xK_Tab), prevWS             )
       , ( (modm, xK_j)                , windows W.focusDown)
       , ( (modm, xK_k)                , windows W.focusUp  )
       , ( (modm, xK_h)                , windows W.focusDown)
       , ( (modm, xK_l)                , windows W.focusUp  )

       -- Shrink/Expand
       , ( (modm .|. shiftMask, xK_h), sendMessage Shrink      )
       , ( (modm .|. shiftMask, xK_l), sendMessage Expand      )
       , ( (modm .|. shiftMask, xK_j), sendMessage MirrorShrink)
       , ( (modm .|. shiftMask, xK_k), sendMessage MirrorExpand)

       -- Swap Windows
       , ( (modm .|. controlMask, xK_h), windows W.swapDown  )
       , ( (modm .|. controlMask, xK_l), windows W.swapUp    )
       , ( (modm, xK_m)                , windows W.swapMaster)

       -- Increment the number of windows in the master area
       , ( (modm, xK_comma) , sendMessage (IncMasterN 1)   )
       , ( (modm, xK_period), sendMessage (IncMasterN (-1)))

       -- Toggle show xmobar and spacing
       , ( (modm, xK_b) , sendMessage ToggleStruts  ) -- xmobar toggle
       , ( (modm , xK_s), toggleWindowSpacingEnabled)

       -- Layout rotate & Layout reset.
       , ( (modm, xK_space), sendMessage NextLayout                          )
       , ( (modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

       -- Windows back to tiling
       , ( (modm, xK_t), withFocused $ windows . W.sink)

       -- Close window & close status bar
       , ( (modm .|. shiftMask, xK_c), kill                                )
       , ( (modm .|. shiftMask, xK_x), spawn "kill $(pidof xmobar); xmobar")

       -- Floating Window
       , ( (modm, xK_f), withFocused (sendMessage . maximizeRestore))
       , ( (modm, xK_e), toggleFloatNext)
       , ( (modm .|. shiftMask, xK_e), toggleFloatAllNew) -- toggle fullscreen
       , ( (modm, xK_equal), withFocused (keysMoveWindow (-1, -30)))
       , ( (modm, xK_apostrophe), withFocused (keysMoveWindow (-1, 30)))
       , ( (modm, xK_bracketright), withFocused (keysMoveWindow (30, 0)))
       , ( (modm, xK_bracketleft), withFocused (keysMoveWindow (-30, 0)))
       , ( (controlMask .|. shiftMask, xK_m), withFocused $ keysResizeWindow (0, -15) (0, 0))
       , ( (controlMask .|. shiftMask, xK_comma), withFocused $ keysResizeWindow (0, 15) (0, 0))

       -- Volumne
       , ( (0, XF86.xF86XK_AudioMute)       , toggleMute    >> return ())
       , ( (0, XF86.xF86XK_AudioLowerVolume), lowerVolume 5 >> return ())
       , ( (0, XF86.xF86XK_AudioRaiseVolume), raiseVolume 5 >> return ())

       -- Screen brightness
       , ( (0, XF86.xF86XK_MonBrightnessUp)  , spawn "brightnessctl set +10%")
       , ( (0, XF86.xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")

       -- Toogle micro

      -- Focus Urgent
       , ( (modMask, xK_BackSpace), focusUrgent)

      -- Workspace management
       ] ++ [ ((m .|. modMask, k), windows $ f i)
            | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
            ]

myAdditionalKeys =
  [
  -- Clipboard manager
    ((controlMask .|. shiftMask, xK_v), spawn "clipmenu")
  -- Locking the screen: Shift + Meta + z
  , ((modm .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
  -- Sreenshot
  , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -q 100 ~/Screenshots/$(date +'%Y-%b-%d-%s').png")
  , ((0, xK_Print), spawn "scrot -q 100 ~/Screenshots/$(date +'%Y-%b-%d-%s').png")
  ]

defaults xmproc = def
  { borderWidth = 2
  , normalBorderColor  = "#BFBFBF"
  , focusedBorderColor = "#89DDFF"
  , keys       = myKeys
  , modMask    = modm
  , terminal   = myTerminal "/etc/nixos"
  , workspaces = show <$> myWorkspaces
  , manageHook = manageDocks <+> floatNextHook <+> myManageHook <+> manageHook def
  , layoutHook = avoidStruts $ gaps $ smartBorders $ myLayout
  , handleEventHook = handleEventHook def <+> docksEventHook
  , focusFollowsMouse = False
  , logHook = dynamicLogWithPP def
                { ppOutput = hPutStrLn xmproc
                , ppCurrent = xmobarColor "darkorange" ""
                , ppHidden = xmobarColor "white" ""
                , ppHiddenNoWindows = xmobarColor "grey" ""
                , ppUrgent  = xmobarColor "red" ""
                , ppSep = " | "
                , ppWsSep = " "
                , ppTitle = xmobarColor "darkgreen" "" . shorten 40
                }
  }

main = do
    xmproc <- spawnPipe myStatusBar
    xmonad
      $ ewmh
      $ docks
      -- https://hackage.haskell.org/package/xmonad-contrib-0.8/docs/XMonad-Hooks-UrgencyHook.html
      $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }
      $ defaults xmproc `additionalKeys` myAdditionalKeys
