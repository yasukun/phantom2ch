{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE LambdaCase #-}
module Phantom2ch.Lib
    ( someFunc
    ) where

import Prelude hiding (writeFile)
import System.Process (readProcess)
import Data.Attoparsec.Text
import Data.Aeson
import Control.Applicative
import System.Directory (getUserDocumentsDirectory, createDirectoryIfMissing, doesFileExist)
import qualified Data.ByteString as B (writeFile, ByteString)
import Data.FileEmbed (embedFile)
import System.FilePath.Posix (joinPath, dropFileName)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

resource :: B.ByteString
resource = $(embedFile "res/req.js")
-- resource = $(embedFile "src/Phantom2ch/res/req.js")

tempFilePath :: IO FilePath
tempFilePath = do
  docroot <- getUserDocumentsDirectory
  return $ joinPath [docroot, ".phantom2ch", "req.js"]

spitJS :: IO FilePath -> B.ByteString -> IO ()
spitJS filepath content = do
  path <- filepath
  doesFileExist path >>= \case
            True ->  return ()
            False -> do
              createDirectoryIfMissing True (dropFileName path)
              B.writeFile path content

bbsMenu url = do
  let x = readProcess "phantomjs" ["/tmp/webp.js"] []
  y <- x
  print y
