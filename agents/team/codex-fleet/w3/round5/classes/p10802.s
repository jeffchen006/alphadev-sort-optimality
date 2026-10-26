# n=5 model=out iset=I1 prefix14_class=10802
cmp P0, P2
mov S1, P3
cmovg S0, P2
cmovge P2, P0
cmovle S0, P0
cmp P3, P1
cmovle P3, P1
cmovl P1, S1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp S0, P1
cmovle S2, P1
