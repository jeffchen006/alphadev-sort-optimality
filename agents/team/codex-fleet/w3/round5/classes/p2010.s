# n=5 model=out iset=I1 prefix14_class=2010
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovg P1, S2
mov S2, P2
cmp S2, P0
cmovg P2, P0
cmovle S2, P0
cmovge P0, S2
cmp P3, S2
cmovge P0, P3
cmovg P3, S2
cmp P1, P2
mov S2, P3
