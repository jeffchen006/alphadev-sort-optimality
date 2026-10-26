# n=5 model=out iset=I1 prefix14_class=9701
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
cmovg P0, P1
mov S0, P2
cmp P3, S0
cmovg S0, P3
cmovge P3, P2
cmp S0, S2
cmovle P1, S2
cmovle S2, S0
mov S1, P3
cmovl S0, P1
cmp S1, P0
