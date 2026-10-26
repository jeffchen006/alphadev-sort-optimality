# n=5 model=out iset=I1 prefix14_class=3155
mov S1, P3
cmp P0, P3
cmovle S1, P0
mov S0, P2
cmovg P3, P0
cmp P2, P1
cmovg S0, P1
mov S2, S0
cmovg P1, P2
cmp S0, S1
cmovge S2, S1
cmovl S0, S1
mov P0, P1
mov S2, S0
