# n=5 model=out iset=I1 prefix14_class=1593
mov S1, P2
cmp S1, P1
cmovge S1, P1
mov S2, P0
cmovge P1, P2
cmp P3, S2
cmovl P0, P3
cmovg S2, P3
mov S0, S1
cmp S0, P0
cmovle S1, P0
cmovge S0, P0
cmp S2, P1
cmovg S0, P1
