# n=5 model=out iset=I1 prefix14_class=2291
mov S1, P3
cmp P2, P1
cmovge S0, P2
cmovg P2, P1
cmovl S0, P1
cmp S1, P0
cmovle P3, P0
cmovge S1, P0
mov S2, S0
cmp P3, S0
cmovle S0, P3
mov P1, S0
cmovg S2, P3
mov S2, S1
