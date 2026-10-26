# n=5 model=out iset=I1 prefix14_class=4164
cmp P0, P2
mov S1, P3
cmovle S2, P0
cmovge S2, P2
cmovge P2, P0
mov S0, S2
cmp P3, P1
cmovl P3, P1
cmovle P1, S1
cmp P1, S0
cmovg S2, P1
cmovle S0, P1
cmp P3, P2
cmovge P0, P3
