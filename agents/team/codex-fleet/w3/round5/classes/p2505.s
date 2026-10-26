# n=5 model=out iset=I1 prefix14_class=2505
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovle P3, S1
mov S2, P2
cmp P1, P2
mov S0, P3
cmovge S2, P1
cmovge P1, P2
cmp S0, S2
cmovl S0, S2
cmovl S2, P3
cmp P1, P0
cmovge S0, P1
