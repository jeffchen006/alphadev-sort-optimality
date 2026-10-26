# n=5 model=out iset=I1 prefix14_class=532
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
mov S0, P1
mov S2, P2
cmovg P3, S1
cmp P2, P0
cmovge P2, P0
cmovg P0, S2
cmp P2, P1
cmovl S0, P2
cmovle P2, P1
cmovg P1, P2
cmp P0, P3
