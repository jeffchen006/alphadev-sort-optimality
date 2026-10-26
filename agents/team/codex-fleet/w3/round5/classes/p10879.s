# n=5 model=out iset=I1 prefix14_class=10879
cmp P0, P2
mov S2, P0
cmovle P0, P2
cmovg S2, P2
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
mov S0, P1
cmovg P3, S1
cmp S0, P0
cmovge P1, P0
cmovge P0, S0
cmp S2, P3
cmovl S0, P3
