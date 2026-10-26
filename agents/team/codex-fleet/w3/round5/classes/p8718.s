# n=5 model=out iset=I1 prefix14_class=8718
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmovg P3, S2
mov S0, P0
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
mov P0, S0
cmp P3, P0
cmovl P0, P3
cmovge S0, P3
cmp P1, P2
mov S1, P0
