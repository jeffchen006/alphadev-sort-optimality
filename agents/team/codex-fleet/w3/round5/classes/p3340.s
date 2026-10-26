# n=5 model=out iset=I1 prefix14_class=3340
mov S1, P1
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
cmovge P0, P3
cmp P2, P1
mov S0, S2
cmovl P1, P2
cmovg S1, P2
cmp S0, P1
cmovge S0, P1
cmovg P1, S2
cmp P0, S1
cmovle S2, P0
