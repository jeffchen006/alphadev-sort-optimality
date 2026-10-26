# n=5 model=out iset=I1 prefix14_class=1936
mov S2, P2
mov S0, P3
cmp P1, P3
cmovle P3, P1
cmovl P1, S0
cmp P0, P2
cmovl P2, P0
cmovl P0, S2
cmp P0, P1
cmovg S2, P1
cmovle S2, P0
cmovge P1, P0
cmp P3, P2
cmovge S1, P3
