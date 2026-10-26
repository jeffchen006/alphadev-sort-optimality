# n=5 model=out iset=I1 prefix14_class=4713
mov S1, P1
cmp S1, P0
cmovl P1, P0
cmovg S1, P0
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
mov S0, P1
cmovle S2, P3
cmp S2, S0
cmovg S0, S2
cmovg S2, P1
cmp S1, P2
cmovge P0, S1
