--------------------------------------------------------------------------------

#include <bindings.dsl.h>
#include <sophia.h>

--------------------------------------------------------------------------------

module Bindings.Sophia where

import Foreign.Ptr      (FunPtr, Ptr)
import Foreign.C.Types  (CInt(..), CUInt(..), CSize(..), CDouble(..))
import Foreign.C.String (CString)
import Data.Word        (Word32)

#integral_t sporder
#num SPGT
#num SPGTE
#num SPLT
#num SPLTE

#num SPO_RDWR
#num SPO_RDONLY
#num SPO_CREAT
-- Undocumented:
#num SPO_SYNC

type Handle = Ptr ()

type Env = Handle
type Db = Handle
type Cursor = Handle

type Flags = Word32
type ErrorCode = CInt

type Key = Ptr ()
type Val = Ptr ()

#ccall sp_env                       ,                                                                       IO Env
#ccall sp_destroy                   , Handle ->                                                             IO ErrorCode
#ccall sp_open                      , Env ->                                                                IO Db
#ccall sp_error                     , Handle ->                                                             IO CString

#ccall sp_set                       , Db ->  Key -> CSize ->  Val -> CSize ->                               IO ErrorCode

-- Val output param must be free()'d (-1 for err, 0 not found, 1 found)
#ccall sp_get                       , Db ->  Key -> CSize ->  Ptr Val -> Ptr CSize ->                       IO ErrorCode
#ccall sp_delete                    , Db ->  Key -> CSize ->                                                IO ErrorCode

-- Key may or may not be supplied, result must be sp_destroy'd:
#ccall sp_cursor                    , Db ->  <sporder> ->  Key -> CSize ->                                  IO Cursor

#ccall sp_fetch                     , Cursor ->                                                             IO CInt

-- Apparently no need to free result key
#ccall sp_key                       , Cursor ->                                                             IO Key
-- 0 size on error:
#ccall sp_keysize                   , Cursor ->                                                             IO CSize

-- Apparently no need to free result value
#ccall sp_value                     , Cursor ->                                                             IO Val
-- 0 size on error:
#ccall sp_valuesize                 , Cursor ->                                                             IO CSize

-- sp_ctl wrappers from wrappers.c:
#ccall sp_dir                       , Env -> Flags -> CString ->                                            IO ErrorCode

type SpCmpF = FunPtr (CString -> CSize -> CString -> CSize -> Ptr () -> IO CInt)
#ccall sp_set_key_comparison        , Env -> SpCmpF -> Ptr () ->                                            IO ErrorCode

#ccall sp_set_keys_per_page         , Env -> Word32 ->                                                      IO ErrorCode
#ccall sp_set_gc_enabled            , Env -> CInt ->                                                        IO ErrorCode
#ccall sp_set_gcf                   , Env -> CDouble ->                                                     IO ErrorCode
#ccall sp_grow                      , Env -> Word32 -> CDouble ->                                           IO ErrorCode
#ccall sp_set_merge_enabled         , Env -> CInt ->                                                        IO ErrorCode
#ccall sp_set_merge_watermark       , Env -> Word32 ->                                                      IO ErrorCode
#ccall sp_get_version               , Env -> Ptr Word32 -> Ptr Word32 ->                                    IO ErrorCode
