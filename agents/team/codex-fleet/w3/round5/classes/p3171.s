# n=5 model=out iset=I1 prefix14_class=3171
mov S2, P1
cmp P3, S2
cmovle S2, P3
cmovg P1, P3
cmp P0, P2
cmovge P3, P0
cmovg P0, P2
cmovge P2, P3
mov S1, S2
cmp S2, P0
cmovl S2, P0
cmovg S1, P0
mov S0, P1
cmp P2, P1
