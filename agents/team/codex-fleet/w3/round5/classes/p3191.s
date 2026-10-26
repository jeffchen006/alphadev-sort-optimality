# n=5 model=out iset=I1 prefix14_class=3191
mov S2, P2
cmp P0, P2
cmovle S2, P0
cmovge P2, P0
cmp P3, P1
cmovg S0, P3
cmovg P3, P1
cmovg P1, S0
cmp S2, P3
mov P0, S2
cmovg P0, P3
cmovl S2, P3
cmovg P3, S2
cmp P2, P1
