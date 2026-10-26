# n=5 model=out iset=I1 prefix14_class=10053
mov S1, P0
cmp P0, P3
cmovle P0, P3
mov S0, P1
cmovl P3, S1
cmp P2, S0
cmovle S0, P2
cmovl P2, P1
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
mov S2, P3
cmp S0, S2
