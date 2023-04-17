module core.arsd.objectutils;

///Provides only __doPostblit and hasPostblit for making the code simpler.
size_t structTypeInfoSize(const TypeInfo ti) pure nothrow @nogc {
    if (ti && typeid(ti) is typeid(TypeInfo_Struct)) // avoid a complete dynamic type cast
    {
        auto sti = cast(TypeInfo_Struct) cast(void*) ti;
        if (sti.xdtor)
            return size_t.sizeof;
    }
    return 0;
}
// strip const/immutable/shared/inout from type info
inout(TypeInfo) unqualify(return scope inout(TypeInfo) cti) pure nothrow @nogc {
    TypeInfo ti = cast() cti;
    while (ti) {
        // avoid dynamic type casts
        auto tti = typeid(ti);
        if (tti is typeid(TypeInfo_Const))
            ti = (cast(TypeInfo_Const) cast(void*) ti).base;
        else if (tti is typeid(TypeInfo_Invariant))
            ti = (cast(TypeInfo_Invariant) cast(void*) ti).base;
        else if (tti is typeid(TypeInfo_Shared))
            ti = (cast(TypeInfo_Shared) cast(void*) ti).base;
        else if (tti is typeid(TypeInfo_Inout))
            ti = (cast(TypeInfo_Inout) cast(void*) ti).base;
        else
            break;
    }
    return ti;
}

bool hasPostblit(in TypeInfo ti) nothrow pure {
    return (&ti.postblit).funcptr !is &TypeInfo.postblit;
}

void __doPostblit(void* ptr, size_t len, const TypeInfo ti) {
    if (!hasPostblit(ti))
        return;

    if (auto tis = cast(TypeInfo_Struct) ti) {
        // this is a struct, check the xpostblit member
        auto pblit = tis.xpostblit;
        if (!pblit) // postblit not specified, no point in looping.
            return;

        // optimized for struct, call xpostblit directly for each element
        immutable size = ti.size;
        const eptr = ptr + len;
        for (; ptr < eptr; ptr += size)
            pblit(ptr);
    } else {
        // generic case, call the typeinfo's postblit function
        immutable size = ti.size;
        const eptr = ptr + len;
        for (; ptr < eptr; ptr += size)
            ti.postblit(ptr);
    }
}
