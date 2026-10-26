# n=5 model=out iset=I1 prefix14_class=4531
mov S0, P1
cmp P0, P2
cmovg S1, P0
cmovle S1, P2
cmovge P0, P2
cmp S0, P3
cmovge S0, P3
cmovl P1, P3
cmp S1, P1
cmovge P3, S1
cmovg S1, P1
cmovg P1, P3
cmp P0, S0
cmovge P2, P0
