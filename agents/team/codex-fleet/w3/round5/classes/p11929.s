# n=5 model=out iset=I1 prefix14_class=11929
mov S2, P3
cmp P2, S2
cmovl P3, P2
cmovge S2, P2
mov S1, P0
cmp P0, P1
cmovle S1, P1
cmovg P0, P1
cmp S2, S1
cmovge P2, S1
cmovg S1, S2
cmovg S2, P2
cmp P3, P0
cmovge P2, P0
