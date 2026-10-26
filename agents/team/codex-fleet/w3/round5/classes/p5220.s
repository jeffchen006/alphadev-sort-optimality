# n=5 model=out iset=I1 prefix14_class=5220
mov S1, P0
cmp S1, P1
cmovg P0, P1
cmovle S1, P1
cmp P2, P3
mov S0, P2
cmovge S0, P3
cmovl P2, P3
cmp S0, P0
mov S2, S0
cmovg S0, P0
cmovg P0, S2
cmp S1, P2
mov P1, P0
