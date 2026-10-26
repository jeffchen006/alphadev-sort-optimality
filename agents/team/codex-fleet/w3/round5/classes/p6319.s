# n=5 model=out iset=I1 prefix14_class=6319
mov S1, P2
cmp P1, P0
mov S0, P1
cmovg S0, P0
cmovge P0, P1
cmp P2, P3
cmovl P2, P3
cmovle P3, S1
cmp P2, P0
cmovle S2, P2
cmovg S2, P0
cmovle P2, P0
cmp S0, P3
cmovg S1, P3
