# n=5 model=out iset=I1 prefix14_class=13996
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovl P1, S0
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
mov S2, P2
cmovg P3, S0
cmp P3, P1
mov S1, P3
cmovl S1, P1
cmovg P3, P1
cmp P2, P0
