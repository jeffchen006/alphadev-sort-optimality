# n=5 model=out iset=I1 prefix14_class=4205
mov S1, P1
cmp P2, S1
cmovle P1, P2
cmovg S1, P2
mov P2, P3
cmp P3, P0
mov S0, P1
cmovl P3, P0
cmovle P0, P2
cmp P0, P1
cmovl S0, P0
mov S0, P3
cmovge P1, P0
cmp P3, S1
