# n=5 model=out iset=I1 prefix14_class=7974
cmp P3, P0
mov S0, P3
cmovge S0, P0
cmovg P0, P3
mov S1, P1
cmp P1, P2
cmovl P1, P2
cmovge S1, P2
mov S2, S1
cmp S0, S1
cmovg S1, S0
cmovle S2, S0
cmp P0, P1
cmovle P3, P0
