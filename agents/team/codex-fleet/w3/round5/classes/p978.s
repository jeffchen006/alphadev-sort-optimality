# n=5 model=out iset=I1 prefix14_class=978
cmp P0, P1
mov S2, P2
cmovle S1, P1
cmovl P1, P0
cmovge S1, P0
cmp P2, P3
cmovg S2, P3
cmovg P3, P2
cmp S1, P3
cmovg S0, P3
mov P0, P1
cmovge P3, S1
cmovg S1, S0
cmp S2, P0
