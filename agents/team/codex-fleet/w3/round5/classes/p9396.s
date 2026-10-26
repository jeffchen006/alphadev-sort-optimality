# n=5 model=out iset=I1 prefix14_class=9396
cmp P1, P2
mov S0, P2
mov S2, P0
cmovg S0, P1
cmovge P1, P2
cmp P3, S2
cmovle S2, P3
cmovl P3, P0
cmp P1, S2
cmovge P0, P1
cmovg P1, S2
cmovge S2, P0
cmp S0, P3
cmovge S1, S0
