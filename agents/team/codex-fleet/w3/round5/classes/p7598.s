# n=5 model=out iset=I1 prefix14_class=7598
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
mov S2, P2
cmovle S0, P0
mov S1, P3
cmp P2, P1
cmovl P2, P1
cmovg S2, P1
cmp S1, S2
cmovle S1, S2
cmovle S2, P3
cmp S0, P2
mov S2, S1
