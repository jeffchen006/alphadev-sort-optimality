# n=5 model=out iset=I1 prefix14_class=259
cmp P0, P1
mov S2, P0
cmovg P0, P1
mov S1, P3
cmovg P1, S2
cmovg S2, P0
cmp P2, P3
cmovge P3, P2
cmovle S1, P2
cmp S1, S2
cmovl S2, S1
cmovl S1, P0
mov S0, S1
mov P2, P3
