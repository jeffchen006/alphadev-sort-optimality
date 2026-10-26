# n=5 model=out iset=I1 prefix14_class=2102
mov S1, P1
cmp P2, S1
cmovl P1, P2
cmovg S1, P2
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
cmovge P3, P0
mov S0, S2
cmp S1, S0
cmovge S2, S1
mov S2, P3
cmovge S1, S0
mov P0, S1
