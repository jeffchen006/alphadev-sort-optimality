# n=5 model=out iset=I1 prefix14_class=5952
cmp P2, P3
mov S2, P3
cmovl S2, P2
cmovg P3, P2
mov S1, P1
cmp S1, P0
cmovle S1, P0
cmovg P1, P0
mov S0, P3
cmp S0, S1
cmovg P3, S1
cmovle S0, S1
mov S0, S2
mov S1, P3
