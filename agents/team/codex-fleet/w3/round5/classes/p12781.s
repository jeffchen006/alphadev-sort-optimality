# n=5 model=out iset=I1 prefix14_class=12781
cmp P0, P1
cmovg S2, P0
cmovge P0, P1
cmovg P1, S2
mov S1, P0
mov S0, P2
cmp P3, S0
cmovle S0, P3
cmovl P3, P2
cmp P0, S0
cmovge S1, S0
mov S1, P3
cmovge S0, P0
cmp P3, P1
