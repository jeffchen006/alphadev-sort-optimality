# n=5 model=out iset=I1 prefix14_class=4916
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovle P0, S0
cmp P3, P2
cmovge S0, P2
mov S1, P1
cmovle S0, P3
cmovle P3, P2
cmp P1, S0
cmovge S1, S0
cmovl P1, S0
cmp P3, P0
cmovl S0, P0
