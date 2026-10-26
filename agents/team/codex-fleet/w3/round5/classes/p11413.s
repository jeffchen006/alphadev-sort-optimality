# n=5 model=out iset=I1 prefix14_class=11413
mov S2, P0
cmp P3, S2
cmovle S2, P3
cmovl P3, P0
cmp P1, P2
cmovg S0, P2
mov S1, S2
cmovge P2, P1
cmovle S0, P1
cmp S2, S0
cmovg S2, S0
cmovle S1, S0
cmp P3, P2
cmovle S0, P3
