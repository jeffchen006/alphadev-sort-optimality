# n=5 model=out iset=I1 prefix14_class=2995
mov S0, P1
mov S2, P0
cmp S0, P2
cmovl S0, P2
mov S1, S0
cmovle P2, P1
cmp P0, P3
cmovg S2, P3
cmovge P3, P0
cmp S0, P3
cmovg S0, P3
cmovge P3, S1
cmp S2, P2
cmovge P1, S2
