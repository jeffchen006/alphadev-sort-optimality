# n=5 model=out iset=I1 prefix14_class=10757
cmp P2, P0
mov S0, P0
cmovle S0, P2
cmovge P0, P2
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmovl P1, S2
mov S1, P3
cmp P3, P0
cmovle P3, P0
cmovle P0, S1
cmp P1, S0
cmovge S2, S0
