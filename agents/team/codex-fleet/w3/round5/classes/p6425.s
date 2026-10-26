# n=5 model=out iset=I1 prefix14_class=6425
cmp P1, P0
mov S1, P1
cmovg P1, P0
cmovg P0, S1
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovge S0, P2
mov S2, S0
cmp P0, S2
cmovle S2, P0
cmovg S0, P0
cmp P3, P1
cmovge S0, P1
