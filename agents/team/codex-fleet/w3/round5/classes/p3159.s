# n=5 model=out iset=I1 prefix14_class=3159
mov S0, P2
cmp P0, P3
cmovge S2, P3
cmovle S2, P0
cmovg P3, P0
cmp P2, P1
cmovg P2, P1
cmovge P1, S0
mov S1, S2
cmp S2, P2
cmovle S1, P2
cmovg S2, P2
mov P2, P3
mov S2, S1
