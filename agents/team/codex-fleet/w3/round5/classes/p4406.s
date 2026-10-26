# n=5 model=out iset=I1 prefix14_class=4406
cmp P0, P3
cmovle S2, P3
mov S1, P1
cmovg S2, P0
cmovg P0, P3
cmp S1, P2
cmovl P1, P2
cmovge S1, P2
cmp P1, S2
mov S0, S2
cmovge S0, P1
mov P2, P0
cmovge P1, S2
mov S0, P1
