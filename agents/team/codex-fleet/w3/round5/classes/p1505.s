# n=5 model=out iset=I1 prefix14_class=1505
cmp P2, P3
mov S0, P3
cmovl S0, P2
cmovge P3, P2
cmp P0, P1
mov S2, P0
cmovg S2, P1
cmovge P1, P0
cmp S0, S2
cmovg P0, S0
cmovg S0, S2
cmovg S2, P0
cmp P3, P1
cmovle P2, P3
