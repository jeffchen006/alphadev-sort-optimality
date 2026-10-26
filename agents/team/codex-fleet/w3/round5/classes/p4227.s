# n=5 model=out iset=I1 prefix14_class=4227
cmp P0, P1
mov S1, P1
cmovg S1, P0
cmovge P0, P1
mov S0, P2
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmovge S2, P3
cmp S0, S1
cmovge P1, S0
