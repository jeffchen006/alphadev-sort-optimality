# n=5 model=out iset=I1 prefix14_class=3426
cmp P1, P2
cmovle S0, P2
cmovg S0, P1
cmovl P2, P1
cmp P0, P3
cmovge S1, P3
cmovg P3, P0
cmovge P0, S1
mov P1, P2
cmp P0, P1
cmovl P1, P0
mov S2, P3
cmovge P2, P0
cmp S0, S2
