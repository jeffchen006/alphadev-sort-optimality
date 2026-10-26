# n=5 model=out iset=I1 prefix14_class=3305
mov S2, P2
cmp P3, S2
cmovg S2, P3
cmovle P2, P3
mov S1, P0
cmp P0, P1
cmovge P0, P1
cmovle S1, P1
cmp P2, P0
mov S0, P2
cmovg S0, P0
cmovl P2, P0
cmp S2, S1
cmovge P3, S1
