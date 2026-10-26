# n=5 model=out iset=I1 prefix14_class=2923
mov S1, P3
cmp P0, P3
cmovle P3, P0
mov S0, P2
cmovg S1, P0
cmp P1, S0
cmovge S0, P1
mov P0, S0
cmovg P1, P2
cmp S1, P0
cmovl S0, S1
cmovle S1, P0
mov S2, S0
cmp P1, P3
