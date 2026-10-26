# n=5 model=out iset=I1 prefix14_class=10085
cmp P3, P0
mov S0, P0
cmovle S0, P3
mov S2, P1
cmovl P3, P0
cmp P2, S2
mov S1, P3
cmovg S2, P2
cmovge P2, P1
cmp P3, S2
cmovge P3, S2
cmovle S1, S2
cmp P2, S0
cmovle P0, P2
