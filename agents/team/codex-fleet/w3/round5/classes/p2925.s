# n=5 model=out iset=I1 prefix14_class=2925
mov S0, P3
cmp P1, S0
cmovle P3, P1
cmovg S0, P1
cmp P0, P2
cmovle S1, P2
cmovge S1, P0
cmovg P0, P2
cmp S0, S1
mov P1, P3
cmovl S2, S1
cmovle S1, S0
cmovl S0, S2
cmp P0, P3
