# n=5 model=out iset=I1 prefix14_class=8398
cmp P0, P1
mov S1, P1
cmovl P1, P0
cmovge S1, P0
cmp P2, P3
mov S0, S1
mov S2, P3
cmovg S2, P2
cmovge P2, P3
cmp S0, S2
cmovle S0, S2
cmovge S1, S2
cmp P2, P1
cmovle S0, P1
