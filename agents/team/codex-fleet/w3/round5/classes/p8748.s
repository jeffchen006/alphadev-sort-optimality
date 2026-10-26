# n=5 model=out iset=I1 prefix14_class=8748
mov S0, P1
cmp P2, P1
mov S2, P0
cmovge P1, P2
cmovge P2, S0
cmp S2, P3
cmovl P0, P3
cmovle P3, S2
mov S1, P1
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
cmp P3, P2
mov P1, S1
