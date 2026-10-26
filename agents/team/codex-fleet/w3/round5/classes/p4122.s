# n=5 model=out iset=I1 prefix14_class=4122
mov S1, P0
cmp P2, S1
mov S0, P3
cmovl P0, P2
cmovg S1, P2
cmp P1, S0
cmovle S0, P1
cmovg P3, P1
cmp S0, P0
mov S2, P0
cmovge P0, S0
cmovge S0, S2
cmp S1, P3
cmovge P2, P3
