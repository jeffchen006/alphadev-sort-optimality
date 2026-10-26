# n=5 model=out iset=I1 prefix14_class=7657
mov S0, P2
cmp P3, S0
cmovle P2, P3
cmovge S0, P3
cmp P0, P1
cmovle S1, P0
mov P3, S0
cmovle P0, P1
cmovl P1, S1
mov S2, P1
cmp P1, P2
cmovl P1, P2
cmovl P2, S2
mov S2, P1
