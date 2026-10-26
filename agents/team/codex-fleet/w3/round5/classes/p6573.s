# n=5 model=out iset=I1 prefix14_class=6573
cmp P2, P1
cmovge S2, P2
mov S0, P3
cmovle S2, P1
cmovge P2, P1
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmp S0, S2
cmovl P1, S2
mov S1, P0
cmovl S2, S0
cmovl S0, P1
mov P3, S2
