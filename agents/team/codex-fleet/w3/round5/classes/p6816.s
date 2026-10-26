# n=5 model=out iset=I1 prefix14_class=6816
cmp P1, P2
cmovge S2, P2
cmovl S2, P1
cmovle P1, P2
cmp P0, P3
mov P2, P3
cmovl P3, P0
cmovg P2, P0
cmp P2, P1
cmovge P0, P1
cmovge P1, P2
mov S0, P3
cmovge P2, P0
cmp S2, P3
