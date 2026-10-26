# n=5 model=out iset=I1 prefix14_class=2284
cmp P3, P2
mov S0, P0
cmovg S1, P2
cmovle S1, P3
cmovl P3, P2
mov S2, P3
cmp S0, P1
cmovle S0, P1
cmovge P0, P1
cmp S2, S0
cmovle P3, S0
mov P3, P0
cmovle S0, S2
cmp S1, P3
