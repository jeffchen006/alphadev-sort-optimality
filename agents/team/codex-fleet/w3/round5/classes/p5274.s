# n=5 model=out iset=I1 prefix14_class=5274
mov S2, P0
cmp S2, P2
cmovg P0, P2
cmovl S2, P2
mov P2, P1
mov S0, P0
cmp P3, P2
cmovge P1, P3
cmovl P2, P3
cmp S0, P2
cmovle P0, P2
cmovg S0, P2
cmp P1, S2
cmovge P3, P1
