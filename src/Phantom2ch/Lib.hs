{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE LambdaCase #-}
module Phantom2ch.Lib
    ( bbsMenu
    , tempFilePath
    , spitJS
    , resource
    ) where

import Prelude hiding (writeFile, takeWhile)
import System.Process (readProcess)
import Data.Attoparsec.Text
import qualified Data.Text as T (Text, pack)
import Data.Aeson
import Control.Applicative ((<$>), (<|>), (<*>), (<*), (*>))
import System.Directory (getUserDocumentsDirectory, createDirectoryIfMissing, doesFileExist)
import qualified Data.ByteString as B (writeFile, ByteString)
import Data.FileEmbed (embedFile)
import System.FilePath.Posix (joinPath, dropFileName)
import Text.HTML.TagSoup

resource :: B.ByteString
resource = $(embedFile "res/req.js")
-- resource = $(embedFile "src/Phantom2ch/res/req.js")

tempFilePath :: IO FilePath
tempFilePath = do
  docroot <- getUserDocumentsDirectory
  return $ joinPath [docroot, ".phantom2ch", "req.js"]

spitJS :: FilePath -> B.ByteString -> IO ()
spitJS path content = do
  doesFileExist path >>= \case
            True ->  return ()
            False -> do
              createDirectoryIfMissing True (dropFileName path)
              B.writeFile path content

bbsMenu :: String -> String -> IO ()
bbsMenu js url = do
  let x = readProcess "phantomjs" [js, url] []
  y <- x
  putStrLn y

-- <a href="http://sweet.2ch.sc/kawaii/">テスト用野原</a><br>
-- let x = "<a href=\"http://sweet.2ch.sc/kawaii/\">テスト用野原</a>"

data BBSMenu = BBSMenu {
      title :: T.Text
    , url :: T.Text
    } deriving (Show)

aParse :: Parser BBSMenu
aParse = BBSMenu <$> (string "<a href=" *> char '"' *> takeWhile (/= '"') <* char '"')
                 <*> (char '>' *> takeWhile (/= '<') <* string "</a>")
                 <?> "BBSMenu"

-- bbsMenuParse :: Parser [BBSMenu]
-- bbsMenuParse = many1 $ ((many1 anyChar) *> aParse <* (many1 anyChar)) <* endOfLine
