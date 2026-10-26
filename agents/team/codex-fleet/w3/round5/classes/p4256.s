# n=5 model=out iset=I1 prefix14_class=4256
mov S1, P0
cmp P2, P0
cmovle S1, P2
cmovge P0, P2
mov S0, P1
cmp P3, S0
cmovg S0, P3
cmovg P3, P1
cmp P3, S1
cmovl P1, S1
cmovle S1, P3
cmovge P1, P3
cmp P0, S0
cmovge S2, P0
