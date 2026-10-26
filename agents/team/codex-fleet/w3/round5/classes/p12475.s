# n=5 model=out iset=I1 prefix14_class=12475
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovle P1, P2
mov S0, S1
cmp P0, P3
mov S2, P1
cmovle P2, P3
cmovl P3, P0
cmovl P0, P2
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmp P0, S1
