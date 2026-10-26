# n=5 model=out iset=I1 prefix14_class=10052
mov S1, P0
cmp P0, P2
cmovle P0, P2
mov S0, P1
cmovl P2, S1
cmp P3, S0
cmovle S0, P3
cmovl P3, P1
cmp P0, P3
cmovg S1, P3
cmovge P3, P0
cmovg P0, S1
mov S2, P2
cmp S0, S2
