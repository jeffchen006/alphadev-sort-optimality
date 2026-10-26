# n=5 model=out iset=I1 prefix14_class=526
cmp P2, P1
mov S1, P3
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
cmp S1, P0
cmovg P3, P0
cmovg P0, S1
mov S1, P2
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
mov P2, P3
cmp P1, P0
