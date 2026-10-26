# n=5 model=out iset=I1 prefix14_class=5444
cmp P2, P1
mov S0, P0
mov S2, P2
cmovg S2, P1
cmovle P2, P1
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
cmp P3, S2
mov S1, S2
cmovl S2, P3
cmovg S1, P3
cmp S0, P2
cmovle P1, S0
