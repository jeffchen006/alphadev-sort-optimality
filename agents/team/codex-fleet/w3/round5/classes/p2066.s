# n=5 model=out iset=I1 prefix14_class=2066
cmp P0, P1
cmovle S0, P1
mov S1, P2
cmovle P1, P0
cmovge S0, P0
cmp P2, P3
cmovg S1, P3
cmovg P3, P2
mov S2, P3
cmp P3, S0
cmovge S2, S0
cmovl P3, S0
mov P2, S2
cmp S1, P1
