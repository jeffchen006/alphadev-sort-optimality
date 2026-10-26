# n=5 model=out iset=I1 prefix14_class=937
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P3, P1
mov S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P1, S2
mov S0, P1
cmovg P1, S2
cmovl S0, S2
mov S0, P2
cmp P3, P2
