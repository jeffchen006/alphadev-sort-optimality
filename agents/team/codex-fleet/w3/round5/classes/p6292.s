# n=5 model=out iset=I1 prefix14_class=6292
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovle S0, P1
mov S1, P3
cmp P2, P3
cmovg S1, P2
cmovg P2, P3
mov S2, P0
cmp S2, S1
cmovle S2, S1
cmovl S1, P0
cmp S0, P2
mov P0, S0
