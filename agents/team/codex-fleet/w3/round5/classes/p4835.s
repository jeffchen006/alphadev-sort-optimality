# n=5 model=out iset=I1 prefix14_class=4835
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
mov S0, P2
cmovge P3, S1
cmp P1, P2
cmovg S0, P1
cmovle P2, P1
cmp P3, S2
mov S1, S0
