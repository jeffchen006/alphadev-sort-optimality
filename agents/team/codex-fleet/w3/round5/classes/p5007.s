# n=5 model=out iset=I1 prefix14_class=5007
mov S0, P1
mov S2, P3
cmp P1, P2
cmovl P1, P2
cmovle P2, S0
cmp P0, S2
cmovge S2, P0
cmovle P3, P0
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovl P3, S1
mov P2, S2
cmp P2, P1
