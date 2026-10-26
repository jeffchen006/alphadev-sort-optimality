# n=5 model=out iset=I1 prefix14_class=12478
cmp P3, P1
mov S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P0, P2
mov S2, P1
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovge S0, P0
mov P3, S0
