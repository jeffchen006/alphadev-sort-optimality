# n=5 model=out iset=I1 prefix14_class=12840
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
mov S2, P3
cmovg S0, P2
mov P2, S0
cmp P3, P1
cmovge S2, P1
cmovl P3, P1
cmp P2, S2
cmovge P2, S2
cmovle S0, S2
cmp P0, P3
cmovge S2, S0
