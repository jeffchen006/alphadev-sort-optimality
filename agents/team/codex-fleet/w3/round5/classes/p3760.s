# n=5 model=out iset=I1 prefix14_class=3760
mov S1, P1
cmp P2, S1
cmovle S1, P2
cmovge P1, P2
mov S2, P0
cmp P3, S2
cmovg S2, P3
cmovge P3, P0
mov S0, S1
cmp S0, P3
cmovle S1, P3
cmovl P3, S0
cmp P1, S2
cmovge P0, S2
