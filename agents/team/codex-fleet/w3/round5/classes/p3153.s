# n=5 model=out iset=I1 prefix14_class=3153
mov S0, P0
mov S1, P1
cmp P2, S1
cmovle S1, P2
cmovg P1, P2
mov S2, S1
cmp S0, P3
cmovge P0, P3
cmovg P3, S0
cmp S1, P0
cmovg S2, P0
cmovl S1, P0
cmp P1, P3
mov S0, S1
