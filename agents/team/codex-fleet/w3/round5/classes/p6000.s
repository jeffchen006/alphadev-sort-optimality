# n=5 model=out iset=I1 prefix14_class=6000
mov S1, P0
mov S2, P3
cmp P3, P1
cmovg S2, P1
mov S0, S2
cmovle P3, P1
cmp P2, S1
cmovl S1, P2
cmovg P0, P2
cmp P3, P0
cmovge P1, P0
cmovg P0, P3
cmovge P3, P1
cmp S1, S2
