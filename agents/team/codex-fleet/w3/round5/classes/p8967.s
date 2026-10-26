# n=5 model=out iset=I1 prefix14_class=8967
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
cmp P3, P0
cmovle P1, P3
cmovle P3, P0
cmovle P0, P1
mov S1, S0
cmp P3, S0
cmovg S0, P3
cmovle S1, P3
cmp P2, P0
mov S0, P2
