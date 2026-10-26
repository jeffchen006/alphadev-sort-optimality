# n=5 model=out iset=I1 prefix14_class=11846
mov S1, P2
cmp P2, P0
cmovle P2, P0
mov S0, P2
cmovl P0, S1
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovle P1, S1
cmp P3, P2
cmovge S0, P3
mov S0, P0
cmovl P2, P3
cmp P1, P0
