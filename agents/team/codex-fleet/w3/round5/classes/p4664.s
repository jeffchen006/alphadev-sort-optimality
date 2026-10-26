# n=5 model=out iset=I1 prefix14_class=4664
cmp P3, P0
cmovge S0, P0
mov S1, P2
cmovg P0, P3
cmovg P3, S0
mov S2, P3
cmp P1, S1
cmovl P2, P1
cmovl P1, S1
cmovg S1, P1
cmp P1, P0
cmovge P1, P0
cmovle S1, P0
cmp S2, P2
