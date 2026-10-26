# n=5 model=out iset=I1 prefix14_class=11905
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
mov S0, P3
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmp P2, P1
mov P0, P1
