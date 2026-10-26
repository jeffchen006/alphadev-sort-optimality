# n=5 model=out iset=I1 prefix14_class=7186
cmp P1, P2
mov S2, P0
cmovg S1, P2
cmovg P2, P1
cmovg P1, S1
cmp S2, P3
cmovge P0, P3
cmovle S2, P3
mov S0, S2
mov P3, P0
cmp P0, P1
cmovge P3, P1
cmovg P1, P0
mov P0, P1
