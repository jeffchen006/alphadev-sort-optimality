# n=5 model=out iset=I1 prefix14_class=10305
cmp P2, P3
cmovl S2, P3
cmovge S2, P2
cmovg P2, P3
mov S1, P1
cmp P0, P1
cmovg P1, P0
mov S0, P1
cmovge P0, S1
cmp S2, S0
cmovg S0, S2
cmovg S2, P1
cmp P0, P2
cmovle S0, P0
