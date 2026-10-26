# n=5 model=out iset=I1 prefix14_class=939
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovge S0, P0
mov S2, P3
cmp P3, P1
cmovge P3, P1
cmovge P1, S2
cmp P1, S0
cmovle S1, S0
cmovg S1, P1
cmovl S0, P1
cmovg P1, S0
mov S2, P2
