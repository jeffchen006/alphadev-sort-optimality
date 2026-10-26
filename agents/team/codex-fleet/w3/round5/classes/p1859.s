# n=5 model=out iset=I1 prefix14_class=1859
mov S2, P1
mov S1, P2
cmp P3, S2
cmovl P1, P3
cmovg S2, P3
cmp P0, S1
cmovge P2, P0
cmovge P0, S1
mov S0, P2
cmp S0, S2
cmovle S0, S2
cmovle S2, P2
cmp P0, P1
cmovle S0, P0
