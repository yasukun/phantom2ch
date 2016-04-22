{-# LANGUAGE OverloadedStrings #-}
module Main where

import Phantom2ch.Lib

main :: IO ()
main = do
  path <- tempFilePath
  spitJS path resource
  bbsMenu path "https://www.2ch.sc/bbsmenu.html"
