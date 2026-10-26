# n=5 model=out iset=I1 prefix14_class=8968
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
cmp P0, P3
cmovle P1, P0
cmovle P0, P3
cmovle P3, P1
mov S1, S0
cmp P0, S0
cmovg S0, P0
cmovle S1, P0
cmp P2, P3
mov S0, P2
