# n=5 model=out iset=I1 prefix14_class=5539
cmp P0, P3
mov S0, P2
cmovg S1, P0
cmovle S1, P3
cmovg P0, P3
cmp S0, P1
cmovl P2, P1
cmovl P1, S0
cmp P0, P1
mov P3, P2
cmovge S2, P1
cmovge P1, P0
cmovge P0, S2
cmp P2, S1
