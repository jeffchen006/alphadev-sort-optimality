# n=5 model=out iset=I1 prefix14_class=1857
mov S2, P1
mov S1, P2
cmp P3, P1
cmovl S2, P3
cmovg P1, P3
cmp P0, S1
cmovge P2, P0
cmovge P0, S1
mov S0, P2
cmp S0, P1
cmovl S0, P1
cmovle P1, P2
cmp S2, P0
cmovle S0, S2
