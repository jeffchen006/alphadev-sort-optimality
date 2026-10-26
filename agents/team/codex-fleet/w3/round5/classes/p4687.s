# n=5 model=out iset=I1 prefix14_class=4687
mov S2, P3
cmp P2, P0
mov S0, P0
cmovg P0, P2
cmovle S0, P2
mov S1, S0
cmp S2, P1
cmovl S2, P1
cmovg P3, P1
cmp P0, S2
cmovge P2, S2
cmovg S2, P0
cmovg P0, P2
cmp S0, P3
