# n=5 model=out iset=I1 prefix14_class=72
cmp P3, P0
mov S1, P3
cmovl P3, P0
mov S0, P1
cmovg S1, P0
cmp P2, P1
cmovle S0, P2
cmovg P1, P2
cmp S0, S1
mov P0, P1
cmovge P2, S0
cmovge S0, S1
cmovg S1, P2
cmp P0, P3
