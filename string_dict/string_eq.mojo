from memory import UnsafePointer

# fn eq(a: StaticString, b: String) -> Bool:
@always_inline
fn eq(a: String, b: String) -> Bool:
    var l = len(a)
    if l != len(b):
        return False
    var p1 = UnsafePointer(a.unsafe_ptr())
    var p2 = UnsafePointer(b.unsafe_ptr())
    var offset = 0
    alias step = 16
    while l - offset >= step and (p1.load[width=step](offset) == p2.load[width=step](offset)).reduce_and():
        offset += step
    if l - offset >= step:
        return False
    while l - offset > 0 and p1.load(offset) == p2.load(offset):
        offset += 1
    return l - offset == 0
