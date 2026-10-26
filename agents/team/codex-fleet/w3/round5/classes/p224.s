# n=5 model=out iset=I1 prefix14_class=224
cmp P0, P2
mov S1, P2
cmovle P2, P0
cmovge S1, P0
mov S0, P3
cmp P3, P1
cmovge P3, P1
cmovg P1, S0
cmp P3, P2
mov S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P1, S1
cmovl S2, P3
