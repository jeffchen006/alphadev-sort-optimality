# n=5 model=out iset=I1 prefix14_class=156
mov S2, P0
mov S0, P3
cmp S0, P1
cmovg S0, P1
cmovl P3, P1
cmp P2, S2
cmovle P0, P2
cmovl P2, S2
cmp S0, P0
cmovle S1, P0
cmovge S1, S0
cmovge S0, P0
mov S2, P2
mov P0, S1
