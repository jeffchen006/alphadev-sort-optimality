# n=5 model=out iset=I1 prefix14_class=6607
mov S0, P3
cmp P2, S0
cmovl P3, P2
cmovge S0, P2
mov P2, P3
mov S2, S0
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp S0, P0
cmovle S0, P0
cmovg S2, P0
cmp P1, P2
