# n=5 model=out iset=I1 prefix14_class=4535
cmp P0, P2
mov S1, P0
cmovge P0, P2
mov S0, P1
cmovle S1, P2
cmp S0, P3
cmovge S0, P3
cmovl P1, P3
cmp S1, P1
cmovg S2, S1
cmovg S1, P1
cmovg P1, S2
cmp P0, S0
cmovg S2, P0
