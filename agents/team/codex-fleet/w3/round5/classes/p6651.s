# n=5 model=out iset=I1 prefix14_class=6651
cmp P1, P0
cmovg S0, P0
mov S2, P3
cmovge P0, P1
cmovg P1, S0
cmp P2, P3
cmovg P3, P2
cmovg P2, S2
cmp P3, P0
mov S0, P3
cmovg P3, P0
cmovl S0, P0
cmp P1, P2
cmovle P0, P2
