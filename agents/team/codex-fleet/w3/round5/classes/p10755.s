# n=5 model=out iset=I1 prefix14_class=10755
mov S0, P2
cmp P1, P2
cmovl S0, P1
cmovge P2, P1
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
cmovl P0, S2
mov P1, P3
cmp P3, P2
cmovle P3, P2
cmovle P2, P1
cmp S0, P0
mov P1, P0
