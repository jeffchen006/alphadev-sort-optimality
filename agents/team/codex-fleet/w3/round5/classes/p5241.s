# n=5 model=out iset=I1 prefix14_class=5241
cmp P1, P2
mov S0, P3
cmovg S1, P1
cmovge P1, P2
cmovg P2, S1
cmp P0, S0
cmovle S0, P0
mov S2, S0
cmovl P0, P3
cmp S0, P1
cmovge S2, P1
mov P3, P0
cmovge P1, S0
cmp P2, P3
