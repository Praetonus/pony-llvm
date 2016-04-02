
class Value is _Ref
  let _ptr: _Ptr
  fun _p(): _Ptr => _ptr
  new _from_p(ptr': _Ptr) => _ptr = ptr'
  
  fun string(): String =>
    _Message.copy_in(@LLVMPrintValueToString[Pointer[U8] val](_p()))
  
  fun get_type(): this->Type! =>
    let p = @LLVMTypeOf[_Ptr](_p())
    recover _TypeUtil._from_p(p) end
  
  fun name(): String =>
    let cstr = @LLVMGetValueName[Pointer[U8] val](_p())
    recover String.copy_cstring(cstr) end
  
  fun ref set_name(name': String box) =>
    @LLVMSetValueName[None](_p(), _Message.copy_out(name'))
  
  fun is_constant(): Bool =>
    0 != @LLVMIsConstant[I32](_p())
  
  fun is_undef(): Bool =>
    0 != @LLVMIsUndef[I32](_p())
  
  fun replace_all_uses_with(that: Value box) =>
    @LLVMReplaceAllUsesWith[None](_p(), that._p())
  
  fun uses(): Iterator[this->Use!]^ =>
    let p = @LLVMGetFirstUse[_Ptr](_p())
    _RefIterator[this->Use](p, recover lambda tag(ptr': _Ptr): _Ptr =>
      @LLVMGetNextUse[_Ptr](ptr')
    end end)
