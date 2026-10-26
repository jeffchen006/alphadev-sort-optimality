# n=5 model=out iset=I1 prefix14_class=10856
cmp P2, P0
mov S2, P3
mov S1, P2
cmovle P2, P0
cmovge S1, P0
cmp P1, P3
cmovge P3, P1
cmovl S2, P1
cmp P3, P2
mov S0, S1
cmovle P1, P2
cmovle P2, P3
cmovl P3, P1
cmp S2, S0
