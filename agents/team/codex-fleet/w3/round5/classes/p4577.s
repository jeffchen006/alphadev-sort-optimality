# n=5 model=out iset=I1 prefix14_class=4577
cmp P2, P3
mov S1, P0
mov S2, P2
cmovg S2, P3
cmovge P3, P2
cmp S1, P1
cmovge S1, P1
cmovl P0, P1
mov S0, P0
cmp P3, P0
cmovg P0, P3
cmovle S0, P3
cmp S1, S2
cmovge P0, S2
