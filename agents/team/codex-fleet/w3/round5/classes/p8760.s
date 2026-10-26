# n=5 model=out iset=I1 prefix14_class=8760
cmp P3, P1
mov S2, P1
cmovle S2, P3
cmovl P3, P1
cmp P2, P0
mov P1, P0
cmovge P1, P2
cmovl P0, P2
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P0, S2
cmovg S0, P0
