# n=5 model=out iset=I1 prefix14_class=4474
cmp P3, P0
cmovge S2, P0
cmovle S2, P3
mov S0, P1
cmovle P3, P0
cmp P1, P2
cmovl P1, P2
cmovl P2, S0
cmp P3, P1
cmovg S1, P1
cmovg P1, P3
cmovle S1, P3
cmp P2, S2
cmovge P0, P2
