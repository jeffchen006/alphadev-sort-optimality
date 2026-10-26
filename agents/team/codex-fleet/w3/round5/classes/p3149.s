# n=5 model=out iset=I1 prefix14_class=3149
mov S2, P1
cmp P2, S2
cmovge P1, P2
mov S0, P0
cmovl S2, P2
cmp S0, P3
cmovg S0, P3
mov S1, S2
cmovg P3, P0
cmp S1, S0
cmovle S1, S0
cmovg S2, S0
cmp P1, P3
cmovge P2, P3
