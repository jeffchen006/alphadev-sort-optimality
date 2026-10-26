# n=5 model=out iset=I1 prefix14_class=8023
mov S2, P0
cmp S2, P3
mov S1, P1
cmovg S2, P3
cmovl P0, P3
cmp S1, P2
cmovge P1, P2
cmovle S1, P2
mov S0, S2
cmp S2, P1
cmovle S0, P1
cmovl P1, S2
cmp S1, P0
cmovle S2, S1
