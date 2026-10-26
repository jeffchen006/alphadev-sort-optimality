# n=5 model=out iset=I1 prefix14_class=9005
mov S1, P2
mov S2, P1
cmp P3, S1
cmovg S1, P3
cmovge P3, P2
cmp P0, P1
cmovle S2, P0
cmovl P0, P1
cmp S1, P0
cmovge S0, P0
mov P2, S2
cmovge P0, S1
cmovge S1, S0
mov P0, S1
