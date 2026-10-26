# n=5 model=out iset=I1 prefix14_class=3881
cmp P2, P3
mov S1, P2
cmovg P2, P3
mov S0, P0
cmovg P3, S1
cmp S0, P1
mov S1, P2
cmovle P0, P1
cmovle P1, S0
cmp S1, P1
cmovl S1, P1
cmovl P1, P2
cmp P3, P0
cmovge P1, P3
