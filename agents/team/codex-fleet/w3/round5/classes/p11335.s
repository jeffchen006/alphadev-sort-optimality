# n=5 model=out iset=I1 prefix14_class=11335
cmp P1, P3
mov S1, P2
mov S0, P3
cmovle P3, P1
cmovl P1, S0
cmp P0, S1
cmovg P2, P0
cmovge P0, S1
cmp P2, P1
cmovl S1, P2
cmovle P2, P1
cmovl P1, S1
mov P2, P0
cmp P3, P0
