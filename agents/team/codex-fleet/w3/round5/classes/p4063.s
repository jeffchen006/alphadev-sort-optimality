# n=5 model=out iset=I1 prefix14_class=4063
mov S0, P0
cmp P1, S0
mov S2, P3
cmovge P0, P1
cmovle S0, P1
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
mov S1, S0
cmp S0, P2
cmovg S0, P2
cmovle S1, P2
cmp P0, S2
cmovge P3, S2
