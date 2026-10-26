# n=5 model=out iset=I1 prefix14_class=661
mov S1, P2
cmp P3, P2
mov S0, P1
cmovle P2, P3
cmovl P3, S1
cmp P1, P0
cmovl S0, P0
cmovge P1, P0
mov S1, P3
cmp P3, S0
cmovle S1, S0
cmovl S0, P3
cmp P1, P2
mov S1, P1
