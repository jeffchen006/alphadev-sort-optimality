# n=5 model=out iset=I1 prefix14_class=8686
mov S2, P2
cmp P1, S2
cmovle S2, P1
cmovge P2, P1
mov S1, P0
cmp S1, P3
cmovge P0, P3
cmovle S1, P3
cmp S1, P2
cmovle S0, P2
cmovg S0, S1
cmovl P2, S1
cmp S2, P0
cmovge S0, S2
