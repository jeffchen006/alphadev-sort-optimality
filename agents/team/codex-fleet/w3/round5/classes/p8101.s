# n=5 model=out iset=I1 prefix14_class=8101
cmp P1, P0
cmovg S2, P0
cmovle S2, P1
cmovl P1, P0
mov S0, P3
cmp P2, S0
cmovge S0, P2
cmovge P2, P3
mov S1, S2
cmp P2, S1
cmovle S1, P2
cmovl S1, S0
cmovle P2, S2
cmp P1, S0
