{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

{-|
Module: DearImGui.SDL3.Vulkan

Initialising the Vulkan backend for Dear ImGui using SDL3.
-}

module DearImGui.SDL3.Vulkan
  ( sdl3InitForVulkan )
  where

-- inline-c
import qualified Language.C.Inline as C

-- inline-c-cpp
import qualified Language.C.Inline.Cpp as Cpp

-- sdl3
import SDL3.Video
  ( SDLWindow(..) )

-- transformers
import Control.Monad.IO.Class ( MonadIO, liftIO )

import Foreign (castPtr)


C.context Cpp.cppCtx
C.include "imgui.h"
C.include "backends/imgui_impl_vulkan.h"
C.include "backends/imgui_impl_sdl3.h"
C.include "<SDL3/SDL.h>"
C.include "<SDL3/SDL_vulkan.h>"
Cpp.using "namespace ImGui"


-- | Wraps @ImGui_ImplSDL3_InitForVulkan@.
sdl3InitForVulkan :: MonadIO m => SDLWindow -> m Bool
sdl3InitForVulkan (SDLWindow windowPtr) = liftIO do
  let ptr = castPtr windowPtr
  ( 0 /= ) <$> [C.exp| bool { ImGui_ImplSDL3_InitForVulkan((SDL_Window*)$(void* ptr)) } |]
