# n=5 model=out iset=I1 prefix14_class=8272
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmovl S0, P1
mov S2, P2
cmp P0, S0
cmovge P1, P0
cmovg P0, S0
cmovg S0, P1
cmp P3, S2
