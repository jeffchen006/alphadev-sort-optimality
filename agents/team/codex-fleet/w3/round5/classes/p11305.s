# n=5 model=out iset=I1 prefix14_class=11305
cmp P0, P2
mov S0, P2
cmovle P2, P0
cmovle P0, S0
mov S2, P0
mov S1, P2
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
cmovl P1, S0
cmp P0, P3
cmovg S2, P3
cmovge P3, P0
cmp P1, P2
