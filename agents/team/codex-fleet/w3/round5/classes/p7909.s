# n=5 model=out iset=I1 prefix14_class=7909
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovl P3, S0
mov S1, P1
cmp P0, P1
cmovl S1, P0
cmovg P1, P0
cmovg P0, S1
cmp P3, P0
cmovge P0, P3
cmovl S1, P3
cmp P1, P2
cmovl S1, P1
