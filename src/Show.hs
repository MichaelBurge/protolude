{-# LANGUAGE Trustworthy #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Show (
  Print(..),
  putText,
  putLText,
  putByteString,
  putLByteString,
) where

import qualified Base
import qualified System.IO as Base
import Data.Function ((.))

import Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BL

import qualified Data.Text as T
import qualified Data.Text.IO as T

import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.IO as TL

import System.IO (Handle, stdout)


class Print a where
  hPutStr :: MonadIO m => Handle -> a -> m ()
  putStr :: MonadIO m => a -> m ()
  putStr = hPutStr stdout
  hPutStrLn :: MonadIO m => Handle -> a -> m ()
  putStrLn :: MonadIO m => a -> m ()
  putStrLn = hPutStrLn stdout

instance Print T.Text where
  hPutStr = \h -> liftIO . T.hPutStr h
  hPutStrLn = \h -> liftIO . T.hPutStrLn h

instance Print TL.Text where
  hPutStr = \h -> liftIO . TL.hPutStr h
  hPutStrLn = \h -> liftIO . TL.hPutStrLn h

instance Print BS.ByteString where
  hPutStr = \h -> liftIO . BS.hPutStr h
  hPutStrLn = \h -> liftIO . BS.hPutStrLn h

instance Print BL.ByteString where
  hPutStr = \h -> liftIO . BL.hPutStr h
  hPutStrLn = \h -> liftIO . BL.hPutStrLn h

instance Print [Base.Char] where
  hPutStr = \h -> liftIO . Base.hPutStr h
  hPutStrLn = \h -> liftIO . Base.hPutStrLn h

-- For forcing type inference
putText :: MonadIO m => T.Text -> m ()
putText = putStrLn
{-# SPECIALIZE putText :: T.Text -> Base.IO () #-}

putLText :: MonadIO m => TL.Text -> m ()
putLText = putStrLn
{-# SPECIALIZE putLText :: TL.Text -> Base.IO () #-}

putByteString :: MonadIO m => BS.ByteString -> m ()
putByteString = putStrLn
{-# SPECIALIZE putByteString :: BS.ByteString -> Base.IO () #-}

putLByteString :: MonadIO m => BL.ByteString -> m ()
putLByteString = putStrLn
{-# SPECIALIZE putLByteString :: BL.ByteString -> Base.IO () #-}
