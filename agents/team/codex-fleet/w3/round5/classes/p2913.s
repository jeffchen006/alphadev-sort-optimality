# n=5 model=out iset=I1 prefix14_class=2913
cmp P1, P0
cmovg S1, P0
cmovge P0, P1
cmovle S1, P1
mov S0, P0
mov S2, P3
cmp P2, S2
cmovge S2, P2
cmovg P2, P3
cmp S2, S0
cmovle P0, S2
cmovl S2, S0
cmp S1, P2
cmovg S0, P0
