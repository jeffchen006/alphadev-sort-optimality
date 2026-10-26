# n=5 model=out iset=I1 prefix14_class=10679
cmp P3, P2
mov S0, P2
cmovl P2, P3
cmovle P3, S0
mov S1, P0
cmp P0, P1
cmovge P0, P1
cmovl S1, P1
cmp P3, S1
cmovl S0, S1
cmovle S1, P3
cmovl P3, S0
cmp P0, P2
cmovle P1, P0
