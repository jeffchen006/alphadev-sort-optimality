# n=5 model=out iset=I1 prefix14_class=11652
cmp P3, P0
cmovle S2, P0
mov S1, P2
cmovle P0, P3
cmovl P3, S2
cmp P1, S1
cmovle S1, P1
cmovl P1, P2
cmp P1, P3
mov S0, P3
cmovle P3, P1
cmovg S0, P1
cmp S1, P0
cmovge P2, S1
