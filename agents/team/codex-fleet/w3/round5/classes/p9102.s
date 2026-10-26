# n=5 model=out iset=I1 prefix14_class=9102
mov S1, P0
cmp S1, P2
cmovl P0, P2
mov S0, P1
cmovg S1, P2
cmp P1, P3
cmovl P1, P3
cmovge S0, P3
mov S2, S0
cmp S0, S1
cmovle S0, S1
cmovle S1, S2
cmp P0, P1
cmovge P3, P1
