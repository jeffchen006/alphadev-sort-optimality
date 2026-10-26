# n=5 model=out iset=I1 prefix14_class=2420
mov S1, P1
cmp P1, P0
cmovg P1, P0
mov S2, P3
cmovge P0, S1
cmp P2, P3
mov S0, P0
cmovl P3, P2
cmovg S2, P2
cmp S0, S2
cmovge P0, S2
cmovge S2, S0
cmp P3, P1
cmovle S2, P1
