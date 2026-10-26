# n=5 model=out iset=I1 prefix14_class=11027
cmp P2, P1
cmovg S2, P2
cmovge P2, P1
cmovle S2, P1
cmp P3, P0
cmovle P1, P3
cmovl P3, P0
cmovle P0, P1
mov S0, S2
cmp P3, S0
cmovg S2, P3
cmovle S0, P3
cmp P2, P0
cmovle P3, P0
