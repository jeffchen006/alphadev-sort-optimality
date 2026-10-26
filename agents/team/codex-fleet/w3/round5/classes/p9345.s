# n=5 model=out iset=I1 prefix14_class=9345
mov S2, P0
cmp P2, P0
mov S1, P3
cmovle P0, P2
cmovl P2, S2
cmp P1, S1
cmovl S1, P1
cmovle P1, P3
cmp S1, P0
cmovge P3, P0
cmovge P0, S1
cmovge S1, P3
mov S0, P1
cmp P2, P1
