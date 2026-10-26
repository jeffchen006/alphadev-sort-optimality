# n=5 model=out iset=I1 prefix14_class=4635
mov S0, P3
mov S1, P1
cmp P2, S1
cmovl P1, P2
cmovge S1, P2
cmp P0, S0
cmovl P3, P0
cmovle P0, S0
cmp P0, S1
mov S2, P0
cmovl P0, S1
cmovg S2, S1
cmp P1, P3
cmovle P2, P3
