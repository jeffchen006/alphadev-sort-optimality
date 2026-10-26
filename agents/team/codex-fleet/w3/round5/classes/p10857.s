# n=5 model=out iset=I1 prefix14_class=10857
cmp P0, P2
mov S2, P3
cmovle S1, P0
cmovle P0, P2
cmovge S1, P2
cmp P1, P3
cmovge P3, P1
cmovl S2, P1
cmp P3, P0
mov S0, S1
cmovle P1, P0
cmovle P0, P3
cmovl P3, P1
cmp S2, S0
