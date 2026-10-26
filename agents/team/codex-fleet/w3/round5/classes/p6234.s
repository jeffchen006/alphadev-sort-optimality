# n=5 model=out iset=I1 prefix14_class=6234
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovge S2, P0
cmp P1, P2
mov S1, P2
cmovg S1, P1
cmovg P1, P2
mov S0, S1
cmp P3, S1
cmovg S0, P3
cmovle S1, P3
mov P3, P1
cmp S2, P3
