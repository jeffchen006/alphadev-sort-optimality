# n=5 model=out iset=I1 prefix14_class=12328
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovle P2, S2
mov S0, P3
cmp P3, P1
cmovge S0, P1
cmovl P3, P1
cmp P2, S0
cmovl S1, P2
cmovge S1, S0
cmovl P2, S0
mov S0, P0
mov S1, P2
