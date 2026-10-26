# n=5 model=out iset=I1 prefix14_class=3131
cmp P0, P3
mov S0, P1
cmovle S1, P0
cmovg S1, P3
cmovg P3, P0
cmp P2, P1
cmovg S0, P2
cmovl P1, P2
cmp P1, S1
cmovge P0, P1
cmovg P1, S1
cmovle P0, S1
cmp S0, P3
cmovge P2, P3
