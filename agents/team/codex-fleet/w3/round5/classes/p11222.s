# n=5 model=out iset=I1 prefix14_class=11222
mov S2, P0
cmp S2, P2
cmovle S2, P2
cmovg P0, P2
cmp P1, P3
cmovg S0, P3
cmovle S0, P1
cmovge P3, P1
cmp P3, S2
cmovg S1, S2
cmovle S1, P3
cmovl P3, S2
cmp S0, P0
cmovg P1, P0
