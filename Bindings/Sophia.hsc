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

#ccall_unsafe sp_env                       ,                                                                       IO Env
#ccall_unsafe sp_destroy                   , Handle ->                                                             IO ErrorCode
#ccall_unsafe sp_open                      , Env ->                                                                IO Db
#ccall_unsafe sp_error                     , Handle ->                                                             IO CString

#ccall_unsafe sp_set                       , Db ->  Key -> CSize ->  Val -> CSize ->                               IO ErrorCode

-- Val output param must be free()'d (-1 for err, 0 not found, 1 found)
#ccall_unsafe sp_get                       , Db ->  Key -> CSize ->  Ptr Val -> Ptr CSize ->                       IO ErrorCode
#ccall_unsafe sp_delete                    , Db ->  Key -> CSize ->                                                IO ErrorCode

-- Key may or may not be supplied, result must be sp_destroy'd:
#ccall_unsafe sp_cursor                    , Db ->  <sporder> ->  Key -> CSize ->                                  IO Cursor

#ccall_unsafe sp_fetch                     , Cursor ->                                                             IO CInt

-- Apparently no need to free result key
#ccall_unsafe sp_key                       , Cursor ->                                                             IO Key
-- 0 size on error:
#ccall_unsafe sp_keysize                   , Cursor ->                                                             IO CSize

-- Apparently no need to free result value
#ccall_unsafe sp_value                     , Cursor ->                                                             IO Val
-- 0 size on error:
#ccall_unsafe sp_valuesize                 , Cursor ->                                                             IO CSize

-- sp_ctl wrappers from wrappers.c:
#ccall_unsafe sp_dir                       , Env -> Flags -> CString ->                                            IO ErrorCode

type SpCmpF = FunPtr (CString -> CSize -> CString -> CSize -> Ptr () -> IO CInt)
#ccall_unsafe sp_set_key_comparison        , Env -> SpCmpF -> Ptr () ->                                            IO ErrorCode

#ccall_unsafe sp_set_keys_per_page         , Env -> Word32 ->                                                      IO ErrorCode
#ccall_unsafe sp_set_gc_enabled            , Env -> CInt ->                                                        IO ErrorCode
#ccall_unsafe sp_set_gcf                   , Env -> CDouble ->                                                     IO ErrorCode
#ccall_unsafe sp_grow                      , Env -> Word32 -> CDouble ->                                           IO ErrorCode
#ccall_unsafe sp_set_merge_enabled         , Env -> CInt ->                                                        IO ErrorCode
#ccall_unsafe sp_set_merge_watermark       , Env -> Word32 ->                                                      IO ErrorCode
#ccall_unsafe sp_get_version               , Env -> Ptr Word32 -> Ptr Word32 ->                                    IO ErrorCode
