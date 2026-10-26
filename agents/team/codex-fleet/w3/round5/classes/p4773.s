# n=5 model=out iset=I1 prefix14_class=4773
cmp P1, P2
mov S0, P1
cmovl P1, P2
cmovl P2, S0
mov S2, P0
cmp S2, P3
cmovle S2, P3
cmovge P0, P3
cmp P0, P2
cmovg S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P1, S2
cmovle S1, P1
