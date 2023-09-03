module Main where

import Xmobar (configFromArgs, xmobar)
import Xmobar.Config (mkConfig)

main :: IO ()
main = xmobar =<< configFromArgs =<< mkConfig
